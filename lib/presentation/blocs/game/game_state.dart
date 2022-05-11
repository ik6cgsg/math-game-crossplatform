import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';

abstract class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends GameState {}

class Loaded extends GameState {
  final Taskset taskset;

  Loaded(this.taskset);

  @override
  List<Object?> get props => [taskset];
}

class Error extends GameState {
  final String message;

  Error(this.message);

  @override
  List<Object?> get props => [message];
}