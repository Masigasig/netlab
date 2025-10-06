import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3, Vector4;

import 'package:netlab/core/routing/go_router.dart';
import 'package:netlab/core/utils/file_service.dart';

import 'package:netlab/simulation/core/enums.dart';
import 'package:netlab/simulation/provider/sim_screen_notifier.dart';
import 'package:netlab/simulation/widgets/conn_choice_panel.dart';
import 'package:netlab/simulation/widgets/control_button.dart';
import 'package:netlab/simulation/widgets/device_panel.dart';
import 'package:netlab/simulation/widgets/grid_painter.dart';
import 'package:netlab/simulation/widgets/info_panels/info_panel.dart';
import 'package:netlab/simulation/widgets/log_panel.dart';
import 'package:netlab/simulation/widgets/loop_animator.dart';
import 'package:netlab/simulation/widgets/setttings_popup.dart';
import 'package:netlab/simulation/widgets/sim_object_widget_stack.dart';

//* TODO's:
//* Finalize logs for each simobject
//* message osi model stack panel
//* Finalize unit of the speed of message
//? should we show the clock at top while playing?
//* Finalization of UI
//* Ip label of host
//? should we clear all logs at stop? or only the device log and keeping the system log
//? should we add a log even simulation is not playing?
//! 4 switch bug Implement STP - Spanning Tree Protocol

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

                    const ConnChoicePanel(),
                  ],
                ),
              );
            },
            onAcceptWithDetails: (details) => _createDevice(details),
          ),

          const LogPanel(),

          const InfoPanel(),

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
            onOpenSettings: _onOpenSetting,
            onOpenLogs: () =>
                ref.read(simScreenProvider.notifier).openLogPanel(),
            onCloseLogs: () =>
                ref.read(simScreenProvider.notifier).closeLogPanel(),
            onPlay: () => ref.read(simScreenProvider.notifier).playSimulation(),
            onStop: () => ref.read(simScreenProvider.notifier).stopSimulation(),
            onCenterView: _centerViewAnimated,
            onClearAll: _onClearAll,
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

  Future<void> _loadSimulation() async {
    final data = await FileService.loadFile();

    if (data != null) {
      ref.read(simScreenProvider.notifier).clearAll();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(simScreenProvider.notifier).importSimulation(data);
      });
    }
  }

  Future<void> _saveSimulation() async {
    final data = ref.read(simScreenProvider.notifier).exportSimulation();
    await FileService.saveFile(data);
  }

  void _onClearAll() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Reset'),
          content: const Text(
            'Are you sure you want to reset the canvas? This will clear all simulation data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(simScreenProvider.notifier).clearAll();
                Navigator.of(context).pop();
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _onOpenSetting() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SetttingsPopup();
      },
    );
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
