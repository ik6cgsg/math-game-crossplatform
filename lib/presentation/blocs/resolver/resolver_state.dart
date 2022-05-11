import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';

abstract class ResolverState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Resolving extends ResolverState {}

class Resolved extends ResolverState {
  final String matrix;

  Resolved(this.matrix);

  @override
  List<Object?> get props => [matrix];
}

class Error extends ResolverState {
  final String message;

  Error(this.message);

  @override
  List<Object?> get props => [message];
}