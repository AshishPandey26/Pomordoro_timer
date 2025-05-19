import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_progress.dart';

final userProgressProvider =
    StateNotifierProvider<UserProgressNotifier, UserProgress>((ref) {
  return UserProgressNotifier();
});
