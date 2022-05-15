import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';

abstract class PlayEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTaskEvent extends PlayEvent {
  final int index;

  LoadTaskEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class RestartEvent extends PlayEvent {}

class NodeSelectedEvent extends PlayEvent {
  final Point? tap;

  NodeSelectedEvent(this.tap);

  @override
  List<Object?> get props => [tap];
}

class RuleSelectedEvent extends PlayEvent {
  final int index;

  RuleSelectedEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleMultiselectEvent extends PlayEvent {
  final Point? tap;

  ToggleMultiselectEvent(this.tap);

  @override
  List<Object?> get props => [tap];
}

class UndoEvent extends PlayEvent {}