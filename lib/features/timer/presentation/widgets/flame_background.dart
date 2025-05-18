import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';

class FlameBackground extends StatefulWidget {
  final double progress;
  final Color color;

  const FlameBackground({
    super.key,
    required this.progress,
    required this.color,
  });

  @override
  State<FlameBackground> createState() => _FlameBackgroundState();
}

class _FlameBackgroundState extends State<FlameBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<FlameParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Initialize particles
    for (var i = 0; i < 50; i++) {
      _particles.add(_createParticle());
    }
  }

  FlameParticle _createParticle() {
    return FlameParticle(
      x: _random.nextDouble() * 400 - 200,
      y: _random.nextDouble() * 400 - 200,
      size: _random.nextDouble() * 20 + 10,
      speed: _random.nextDouble() * 2 + 1,
      opacity: _random.nextDouble() * 0.5 + 0.2,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: FlameBackgroundPainter(
            particles: _particles,
            progress: widget.progress,
            color: widget.color,
            time: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class FlameParticle {
  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  FlameParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class FlameBackgroundPainter extends CustomPainter {
  final List<FlameParticle> particles;
  final double progress;
  final Color color;
  final double time;

  FlameBackgroundPainter({
    required this.particles,
    required this.progress,
    required this.color,
    required this.time,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw gradient background
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: size.width));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Update and draw particles
    for (var particle in particles) {
      particle.y -= particle.speed * (1 + progress * 2);
      if (particle.y < -200) {
        particle.y = 200;
        particle.x = math.Random().nextDouble() * 400 - 200;
      }

      final particlePaint = Paint()
        ..color = color.withOpacity(particle.opacity * (0.5 + progress * 0.5))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawCircle(
        Offset(center.dx + particle.x, center.dy + particle.y),
        particle.size * (0.8 + progress * 0.4),
        particlePaint,
      );
    }

    // Draw heat waves
    final wavePaint = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0.1),
          color.withOpacity(0.05),
          color.withOpacity(0.1),
        ],
        stops: [0.0, 0.5, 1.0],
        startAngle: time * math.pi * 2,
        endAngle: time * math.pi * 2 + math.pi * 2,
      ).createShader(Rect.fromCircle(center: center, radius: size.width));

    canvas.drawCircle(center, size.width * 0.8, wavePaint);
  }

  @override
  bool shouldRepaint(FlameBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.time != time;
  }
}
