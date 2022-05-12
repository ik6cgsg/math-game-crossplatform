import 'package:equatable/equatable.dart';

abstract class ResolverEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Resolve extends ResolverEvent {
  final String expression;
  final bool isStructured, isInteractive;

  Resolve(this.expression, this.isStructured, this.isInteractive);

  @override
  List<Object> get props => [expression, isStructured, isInteractive];
}