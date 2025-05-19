import 'dart:math';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'user_progress.freezed.dart';
part 'user_progress.g.dart';

@freezed
class UserProgress with _$UserProgress {
  const factory UserProgress({
    @Default(0) int points,
    @Default(1) int level,
    @Default(0) int totalFocusMinutes,
    @Default(0) int completedSessions,
    @Default([]) List<String> unlockedAchievements,
  }) = _UserProgress;

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
}

class UserProgressNotifier extends StateNotifier<UserProgress> {
  UserProgressNotifier() : super(const UserProgress()) {
    _loadProgress();
  }

  static const String _storageKey = 'user_progress';

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_storageKey);
    if (json != null) {
      state = UserProgress.fromJson(
          Map<String, dynamic>.from(Map<String, dynamic>.from(json as Map)));
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, state.toJson().toString());
  }

  void addPoints(int points) {
    final newPoints = state.points + points;
    final newLevel = _calculateLevel(newPoints);
    final hasLeveledUp = newLevel > state.level;

    state = state.copyWith(
      points: newPoints,
      level: newLevel,
    );

    if (hasLeveledUp) {
      _checkAchievements();
    }

    _saveProgress();
  }

  void addFocusMinutes(int minutes) {
    state = state.copyWith(
      totalFocusMinutes: state.totalFocusMinutes + minutes,
      completedSessions: state.completedSessions + 1,
    );
    _saveProgress();
  }

  int _calculateLevel(int points) {
    // Level calculation formula: level = 1 + sqrt(points / 100)
    return 1 + sqrt(points / 100).floor();
  }

  void _checkAchievements() {
    final newAchievements = <String>[];

    // Focus Master Achievement
    if (state.totalFocusMinutes >= 1000 &&
        !state.unlockedAchievements.contains('focus_master')) {
      newAchievements.add('focus_master');
    }

    // Level Up Achievement
    if (state.level >= 5 && !state.unlockedAchievements.contains('level_5')) {
      newAchievements.add('level_5');
    }

    // Consistency Achievement
    if (state.completedSessions >= 10 &&
        !state.unlockedAchievements.contains('consistent')) {
      newAchievements.add('consistent');
    }

    if (newAchievements.isNotEmpty) {
      state = state.copyWith(
        unlockedAchievements: [
          ...state.unlockedAchievements,
          ...newAchievements
        ],
      );
      _saveProgress();
    }
  }

  String getNextLevelPoints() {
    final currentLevelPoints = (state.level - 1) * (state.level - 1) * 100;
    final nextLevelPoints = state.level * state.level * 100;
    return '${nextLevelPoints - state.points}';
  }

  double getLevelProgress() {
    final currentLevelPoints = (state.level - 1) * (state.level - 1) * 100;
    final nextLevelPoints = state.level * state.level * 100;
    final pointsInCurrentLevel = state.points - currentLevelPoints;
    final pointsNeededForNextLevel = nextLevelPoints - currentLevelPoints;
    return pointsInCurrentLevel / pointsNeededForNextLevel;
  }
}
