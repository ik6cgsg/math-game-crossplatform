import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/data/models/rule_model.dart';

import '../../domain/entities/platform_entities.dart';

class PointModel extends Point {
  const PointModel(int x, int y): super(x, y);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'coords': [x, y]
  };

  factory PointModel.fromList(List<int> l) => PointModel(l[0], l[1]);
  factory PointModel.fromEntity(Point p) => PointModel(p.x, p.y);
}

class NodeSelectionInfoModel extends NodeSelectionInfo {
  NodeSelectionInfoModel(String expression, int nodeId, PointModel lt, PointModel rb)
      : super(expression, nodeId, SelectionBox(lt, rb));

  factory NodeSelectionInfoModel.fromJson(Map<String, dynamic> json) => NodeSelectionInfoModel(
    json['node'] as String? ?? '',
    json['id'] as int? ?? 0,
    PointModel.fromList(List<int>.from(json['lt'])),
    PointModel.fromList(List<int>.from(json['rb'])),
  );
}

class SubstitutionInfoModel extends SubstitutionInfo {
  const SubstitutionInfoModel(List<String> rules, List<String> results): super(rules, results);

  factory SubstitutionInfoModel.fromJson(Map<String, dynamic> json) => SubstitutionInfoModel(
      List<String>.from(json['rules']),
      List<String>.from(json['results'])
  );
}

/// Input data */

class CheckEndInput extends Equatable {
  final String expression, goalExpression, goalPattern;

  const CheckEndInput(this.expression, this.goalExpression, this.goalPattern);

  @override
  List<Object> get props => [expression, goalExpression, goalPattern];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'expression': expression,
    'goal': goalExpression,
    'pattern': goalPattern
  };
}

class ResolutionInput extends Equatable {
  final String expressionStr, subjectType;
  final bool isStructured, isInteractive;

  const ResolutionInput(this.expressionStr, this.subjectType, this.isStructured, this.isInteractive);

  @override
  List<Object> get props => [expressionStr, subjectType, isStructured, isInteractive];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'expression': expressionStr,
    'subject': subjectType,
    'structured': isStructured,
    'interactive': isInteractive
  };
}

class CompileInput extends Equatable {
  final Set<RuleModel> rules;
  final Map<String, String> additionalParams;

  const CompileInput(this.rules, this.additionalParams);

  @override
  List<Object> get props => [rules, additionalParams];

  Map<String, dynamic> toJson() => <String, dynamic>{
    'rules': rules.map((e) => e.toJson()).toList(),
    'additional': additionalParams
  };
}