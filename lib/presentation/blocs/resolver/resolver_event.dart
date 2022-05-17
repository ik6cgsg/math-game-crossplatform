import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/data/models/platform_models.dart';

abstract class ResolverEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Resolve extends ResolverEvent {
  final ResolutionInput input;

  Resolve(this.input);

  @override
  List<Object> get props => [input];
}