import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/timer_state.dart';

class TimerControls extends StatelessWidget {
  final TimerStatus status;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;

  const TimerControls({
    super.key,
    required this.status,
    required this.onStart,
    required this.onPause,
    required this.onReset,
  });

  void _handleTap(VoidCallback callback) {
    HapticFeedback.mediumImpact();
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _AnimatedControlButton(
          icon: Icons.refresh,
          onTap: () => _handleTap(onReset),
          isActive: status != TimerStatus.initial,
          tooltip: 'Reset Timer',
        ),
        const SizedBox(width: 32),
        _AnimatedControlButton(
          icon: status == TimerStatus.running ? Icons.pause : Icons.play_arrow,
          onTap: () => _handleTap(
            status == TimerStatus.running ? onPause : onStart,
          ),
          isActive: status != TimerStatus.completed,
          isPrimary: true,
          tooltip: status == TimerStatus.running ? 'Pause' : 'Start',
        ),
      ],
    );
  }
}

class _AnimatedControlButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;
  final bool isPrimary;
  final String tooltip;

  const _AnimatedControlButton({
    required this.icon,
    required this.onTap,
    required this.isActive,
    required this.tooltip,
    this.isPrimary = false,
  });

  @override
  State<_AnimatedControlButton> createState() => _AnimatedControlButtonState();
}

class _AnimatedControlButtonState extends State<_AnimatedControlButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _glowAnimation;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.isPrimary
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;

    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.isActive ? widget.onTap : null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isActive
                        ? color.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: color.withOpacity(0.1 * _glowAnimation.value),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.isActive ? color : Colors.grey,
                    size: 32,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
