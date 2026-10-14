import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Renders the multi-layer CSS gradient:
/// - linear-gradient(#dedbec 0 8px, #dedbec00 120px)
/// - radial-gradient(60% 55% at 0 12%, #f5b8e0, #0000 70%)
/// - radial-gradient(55% 50% at 100% 12%, #9fdef5, #0000 70%)
/// - radial-gradient(60% 55% at 100% 100%, #fde0b2, #0000 70%)
///
/// Uses purely AppColors tokens (no hardcoded color literals).
class HomeHeroGradientPainter extends CustomPainter {
  final double topOffset;
  final double totalHeight;
  final bool isBottom;

  const HomeHeroGradientPainter({
    this.topOffset = 0.0,
    required this.totalHeight,
    this.isBottom = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate(0, -topOffset);

    final w = size.width;
    final h = totalHeight;
    final fullRect = Offset.zero & Size(w, h);

    // 1. Base solid background (#dedbec)
    canvas.drawRect(fullRect, Paint()..color = AppColors.heroGradientBase);

    // 2. Elliptical radial: radial-gradient(60% 55% at 0 12%, #f5b8e0, #0000 70%)
    //    Center at left edge (x=0), 12% down.
    _drawEllipticalGradient(
      canvas,
      center: Offset(0, h * 0.12),
      radiusX: w * 0.60,
      radiusY: h * 0.55,
      color: AppColors.heroGradientPink,
      stopEnd: 0.70,
      canvasWidth: w,
      canvasHeight: h,
    );

    // 3. Elliptical radial: radial-gradient(55% 50% at 100% 12%, #9fdef5, #0000 70%)
    //    Center at right edge (x=100%), 12% down.
    _drawEllipticalGradient(
      canvas,
      center: Offset(w, h * 0.12),
      radiusX: w * 0.55,
      radiusY: h * 0.50,
      color: AppColors.heroGradientBlue,
      stopEnd: 0.70,
      canvasWidth: w,
      canvasHeight: h,
    );

    // 4. Elliptical radial: radial-gradient(60% 55% at 100% 100%, #fde0b2, #0000 70%)
    //    Center at bottom-right corner.
    if (isBottom) {
      _drawEllipticalGradient(
        canvas,
        center: Offset(w, h),
        radiusX: w * 0.60,
        radiusY: h * 0.55,
        color: AppColors.heroGradientPeach,
        stopEnd: 0.70,
        canvasWidth: w,
        canvasHeight: h,
      );
    }

    // 5. Linear gradient overlay: linear-gradient(#dedbec 0 8px, #dedbec00 120px)
    final linearPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        const Offset(0, 120),
        [
          AppColors.heroGradientBase,
          AppColors.heroGradientBase,
          AppColors.heroGradientBase.withValues(alpha: 0),
        ],
        const [0.0, 8.0 / 120.0, 1.0],
      );
    canvas.drawRect(fullRect, linearPaint);

    canvas.restore();
  }

  /// Draws an elliptical radial gradient by scaling the canvas.
  ///
  /// CSS radial-gradient uses elliptical shapes (e.g. 60% 55%).
  /// Flutter's ui.Gradient.radial only draws circles, so we scale
  /// the canvas Y-axis to squash/stretch a circle into an ellipse.
  ///
  /// KEY: Fades to a transparent version of [color] (not transparent black)
  /// to avoid dark shadow artifacts during alpha interpolation.
  void _drawEllipticalGradient(
    Canvas canvas, {
    required Offset center,
    required double radiusX,
    required double radiusY,
    required Color color,
    required double stopEnd,
    required double canvasWidth,
    required double canvasHeight,
  }) {
    if (radiusX <= 0 || radiusY <= 0) return;

    canvas.save();

    // Move origin to the center of the ellipse
    canvas.translate(center.dx, center.dy);

    // Scale Y so that a circle of radius radiusX becomes
    // an ellipse of radiusX × radiusY
    final scaleY = radiusY / radiusX;
    canvas.scale(1.0, scaleY);

    // Fade to transparent version of the SAME color (not transparent black).
    // This prevents dark shadow artifacts from interpolation through black.
    final transparentColor = color.withValues(alpha: 0);

    final paint = Paint()
      ..shader = ui.Gradient.radial(
        Offset.zero,
        radiusX,
        [color, transparentColor],
        [0.0, stopEnd],
      );

    // Draw a rect large enough to cover the visible area in scaled space.
    final inverseScaleY = radiusX / radiusY;
    canvas.drawRect(
      Rect.fromLTWH(
        -center.dx,
        -center.dy * inverseScaleY,
        canvasWidth,
        canvasHeight * inverseScaleY,
      ),
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HomeHeroGradientPainter oldDelegate) {
    return oldDelegate.topOffset != topOffset ||
        oldDelegate.totalHeight != totalHeight;
  }
}
