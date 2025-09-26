import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, Vector4;

import 'package:netlab/core/routing/go_router.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/provider/sim_screen_notifier.dart';
import 'package:netlab/simulation/widgets/control_button.dart';
import 'package:netlab/simulation/widgets/device_panel.dart';
import 'package:netlab/simulation/widgets/grid_painter.dart';
import 'package:netlab/simulation/widgets/log_panel.dart';
import 'package:netlab/simulation/widgets/loop_animator.dart';
import 'package:netlab/simulation/widgets/sim_object_widget_stack.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  static const canvasSize = Size(100_000.0, 100_000.0);
  const SimulationScreen({super.key});

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  final _transformationController = TransformationController();
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transformationController.value = _getCenteredMatrix();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPushNext() {
    _onExit();
    super.didPushNext();
  }

  @override
  void didPop() {
    _onExit();
    super.didPop();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('SimulationScreen Widget rebuilt');
    return Scaffold(
      body: Stack(
        children: [
          const LoopAnimator(),
          DragTarget<SimObjectType>(
            builder: (context, candidateData, rejectedData) {
              return InteractiveViewer(
                transformationController: _transformationController,
                constrained: false,
                minScale: 0.3,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: SimulationScreen.canvasSize,
                      painter: GridPainter(
                        colorScheme: Theme.of(context).colorScheme,
                      ),
                    ),

                    const SimObjectWidgetStack(type: SimObjectType.connection),
                    const SimObjectWidgetStack(type: SimObjectType.host),
                    const SimObjectWidgetStack(type: SimObjectType.switch_),
                    const SimObjectWidgetStack(type: SimObjectType.router),
                    const SimObjectWidgetStack(type: SimObjectType.message),
                  ],
                ),
              );
            },
            onAcceptWithDetails: (details) => _createDevice(details),
          ),

          const LogPanel(),

          const DevicePanel(),

          AddDeviceButton(
            onOpen: () =>
                ref.read(simScreenProvider.notifier).openDevicePanel(),
            onClose: () =>
                ref.read(simScreenProvider.notifier).closeDevicePanel(),
          ),

          UtilityControls(
            onExit: () => GoRouter.of(context).pop(),
            onSave: _saveSimulation,
            onLoad: _loadSimulation,
          ),

          SimulationControls(
            onOpenLogs: () =>
                ref.read(simScreenProvider.notifier).openLogPanel(),
            onCloseLogs: () =>
                ref.read(simScreenProvider.notifier).closeLogPanel(),
            onPlay: () => ref.read(simScreenProvider.notifier).playSimulation(),
            onStop: () => ref.read(simScreenProvider.notifier).stopSimulation(),
            onCenterView: _centerViewAnimated,
          ),
        ],
      ),
    );
  }

  Matrix4 _getCenteredMatrix() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return Matrix4.identity()
      ..translateByVector3(Vector3(size.width / 2, size.height / 2, 0.0))
      ..translateByVector3(
        Vector3(
          -SimulationScreen.canvasSize.width / 2,
          -SimulationScreen.canvasSize.height / 2,
          0.0,
        ),
      );
  }

  void _centerViewAnimated() {
    final animation =
        Matrix4Tween(
          begin: _transformationController.value,
          end: _getCenteredMatrix(),
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    _animationController
      ..addListener(() => _transformationController.value = animation.value)
      ..forward(from: 0);
  }

  void _createDevice(DragTargetDetails details) {
    final Matrix4 inverse = Matrix4.copy(_transformationController.value)
      ..invert();
    final Vector4 pos = inverse.transform(
      Vector4(details.offset.dx, details.offset.dy, 0, 1),
    );

    ref
        .read(simScreenProvider.notifier)
        .createDevice(type: details.data, posX: pos.x, posY: pos.y);
  }

  void _loadSimulation() {
    //* TODO: loadSimulation
  }

  void _saveSimulation() {
    //* TODO: SaveSimulation
  }

  void _onExit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(simScreenProvider).isPlaying) {
        ref.read(simScreenProvider.notifier).stopSimulation();
      }
      ref.read(simScreenProvider.notifier).closeDevicePanel();
      ref.read(simScreenProvider.notifier).closeLogPanel();
    });
  }
}
