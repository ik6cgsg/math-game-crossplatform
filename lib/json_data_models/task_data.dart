import 'package:json_annotation/json_annotation.dart';
import 'package:math_game_crossplatform/json_data_models/rule_data.dart';
part 'task_data.g.dart';

@JsonSerializable()
class Task {
  @JsonKey(defaultValue: "") final String namespaceCode;
  @JsonKey(defaultValue: "") final String code;
  @JsonKey(defaultValue: 0) final int version;
  @JsonKey(defaultValue: "") final String nameEn;
  @JsonKey(defaultValue: "") final String originalExpressionStructureString;
  @JsonKey(defaultValue: "") final String goalType;
  @JsonKey(defaultValue: null) final String? goalExpressionStructureString;
  @JsonKey(defaultValue: "") final String nameRu;
  @JsonKey(defaultValue: "") final String descriptionShortEn;
  @JsonKey(defaultValue: "") final String descriptionShortRu;
  @JsonKey(defaultValue: "") final String descriptionEn;
  @JsonKey(defaultValue: "") final String descriptionRu;
  @JsonKey(defaultValue: "") final String subjectType;
  @JsonKey(defaultValue: null) final String? goalPattern;
  @JsonKey(defaultValue: null) final Object? otherGoalData;
  @JsonKey(defaultValue: null) final List<RulePackLink>? rulePacks;
  @JsonKey(defaultValue: null) final List<Rule>? rules;
  @JsonKey(defaultValue: 0) final int stepsNumber;
  @JsonKey(defaultValue: 0) final int time;
  @JsonKey(defaultValue: 0.0) final double difficulty;
  @JsonKey(defaultValue: null) final Object? solutionsStepsTree;
  @JsonKey(defaultValue: null) final Object? hints;
  @JsonKey(defaultValue: null) final Object? interestingFacts;
  @JsonKey(defaultValue: null) final Object? nextRecommendedTasks;
  @JsonKey(defaultValue: null) final Object? otherCheckSolutionData;
  @JsonKey(defaultValue: null) final Object? otherAwardData;
  @JsonKey(defaultValue: null) final Object? otherData;

  Task(this.namespaceCode, this.code, this.version, this.nameEn, this.originalExpressionStructureString, this.goalType,
      this.goalExpressionStructureString, this.nameRu, this.descriptionShortEn, this.descriptionShortRu,
      this.descriptionEn, this.descriptionRu, this.subjectType, this.goalPattern, this.otherGoalData, this.rulePacks,
      this.rules, this.stepsNumber, this.time, this.difficulty, this.solutionsStepsTree, this.hints,
      this.interestingFacts, this.nextRecommendedTasks, this.otherCheckSolutionData, this.otherAwardData, this.otherData);

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}