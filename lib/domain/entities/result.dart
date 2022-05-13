import 'package:equatable/equatable.dart';

enum LevelState {
  notStarted,
  paused,
  passed,
  locked
}

class Result extends Equatable {
  final int levelIndex;
  final String expression;
  final int stepCount;
  final LevelState state;

  const Result(this.levelIndex, this.expression, this.stepCount, this.state);

  @override
  List<Object> get props => [levelIndex, expression, stepCount, state];
}