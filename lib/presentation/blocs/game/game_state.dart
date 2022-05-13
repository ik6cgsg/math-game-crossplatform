import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';

abstract class GameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends GameState {}

class Loaded extends GameState {
  final Taskset taskset;
  final List<Result>? results;

  Loaded(this.taskset, this.results);

  @override
  List<Object?> get props => [taskset, results];
}

class Error extends GameState {
  final String message;

  Error(this.message);

  @override
  List<Object?> get props => [message];
}