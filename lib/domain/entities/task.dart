import 'package:equatable/equatable.dart';

import 'rule.dart';
import 'rule_package.dart';

class Task extends Equatable {
  final String namespaceCode;
  final String code;
  final int version;
  final String nameEn;
  final String originalExpressionStructureString;
  final String goalType;
  final String? goalExpressionStructureString;
  final String nameRu;
  final String descriptionShortEn;
  final String descriptionShortRu;
  final String descriptionEn;
  final String descriptionRu;
  final String subjectType;
  final String? goalPattern;
  final Object? otherGoalData;
  final List<RulePackLink>? rulePacks;
  final List<Rule>? rules;
  final int stepsNumber;
  final int time;
  final double difficulty;
  final Object? solutionsStepsTree;
  final Object? hints;
  final Object? interestingFacts;
  final Object? nextRecommendedTasks;
  final Object? otherCheckSolutionData;
  final Object? otherAwardData;
  final Object? otherData;

  const Task(this.namespaceCode, this.code, this.version, this.nameEn,
      this.originalExpressionStructureString, this.goalType,
      this.goalExpressionStructureString, this.nameRu, this.descriptionShortEn,
      this.descriptionShortRu,
      this.descriptionEn, this.descriptionRu, this.subjectType,
      this.goalPattern, this.otherGoalData, this.rulePacks,
      this.rules, this.stepsNumber, this.time, this.difficulty,
      this.solutionsStepsTree, this.hints,
      this.interestingFacts, this.nextRecommendedTasks,
      this.otherCheckSolutionData, this.otherAwardData, this.otherData);

  @override
  List<Object?> get props => [
    namespaceCode, code, version, nameEn,
    originalExpressionStructureString, goalType,
    goalExpressionStructureString, nameRu, descriptionShortEn,
    descriptionShortRu,
    descriptionEn, descriptionRu, subjectType,
    goalPattern, otherGoalData, rulePacks,
    rules, stepsNumber, time, difficulty,
    solutionsStepsTree, hints,
    interestingFacts, nextRecommendedTasks,
    otherCheckSolutionData, otherAwardData, otherData
  ];
}

class TaskInfo extends Equatable {
  final String namespaceCode;
  final String code;
  final int version;

  const TaskInfo(this.namespaceCode, this.code, this.version);

  @override
  List<Object?> get props => [namespaceCode, code, version];
}