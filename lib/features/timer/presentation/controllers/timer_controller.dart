import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/timer_state.dart';
import '../../services/notification_service.dart';
import '../../../gamification/providers/user_progress_provider.dart';

final timerControllerProvider =
    StateNotifierProvider<TimerController, TimerState>((ref) {
  return TimerController(ref);
});

class TimerController extends StateNotifier<TimerState> {
  TimerController(this.ref) : super(const TimerState());

  final Ref ref;
  Timer? _timer;
  final NotificationService _notificationService = NotificationService();
  bool _isPhaseChange = false;

  void startTimer() {
    if (state.status == TimerStatus.running) return;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTick);

    state = state.copyWith(status: TimerStatus.running);
  }

  void pauseTimer() {
    if (state.status != TimerStatus.running) return;

    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void resetTimer() {
    _timer?.cancel();
    state = const TimerState();
  }

  void _onTick(Timer timer) {
    if (state.elapsedSeconds >= state.totalSeconds) {
      _completeRound();
      return;
    }

    state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
  }

  void _completeRound() {
    _timer?.cancel();
    _isPhaseChange = true;

    if (state.isLastRound) {
      state = state.copyWith(
        status: TimerStatus.completed,
        completedRounds: state.completedRounds + 1,
      );
      _notificationService.playSessionCompleteSound();

      // Award points for completing a session
      final focusMinutes =
          state.completedRounds * 25; // 25 minutes per focus session
      ref.read(userProgressProvider.notifier).addFocusMinutes(focusMinutes);
      ref
          .read(userProgressProvider.notifier)
          .addPoints(focusMinutes * 2); // 2 points per minute
      return;
    }

    state = state.copyWith(
      status: TimerStatus.initial,
      elapsedSeconds: 0,
      completedRounds: state.completedRounds + 1,
      totalSeconds:
          state.isBreak ? 25 * 60 : 5 * 60, // 25 min work, 5 min break
    );
    _notificationService.playPhaseChangeSound();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _notificationService.dispose();
    super.dispose();
  }
}
