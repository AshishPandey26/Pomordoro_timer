import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../controllers/timer_controller.dart';
import '../widgets/flame_progress_ring.dart';
import '../widgets/timer_controls.dart';
import '../widgets/flame_background.dart';
import '../widgets/water_fill_animation.dart';
import '../../domain/timer_state.dart';
// import '../../themes/timer_theme.dart';

class TimerPage extends ConsumerStatefulWidget {
  const TimerPage({super.key});

  @override
  ConsumerState<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _startAnimationController;
  late final Animation<double> _startAnimation;

  @override
  void initState() {
    super.initState();
    _startAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _startAnimation = CurvedAnimation(
      parent: _startAnimationController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _startAnimationController.dispose();
    super.dispose();
  }

  void _handleTimerStart() {
    _startAnimationController.forward(from: 0);
    ref.read(timerControllerProvider.notifier).startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerControllerProvider);
    final controller = ref.read(timerControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Animated flame background
          FlameBackground(
            progress: timerState.progress,
            color: theme.colorScheme.primary,
          ),
          // Main content
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.background.withOpacity(0.8),
                  theme.colorScheme.surface.withOpacity(0.9),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Mode indicator with animation
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(timerState.isBreak),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        timerState.isBreak ? 'Break Time' : 'Focus Time',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Round indicator with animation
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(timerState.completedRounds),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        'Round ${timerState.completedRounds + 1}/${timerState.totalRounds}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Timer display
                  Center(
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Show water fill only when running or stopping
                          // if (timerState.status == TimerStatus.running ||
                          //     timerState.status == TimerStatus.paused)
                          //   ClipOval(
                          //     child: WaterFillAnimation(
                          //       progress: timerState.progress,
                          //       size: 300,
                          //       color: timerState.isBreak
                          //           ? TimerTheme.breakWater
                          //           : TimerTheme.focusWater,
                          //     ),
                          //   ),
                          ScaleTransition(
                            scale: _startAnimation,
                            child: FlameProgressRing(
                              progress: timerState.progress,
                              size: 300,
                              onTap: () {
                                if (timerState.status == TimerStatus.running) {
                                  controller.pauseTimer();
                                } else if (timerState.status ==
                                    TimerStatus.paused) {
                                  _handleTimerStart();
                                }
                              },
                              // color: timerState.isBreak
                              //     ? TimerTheme.breakRing
                              //     : TimerTheme.focusRing,
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              timerState.formattedTime,
                              key: ValueKey(timerState.formattedTime),
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                // shadows: [
                                //   Shadow(
                                //     color: timerState.isBreak
                                //         ? TimerTheme.breakTextGlow
                                //         : TimerTheme.focusTextGlow,
                                //     blurRadius: 20,
                                //   ),
                                // ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Control buttons
                  TimerControls(
                    status: timerState.status,
                    onStart: _handleTimerStart,
                    onPause: controller.pauseTimer,
                    onReset: controller.resetTimer,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
