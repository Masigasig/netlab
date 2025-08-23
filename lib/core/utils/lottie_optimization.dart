import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:netlab/core/constants/app_colors.dart';

/// error handling, and performance optimizations.
class OptimizedLottieWidget extends StatefulWidget {
  /// Path to the Lottie asset file
  final String assetPath;
  
  /// Width of the Lottie animation
  final double? width;
  
  /// Height of the Lottie animation
  final double? height;
  
  /// BoxConstraints for the Lottie animation
  final BoxConstraints? constraints;
  
  /// How to fit the animation within its bounds
  final BoxFit fit;
  
  /// Alignment of the animation
  final Alignment alignment;
  
  /// Whether the animation should repeat
  final bool repeat;
  
  /// Whether the animation should reverse after completing
  final bool reverse;
  
  /// Whether the animation should start automatically
  final bool animate;
  
  /// Frame rate for the animation (null = device refresh rate)
  final FrameRate? frameRate;
  
  /// Custom loading widget (optional)
  final Widget? loadingWidget;
  
  /// Custom error widget (optional)
  final Widget? errorWidget;
  
  /// Background color for loading/error states
  final Color? backgroundColor;
  
  /// Border radius for loading/error states
  final BorderRadius? borderRadius;
  
  /// Show loading/error text
  final bool showStatusText;
  
  /// Custom error message
  final String? errorMessage;

  const OptimizedLottieWidget({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.constraints,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.repeat = true,
    this.reverse = false,
    this.animate = true,
    this.frameRate,
    this.loadingWidget,
    this.errorWidget,
    this.backgroundColor,
    this.borderRadius,
    this.showStatusText = true,
    this.errorMessage,
  });

  @override
  State<OptimizedLottieWidget> createState() => _OptimizedLottieWidgetState();
}

class _OptimizedLottieWidgetState extends State<OptimizedLottieWidget>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  
  late final Future<LottieComposition> _compositionFuture;
  AnimationController? _animationController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _compositionFuture = _loadComposition();
    
    // Create animation controller if needed for manual control
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Default duration
    );
    
    if (widget.animate) {
      _animationController?.forward();
    }
  }

  @override
  void dispose() {
    if (_animationController?.isAnimating ?? false) {
      _animationController?.stop();
    }
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(OptimizedLottieWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        if (widget.repeat) {
          _animationController?.repeat();
        } else {
          _animationController?.forward();
        }
      } else {
        _animationController?.stop();
      }
    }
  }

  Future<LottieComposition> _loadComposition() async {
    try {
      return await AssetLottie(widget.assetPath).load();
    } catch (e) {
      debugPrint('Failed to load Lottie composition: ${widget.assetPath} - $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    Widget lottieWidget = FutureBuilder<LottieComposition>(
      future: _compositionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }
        
        if (snapshot.hasError || !snapshot.hasData) {
          return _buildErrorState();
        }

        return _buildLottieAnimation(snapshot.data!);
      },
    );

    // Apply size constraints
    if (widget.constraints != null) {
      lottieWidget = ConstrainedBox(
        constraints: widget.constraints!,
        child: lottieWidget,
      );
    } else if (widget.width != null || widget.height != null) {
      lottieWidget = SizedBox(
        width: widget.width,
        height: widget.height,
        child: lottieWidget,
      );
    }

    return lottieWidget;
  }

  Widget _buildLottieAnimation(LottieComposition composition) {
    // Set the animation duration based on composition
    _animationController?.duration = composition.duration;
    
    if (widget.animate && widget.repeat && _animationController?.status != AnimationStatus.forward) {
      _animationController?.repeat();
    }

    return RepaintBoundary(
      child: Lottie(
        composition: composition,
        controller: widget.repeat ? null : _animationController, // Only use controller for non-repeating animations
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
        repeat: widget.repeat,
        reverse: widget.reverse,
        animate: widget.animate,
        frameRate: widget.frameRate ?? const FrameRate(30), // Limit to 30fps for better performance
        options: LottieOptions(
          enableApplyingOpacityToLayers: false, // Better performance
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    if (widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? 
               AppColors.textSecondary.withOpacity(0.05),
        borderRadius: widget.borderRadius ?? 
                      BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
          ),
          if (widget.showStatusText) ...[
            const SizedBox(height: 12),
            Text(
              'Loading animation...',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? 
               AppColors.textSecondary.withOpacity(0.05),
        borderRadius: widget.borderRadius ?? 
                      BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.animation_outlined,
            size: 48,
            color: AppColors.textSecondary.withOpacity(0.4),
          ),
          if (widget.showStatusText) ...[
            const SizedBox(height: 8),
            Text(
              widget.errorMessage ?? 'Animation not available',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Manual control methods
  void play() => _animationController?.forward();
  void pause() => _animationController?.stop();
  void reset() => _animationController?.reset();
  void playReverse() => _animationController?.reverse();
}

/// Static methods for common use cases
class LottieHelper {
  /// Preload multiple Lottie animations
  static Future<void> preloadAssets(List<String> assetPaths) async {
    await Future.wait(
      assetPaths.map((path) => AssetLottie(path).load()),
    );
  }

  /// Create a simple Lottie widget with default settings
  static Widget simple({
    required String assetPath,
    double? size,
    double? width,
    double? height,
    bool repeat = true,
  }) {
    return OptimizedLottieWidget(
      assetPath: assetPath,
      width: width ?? size,
      height: height ?? size,
      repeat: repeat,
      showStatusText: false,
    );
  }

  /// Create a loading Lottie animation
  static Widget loading({
    required String assetPath,
    double size = 50,
  }) {
    return OptimizedLottieWidget(
      assetPath: assetPath,
      width: size,
      height: size,
      repeat: true,
      showStatusText: false,
    );
  }

  /// Create a one-time Lottie animation (like success/error indicators)
  static Widget oneShot({
    required String assetPath,
    double? size,
    double? width,
    double? height,
  }) {
    return OptimizedLottieWidget(
      assetPath: assetPath,
      width: width ?? size,
      height: height ?? size,
      repeat: false,
      showStatusText: false,
    );
  }
}