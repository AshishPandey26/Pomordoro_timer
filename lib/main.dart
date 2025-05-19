import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/timer/presentation/pages/timer_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final appThemeType = ref.watch(themeProvider);
    final themeData = AppTheme.getTheme(appThemeType);

    return AnimatedTheme(
      data: themeData,
      duration: const Duration(milliseconds: 400), // Animation duration
      child: MaterialApp(
        title: 'Fiery Pomodoro',
        theme: themeData,
        home: const TimerPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
