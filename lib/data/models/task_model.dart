import 'package:math_game_crossplatform/domain/entities/task.dart';

import 'rule_model.dart';
import 'rule_package_model.dart';

class TaskModel extends Task {
  const TaskModel(String namespaceCode, String code, int version, String nameEn,
    String originalExpressionStructureString, String goalType, String? goalExpressionStructureString,
    String nameRu, String descriptionShortEn, String descriptionShortRu, String descriptionEn,
    String descriptionRu, String subjectType, String? goalPattern, Object? otherGoalData,
    List<RulePackLinkModel>? rulePacks, List<RuleModel>? rules, int stepsNumber, int time, double difficulty,
    Object? solutionsStepsTree, Object? hints, Object? interestingFacts, Object? nextRecommendedTasks,
    Object? otherCheckSolutionData, Object? otherAwardData, Object? otherData
  ): super(
    namespaceCode, code, version, nameEn, originalExpressionStructureString, goalType, goalExpressionStructureString,
    nameRu, descriptionShortEn, descriptionShortRu, descriptionEn, descriptionRu, subjectType, goalPattern,
    otherGoalData, rulePacks, rules, stepsNumber, time, difficulty, solutionsStepsTree, hints, interestingFacts,
    nextRecommendedTasks, otherCheckSolutionData, otherAwardData, otherData
  );

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    json['namespaceCode'] as String? ?? '',
    json['code'] as String? ?? '',
    json['version'] as int? ?? 0,
    json['nameEn'] as String? ?? '',
    json['originalExpressionStructureString'] as String? ?? '',
    json['goalType'] as String? ?? '',
    json['goalExpressionStructureString'] as String?,
    json['nameRu'] as String? ?? '',
    json['descriptionShortEn'] as String? ?? '',
    json['descriptionShortRu'] as String? ?? '',
    json['descriptionEn'] as String? ?? '',
    json['descriptionRu'] as String? ?? '',
    json['subjectType'] as String? ?? '',
    json['goalPattern'] as String?,
    json['otherGoalData'],
    (json['rulePacks'] as List<dynamic>?)
        ?.map((e) => RulePackLinkModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['rules'] as List<dynamic>?)
        ?.map((e) => RuleModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['stepsNumber'] as int? ?? 0,
    json['time'] as int? ?? 0,
    (json['difficulty'] as num?)?.toDouble() ?? 0.0,
    json['solutionsStepsTree'],
    json['hints'],
    json['interestingFacts'],
    json['nextRecommendedTasks'],
    json['otherCheckSolutionData'],
    json['otherAwardData'],
    json['otherData'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'namespaceCode': namespaceCode,
    'code': code,
    'version': version,
    'nameEn': nameEn,
    'originalExpressionStructureString':
    originalExpressionStructureString,
    'goalType': goalType,
    'goalExpressionStructureString': goalExpressionStructureString,
    'nameRu': nameRu,
    'descriptionShortEn': descriptionShortEn,
    'descriptionShortRu': descriptionShortRu,
    'descriptionEn': descriptionEn,
    'descriptionRu': descriptionRu,
    'subjectType': subjectType,
    'goalPattern': goalPattern,
    'otherGoalData': otherGoalData,
    'rulePacks': rulePacks,
    'rules': rules,
    'stepsNumber': stepsNumber,
    'time': time,
    'difficulty': difficulty,
    'solutionsStepsTree': solutionsStepsTree,
    'hints': hints,
    'interestingFacts': interestingFacts,
    'nextRecommendedTasks': nextRecommendedTasks,
    'otherCheckSolutionData': otherCheckSolutionData,
    'otherAwardData': otherAwardData,
    'otherData': otherData,
  };

  Set<RuleModel> getAllRules(Map<String, RulePackageModel> allPacks) {
    var allRules = {...?rules};
    rulePacks?.forEach((element) {
      final packRules = allPacks[element.rulePackCode]?.getAllRules(allPacks);
      allRules = {...allRules, ...?packRules};
    });
    return allRules.map((e) => e as RuleModel).toSet();
  }
}