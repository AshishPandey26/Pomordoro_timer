import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/timer_state.dart';

final timerControllerProvider =
    StateNotifierProvider<TimerController, TimerState>((ref) {
      return TimerController();
    });

class TimerController extends StateNotifier<TimerState> {
  TimerController() : super(const TimerState());

  Timer? _timer;

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

    if (state.isLastRound) {
      state = state.copyWith(
        status: TimerStatus.completed,
        completedRounds: state.completedRounds + 1,
      );
      return;
    }

    state = state.copyWith(
      status: TimerStatus.initial,
      elapsedSeconds: 0,
      completedRounds: state.completedRounds + 1,
      totalSeconds:
          state.isBreak ? 25 * 60 : 5 * 60, // 25 min work, 5 min break
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
