// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
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
          ?.map((e) => RulePackLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['rules'] as List<dynamic>?)
          ?.map((e) => Rule.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'namespaceCode': instance.namespaceCode,
      'code': instance.code,
      'version': instance.version,
      'nameEn': instance.nameEn,
      'originalExpressionStructureString':
          instance.originalExpressionStructureString,
      'goalType': instance.goalType,
      'goalExpressionStructureString': instance.goalExpressionStructureString,
      'nameRu': instance.nameRu,
      'descriptionShortEn': instance.descriptionShortEn,
      'descriptionShortRu': instance.descriptionShortRu,
      'descriptionEn': instance.descriptionEn,
      'descriptionRu': instance.descriptionRu,
      'subjectType': instance.subjectType,
      'goalPattern': instance.goalPattern,
      'otherGoalData': instance.otherGoalData,
      'rulePacks': instance.rulePacks,
      'rules': instance.rules,
      'stepsNumber': instance.stepsNumber,
      'time': instance.time,
      'difficulty': instance.difficulty,
      'solutionsStepsTree': instance.solutionsStepsTree,
      'hints': instance.hints,
      'interestingFacts': instance.interestingFacts,
      'nextRecommendedTasks': instance.nextRecommendedTasks,
      'otherCheckSolutionData': instance.otherCheckSolutionData,
      'otherAwardData': instance.otherAwardData,
      'otherData': instance.otherData,
    };
