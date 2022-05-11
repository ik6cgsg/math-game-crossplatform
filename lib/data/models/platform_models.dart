import '../../domain/entities/platform_entities.dart';

class PointModel extends Point {
  const PointModel(int x, int y): super(x, y);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'coords': [x, y]
  };

  factory PointModel.fromList(List<int> l) => PointModel(l[0], l[1]);
  factory PointModel.fromEntity(Point p) => PointModel(p.x, p.y);
}

class ResolutionInputModel extends ResolutionInput {
  const ResolutionInputModel(String expressionStr, bool isStructured, bool isInteractive)
      : super(expressionStr, isStructured, isInteractive);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'expression': expressionStr,
    'structured': isStructured,
    'interactive': isInteractive
  };

  factory ResolutionInputModel.fromEntity(ResolutionInput ri) => ResolutionInputModel(
      ri.expressionStr, ri.isStructured, ri.isInteractive);
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

  factory NodeSelectionInfoModel.fromEntity(NodeSelectionInfo nsi) => NodeSelectionInfoModel(
    nsi.expression, nsi.nodeId,
    PointModel.fromEntity(nsi.selection.lt),
    PointModel.fromEntity(nsi.selection.rb)
  );
}

class SubstitutionInfoModel extends SubstitutionInfo {
  const SubstitutionInfoModel(List<String> rules, List<String> results): super(rules, results);

  factory SubstitutionInfoModel.fromJson(Map<String, dynamic> json) => SubstitutionInfoModel(
      List<String>.from(json['rules']),
      List<String>.from(json['results'])
  );

  factory SubstitutionInfoModel.fromEntity(SubstitutionInfo si) => SubstitutionInfoModel(
    si.rules, si.results
  );
}

class CheckEndInputModel extends CheckEndInput {
  const CheckEndInputModel(String expression, String goalExpression, String goalPattern)
      : super(expression, goalExpression, goalPattern);

  Map<String, dynamic> toJson() => <String, dynamic>{
    'expression': expression,
    'goal': goalExpression,
    'pattern': goalPattern
  };

  factory CheckEndInputModel.fromEntity(CheckEndInput cei) => CheckEndInputModel(
    cei.expression, cei.goalExpression, cei.goalPattern
  );
}