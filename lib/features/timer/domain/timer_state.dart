import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_state.freezed.dart';

enum TimerStatus { initial, running, paused, completed }

@freezed
class TimerState with _$TimerState {
  const factory TimerState({
    @Default(TimerStatus.initial) TimerStatus status,
    @Default(25 * 60) int totalSeconds,
    @Default(0) int elapsedSeconds,
    @Default(0) int completedRounds,
    @Default(4) int totalRounds,
  }) = _TimerState;

  const TimerState._();

  double get progress => elapsedSeconds / totalSeconds;

  int get remainingSeconds => totalSeconds - elapsedSeconds;

  String get formattedTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool get isLastRound => completedRounds == totalRounds - 1;

  bool get isBreak => completedRounds % 2 == 1;
}
