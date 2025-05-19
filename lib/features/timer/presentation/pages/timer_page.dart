import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/timer_controller.dart';
import '../widgets/flame_progress_ring.dart';
import '../widgets/timer_controls.dart';
import '../widgets/flame_background.dart';
import '../widgets/water_fill_animation.dart';
import '../widgets/starry_background.dart';
import '../../domain/timer_state.dart';
import '../../themes/timer_theme.dart';
import '../../domain/timer_settings.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../gamification/presentation/widgets/progress_display.dart';

class TimerPage extends ConsumerStatefulWidget {
  const TimerPage({super.key});

  @override
  ConsumerState<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _startAnimationController;
  late final Animation<double> _startAnimation;
  late TextEditingController _taskNameController;
  static const String _taskNameKey = 'taskName';

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController();
    _loadTaskName();

    _startAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _startAnimation = CurvedAnimation(
      parent: _startAnimationController,
      curve: Curves.easeOutBack,
    );
  }

  Future<void> _loadTaskName() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTaskName = prefs.getString(_taskNameKey);
    if (savedTaskName != null) {
      _taskNameController.text = savedTaskName;
    }
    _taskNameController.addListener(_saveTaskName);
  }

  Future<void> _saveTaskName() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_taskNameKey, _taskNameController.text);
  }

  @override
  void dispose() {
    _startAnimationController.dispose();
    _taskNameController.removeListener(_saveTaskName);
    _taskNameController.dispose();
    super.dispose();
  }

  void _handleTimerStart() {
    _startAnimationController.forward(from: 0);
    ref.read(timerControllerProvider.notifier).startTimer();
  }

  void _showAdjustBreaksDialog(BuildContext context) {
    final settings = ref.read(timerSettingsProvider);
    int shortBreak = settings.shortBreakMinutes;
    int longBreak = settings.longBreakMinutes;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adjust Break Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Short Break (minutes)'),
              trailing: Text('$shortBreak'),
            ),
            Slider(
              value: shortBreak.toDouble(),
              min: 1,
              max: 15,
              divisions: 14,
              label: shortBreak.toString(),
              onChanged: (value) {
                shortBreak = value.round();
                (context as Element).markNeedsBuild();
              },
            ),
            ListTile(
              title: const Text('Long Break (minutes)'),
              trailing: Text('$longBreak'),
            ),
            Slider(
              value: longBreak.toDouble(),
              min: 5,
              max: 30,
              divisions: 25,
              label: longBreak.toString(),
              onChanged: (value) {
                longBreak = value.round();
                (context as Element).markNeedsBuild();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(timerSettingsProvider.notifier).updateSettings(
                    shortBreakMinutes: shortBreak,
                    longBreakMinutes: longBreak,
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSetRoundsDialog(BuildContext context) {
    final settings = ref.read(timerSettingsProvider);
    int rounds = settings.focusRounds;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Focus Rounds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Number of Rounds'),
              trailing: Text('$rounds'),
            ),
            Slider(
              value: rounds.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: rounds.toString(),
              onChanged: (value) {
                rounds = value.round();
                (context as Element).markNeedsBuild();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(timerSettingsProvider.notifier).updateSettings(
                    focusRounds: rounds,
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerControllerProvider);
    final theme = Theme.of(context);
    final controller = ref.read(timerControllerProvider.notifier);
    final appThemeType = ref.watch(themeProvider);

    // Show session summary when completed
    if (timerState.status == TimerStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Session Complete! 🎯'),
            content: Text(
              'Great job! You focused for ${timerState.completedRounds * 25} minutes',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  controller.resetTimer();
                },
                child: const Text('Start New Session'),
              ),
            ],
          ),
        );
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          // Starry background for night theme
          if (appThemeType == AppThemeType.night) const StarryBackground(),
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
                  theme.colorScheme.background.withOpacity(0.95),
                  theme.colorScheme.surface.withOpacity(0.98),
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 16,
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: appThemeType == AppThemeType.zenForest
                            ? theme.colorScheme
                                .onBackground // Dark color for light theme
                            : Colors.white70, // White color for dark themes
                      ),
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'adjust_breaks') {
                          _showAdjustBreaksDialog(context);
                        } else if (value == 'set_rounds') {
                          _showSetRoundsDialog(context);
                        } else if (value == 'fiery') {
                          ref
                              .read(themeProvider.notifier)
                              .setTheme(AppThemeType.fiery);
                        } else if (value == 'cyberpunk') {
                          ref
                              .read(themeProvider.notifier)
                              .setTheme(AppThemeType.cyberpunk);
                        } else if (value == 'zenForest') {
                          ref
                              .read(themeProvider.notifier)
                              .setTheme(AppThemeType.zenForest);
                        } else if (value == 'night') {
                          ref
                              .read(themeProvider.notifier)
                              .setTheme(AppThemeType.night);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'themes',
                          enabled: false,
                          child: Text(
                            'Themes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'fiery',
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF4B2B),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Fiery Theme',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'cyberpunk',
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00FF9F),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Cyberpunk Theme',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'zenForest',
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF228B22),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Zen Forest Theme',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'night',
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(
                                      0xFF7E57C2), // Deep purple color indicator
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Night Theme',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'adjust_breaks',
                          child: Text(
                            'Adjust Breaks',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'set_rounds',
                          child: Text(
                            'Set Focus Rounds',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Mode indicator with animation
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          key: ValueKey(timerState.isBreak),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.1),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            timerState.isBreak ? 'Break Time' : 'Focus Time',
                            style: AppTheme.getHeaderText(
                                ref.watch(themeProvider)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Add TextField for task name
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0), // Adjust padding as needed
                        child: TextField(
                          controller: _taskNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter task name (optional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  12), // Match the rounded corners
                              borderSide: BorderSide.none, // No border line
                            ),
                            filled: true,
                            fillColor:
                                theme.colorScheme.surface, // White background
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: theme.colorScheme.onSurface), // Text color
                        ),
                      ),
                      const SizedBox(height: 12), // Adjust spacing
                      // Round indicator with animation
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          key: ValueKey(timerState.completedRounds),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.05),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            'Round ${timerState.completedRounds + 1}/${timerState.totalRounds}',
                            style:
                                AppTheme.getRoundText(ref.watch(themeProvider)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Timer display
                      Center(
                        child: SizedBox(
                          width: 240,
                          height: 240,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Show water fill only when running or stopping
                              if (timerState.status == TimerStatus.running ||
                                  timerState.status == TimerStatus.paused)
                                ClipOval(
                                  child: WaterFillAnimation(
                                    progress: timerState.progress,
                                    size: 240,
                                    color: timerState.isBreak
                                        ? TimerTheme.breakWater
                                        : TimerTheme.focusWater,
                                  ),
                                ),
                              ScaleTransition(
                                scale: _startAnimation,
                                child: FlameProgressRing(
                                  progress: timerState.progress,
                                  size: 240,
                                  onTap: () {
                                    if (timerState.status ==
                                        TimerStatus.running) {
                                      controller.pauseTimer();
                                    } else if (timerState.status ==
                                        TimerStatus.paused) {
                                      _handleTimerStart();
                                    }
                                  },
                                  color: timerState.isBreak
                                      ? TimerTheme.breakRing
                                      : TimerTheme.focusRing,
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
                                  style: AppTheme.getTimerText(
                                      ref.watch(themeProvider)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Progress Display
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: const ProgressDisplay(),
                      ),
                      const SizedBox(height: 24),
                      // Control buttons
                      TimerControls(
                        status: timerState.status,
                        onStart: _handleTimerStart,
                        onPause: controller.pauseTimer,
                        onReset: controller.resetTimer,
                      ),
                    ],
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
