import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class FlameProgressRing extends StatelessWidget {
  final double progress;
  final double size;
  final VoidCallback? onTap;

  const FlameProgressRing({
    super.key,
    required this.progress,
    required this.size,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: FlameProgressPainter(
            progress: progress,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class FlameProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  FlameProgressPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = size.width * 0.08;

    // Draw background ring
    final backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Draw progress ring with gradient
    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0.8),
          color,
          color.withOpacity(0.8),
        ],
        stops: const [0.0, 0.5, 1.0],
        startAngle: 0,
        endAngle: 2 * 3.14159,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw glow effect
    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10);

    final path = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -1.5708, // Start from top (-90 degrees)
        2 * 3.14159 * progress,
      );

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, progressPaint);

    // Draw flame particles
    if (progress > 0) {
      final particlePaint = Paint()
        ..color = color.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      final particleCount = (progress * 20).round();
      for (var i = 0; i < particleCount; i++) {
        final angle = (i / particleCount) * 2 * 3.14159 * progress;
        final particleRadius = radius - strokeWidth / 2;
        final x = center.dx + math.cos(angle) * particleRadius;
        final y = center.dy + math.sin(angle) * particleRadius;

        canvas.drawCircle(
          Offset(x, y),
          strokeWidth * 0.3,
          particlePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(FlameProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
