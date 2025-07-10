import 'package:flutter/material.dart';
import 'package:flutter_exchange/config/app_colors.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary;
    final radius = size.width * 1.5;
    final dx = size.width + radius * 0.7;
    final dy = radius * 0.5;

    final offset = Offset(dx, dy);
    canvas.drawCircle(offset, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
