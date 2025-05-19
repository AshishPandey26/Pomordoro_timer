import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerSettings {
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int focusRounds;

  TimerSettings({
    required this.shortBreakMinutes,
    required this.longBreakMinutes,
    required this.focusRounds,
  });

  TimerSettings copyWith({
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? focusRounds,
  }) {
    return TimerSettings(
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      focusRounds: focusRounds ?? this.focusRounds,
    );
  }
}

class TimerSettingsNotifier extends StateNotifier<TimerSettings> {
  TimerSettingsNotifier()
      : super(TimerSettings(
          shortBreakMinutes: 5,
          longBreakMinutes: 15,
          focusRounds: 4,
        )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = TimerSettings(
      shortBreakMinutes: prefs.getInt('shortBreakMinutes') ?? 5,
      longBreakMinutes: prefs.getInt('longBreakMinutes') ?? 15,
      focusRounds: prefs.getInt('focusRounds') ?? 4,
    );
  }

  Future<void> updateSettings({
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? focusRounds,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (shortBreakMinutes != null) {
      await prefs.setInt('shortBreakMinutes', shortBreakMinutes);
    }
    if (longBreakMinutes != null) {
      await prefs.setInt('longBreakMinutes', longBreakMinutes);
    }
    if (focusRounds != null) {
      await prefs.setInt('focusRounds', focusRounds);
    }

    state = state.copyWith(
      shortBreakMinutes: shortBreakMinutes,
      longBreakMinutes: longBreakMinutes,
      focusRounds: focusRounds,
    );
  }
}

final timerSettingsProvider =
    StateNotifierProvider<TimerSettingsNotifier, TimerSettings>((ref) {
  return TimerSettingsNotifier();
});
