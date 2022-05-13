import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';
import 'package:math_game_crossplatform/domain/entities/step_state.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';

abstract class PlayState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends PlayState {}

class Step extends PlayState {
  final StepState state;

  Step(this.state);

  @override
  List<Object?> get props => [state];
}

class Passed extends PlayState {
  final bool hasPrev;
  final bool hasNext;
  // lastResult?

  Passed(this.hasPrev, this.hasNext);

  @override
  List<Object?> get props => [hasPrev, hasNext];
}

class Error extends PlayState {
  final String message;

  Error(this.message);

  @override
  List<Object?> get props => [message];
}