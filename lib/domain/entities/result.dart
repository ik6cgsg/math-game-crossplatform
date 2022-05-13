import 'package:equatable/equatable.dart';

enum LevelState {
  notStarted,
  paused,
  passed,
  locked
}

class Result extends Equatable {
  final String taskCode;
  final String expression;
  final int stepCount;
  final LevelState state;

  const Result(this.taskCode, this.expression, this.stepCount, this.state);

  @override
  List<Object> get props => [taskCode, expression, stepCount, state];
}