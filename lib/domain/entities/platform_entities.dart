import 'package:equatable/equatable.dart';

class Point extends Equatable {
  final int x, y;

  const Point(this.x, this.y);

  bool isInside(SelectionBox b) => x >= b.lt.x && x <= b.rb.x && y >= b.lt.y && y <= b.rb.y;

  @override
  String toString() => '($x, $y)';

  @override
  List<Object> get props => [x, y];
}

class SelectionBox extends Equatable {
  final Point lt, rb;

  const SelectionBox(this.lt, this.rb);

  @override
  List<Object> get props => [lt, rb];
}

class NodeSelectionInfo extends Equatable {
  final String expression;
  final int nodeId;
  final SelectionBox selection;

  const NodeSelectionInfo(this.expression, this.nodeId, this.selection);

  @override
  List<Object> get props => [expression, nodeId, selection];
}

class SubstitutionInfo extends Equatable {
  final List<String> rules;
  final List<String> results;

  const SubstitutionInfo(this.rules, this.results);

  @override
  List<Object> get props => [rules, results];
}