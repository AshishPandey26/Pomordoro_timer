import 'package:flutter/material.dart';
import 'dart:math';

class StarryBackground extends StatefulWidget {
  const StarryBackground({super.key});

  @override
  _StarryBackgroundState createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  final List<Star> _stars = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Twinkle animation duration
    )..repeat(reverse: true);

    // Generate some random stars
    _generateStars();
  }

  void _generateStars() {
    for (int i = 0; i < 100; i++) {
      _stars.add(
        Star(
          Offset(
            _random.nextDouble(), // x position (0 to 1)
            _random.nextDouble(), // y position (0 to 1)
          ),
          _random.nextDouble() * 2 + 1, // size (1 to 3)
          _random.nextDouble(), // initial opacity (0 to 1)
        ),
      );
    }
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
          painter: _StarryPainter(_stars, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Star {
  final Offset position;
  final double size;
  final double initialOpacity;

  Star(this.position, this.size, this.initialOpacity);
}

class _StarryPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  _StarryPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (final star in stars) {
      // Calculate current opacity with twinkling effect
      final opacity = star.initialOpacity * (0.5 + 0.5 * animationValue);
      paint.color = Colors.white.withOpacity(opacity);

      // Convert relative position to absolute position
      final x = star.position.dx * size.width;
      final y = star.position.dy * size.height;

      canvas.drawCircle(Offset(x, y), star.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(_StarryPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
