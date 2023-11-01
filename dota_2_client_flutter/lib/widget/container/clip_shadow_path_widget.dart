import 'package:flutter/material.dart';

@immutable
class ClipShadowPathWidget extends StatelessWidget {
  final CustomClipper<Path> clipper;
  final Path? borderPath;
  final Border? border; // only support border.all
  final Shadow? shadow;
  final Widget child;

  const ClipShadowPathWidget({
    Key? key,
    required this.clipper,
    this.borderPath,
    this.border,
    this.shadow,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(clipper: clipper, borderPath: borderPath, border: border, shadow: shadow),
      child: ClipPath(clipper: clipper, child: child),
    );
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  final Path? borderPath;
  final Border? border;
  final Shadow? shadow;

  _ClipShadowShadowPainter({required this.clipper, this.borderPath, this.border, this.shadow});

  @override
  void paint(Canvas canvas, Size size) {
    if (border != null) {
      final paint = Paint()
        ..color = border!.top.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = border!.top.width;

      final borderPath = this.borderPath ?? clipper.getClip(size);
      canvas.drawPath(borderPath, paint);
    }
    if (shadow != null) {
      final shadowPaint = shadow!.toPaint();
      final clipPath = clipper.getClip(size).shift(shadow!.offset);
      canvas.drawPath(clipPath, shadowPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
