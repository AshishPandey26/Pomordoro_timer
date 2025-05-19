import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/timer/presentation/pages/timer_page.dart';

final getIt = GetIt.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const ProviderScope(child: PomodoroApp()));
}

void setupDependencies() {
  // TODO: Add dependency injection setup
}

class PomodoroApp extends ConsumerWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Fiery Pomodoro',
      theme: AppTheme.getTheme(themeType),
      home: const TimerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
