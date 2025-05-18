import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';

class WaterFillAnimation extends StatefulWidget {
  final double progress; // 0.0 (empty) to 1.0 (full)
  final double size;
  final Color color;
  final bool visible; // For fade/scale transition

  const WaterFillAnimation({
    super.key,
    required this.progress,
    required this.size,
    required this.color,
    this.visible = true,
  });

  @override
  State<WaterFillAnimation> createState() => _WaterFillAnimationState();
}

class _WaterFillAnimationState extends State<WaterFillAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Bubble> _bubbles = [];
  final Random _random = Random();
  int _bubbleTick = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..addListener(_maybeAddBubble)
      ..repeat();
    // Initialize bubbles
    for (int i = 0; i < 12; i++) {
      _bubbles.add(_randomBubble());
    }
  }

  void _maybeAddBubble() {
    // Add a new bubble every ~1.5 seconds
    _bubbleTick++;
    if (_bubbleTick % 90 == 0) {
      _bubbles.add(_randomBubble());
      if (_bubbles.length > 18) _bubbles.removeAt(0);
    }
  }

  _Bubble _randomBubble() {
    return _Bubble(
      x: _random.nextDouble(),
      y: 1.0 + _random.nextDouble() * 0.2, // start just below the bottom
      radius: 3.0 + _random.nextDouble() * 5.0,
      speed: 0.10 + _random.nextDouble() * 0.07,
      opacity: 0.25 + _random.nextDouble() * 0.35,
      phase: _random.nextDouble() * 2 * math.pi,
    );
  }

  void _updateBubbles() {
    for (final bubble in _bubbles) {
      bubble.y -= bubble.speed * 0.012;
      if (bubble.y < 0.0) {
        // Reset bubble to bottom
        bubble.x = _random.nextDouble();
        bubble.y = 1.0 + _random.nextDouble() * 0.2;
        bubble.radius = 3.0 + _random.nextDouble() * 5.0;
        bubble.speed = 0.10 + _random.nextDouble() * 0.07;
        bubble.opacity = 0.25 + _random.nextDouble() * 0.35;
        bubble.phase = _random.nextDouble() * 2 * math.pi;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _updateBubbles();
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: widget.progress),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      builder: (context, animatedProgress, child) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return AnimatedOpacity(
              opacity: widget.visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: AnimatedScale(
                scale: widget.visible ? 1.0 : 0.92,
                duration: const Duration(milliseconds: 400),
                child: ClipOval(
                  child: CustomPaint(
                    painter: _WaterFillPainter(
                      progress: animatedProgress,
                      time: _controller.value,
                      bubbles: _bubbles,
                      color: widget.color,
                    ),
                    size: Size(widget.size, widget.size),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Bubble {
  double x; // 0.0 to 1.0 (relative to width)
  double y; // 0.0 (top) to 1.0 (bottom)
  double radius;
  double speed;
  double opacity;
  double phase;
  _Bubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.opacity,
    required this.phase,
  });
}

class _WaterFillPainter extends CustomPainter {
  final double progress;
  final double time;
  final List<_Bubble> bubbles;
  final Color color;

  _WaterFillPainter({
    required this.progress,
    required this.time,
    required this.bubbles,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double fillHeight = size.height * (1 - progress);
    // Gentle wave
    final double waveHeight1 = 8;
    final double waveLength1 = size.width / 1.1;
    final double waveSpeed1 = time * 2 * math.pi * 0.7;
    final double waveHeight2 = 4;
    final double waveLength2 = size.width / 0.7;
    final double waveSpeed2 = time * 2 * math.pi * 0.4;

    // Double wave path
    final Path wavePath = Path();
    wavePath.moveTo(0, fillHeight);
    for (double x = 0; x <= size.width; x += 1) {
      final double y1 = fillHeight +
          math.sin((x / waveLength1 * 2 * math.pi) + waveSpeed1) * waveHeight1;
      final double y2 = fillHeight +
          math.sin((x / waveLength2 * 2 * math.pi) + waveSpeed2 + math.pi / 2) *
              waveHeight2;
      final double y = (y1 + y2) / 2;
      wavePath.lineTo(x, y);
    }
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    // Water gradient fill (darker at bottom, lighter at top)
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.92),
          color.withOpacity(0.82),
          color.withOpacity(0.98).withBlue((color.blue * 0.7).toInt()),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
          Rect.fromLTWH(0, fillHeight, size.width, size.height - fillHeight));
    canvas.drawPath(wavePath, fillPaint);

    // Shimmer highlight
    final double shimmerWidth = size.width * 0.7;
    final double shimmerX =
        (size.width - shimmerWidth) / 2 + math.sin(time * 2 * math.pi) * 20;
    final Rect shimmerRect =
        Rect.fromLTWH(shimmerX, fillHeight - 10, shimmerWidth, 18);
    final Paint shimmerPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.10),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(shimmerRect);
    canvas.drawRect(shimmerRect, shimmerPaint);

    // Edge shadow/glow
    final Paint edgePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withOpacity(0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, fillHeight - 8, size.width, 16));
    canvas.drawRect(
        Rect.fromLTWH(0, fillHeight - 8, size.width, 16), edgePaint);

    // Draw bubbles
    for (final bubble in bubbles) {
      final double bx = bubble.x * size.width;
      final double by = fillHeight + (size.height - fillHeight) * bubble.y;
      final Paint bubblePaint = Paint()
        ..color = Colors.white.withOpacity(bubble.opacity * (1 - bubble.y))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(Offset(bx, by), bubble.radius, bubblePaint);
    }
  }

  @override
  bool shouldRepaint(_WaterFillPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.time != time ||
        oldDelegate.color != color;
  }
}
