import 'package:math_game_crossplatform/domain/entities/taskset.dart';

import 'rule_package_model.dart';
import 'task_model.dart';

class FullTasksetModel extends FullTaskset {
  const FullTasksetModel(TasksetModel taskset, List<RulePackageModel> rulePacks): super(taskset, rulePacks);

  factory FullTasksetModel.fromJson(Map<String, dynamic> json) => FullTasksetModel(
    TasksetModel.fromJson(json['taskset'] as Map<String, dynamic>),
    (json['rulePacks'] as List<dynamic>)
        .map((e) => RulePackageModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'taskset': taskset,
    'rulePacks': rulePacks,
  };

  Map<String, RulePackageModel> getAllPacksMap() {
    Map<String, RulePackageModel> allPacks = {};
    for (var rp in rulePacks) {
      allPacks[rp.code] = rp as RulePackageModel;
    }
    return allPacks;
  }
}

class TasksetModel extends Taskset {
  const TasksetModel(String namespaceCode, String code, int version, String nameEn, List<TaskModel> tasks,
    String nameRu, String descriptionShortEn, String descriptionShortRu, String descriptionEn,
    String descriptionRu, String subjectType, bool recommendedByCommunity, Object? otherData
  ): super(
    namespaceCode, code, version, nameEn, tasks, nameRu, descriptionShortEn, descriptionShortRu,
    descriptionEn, descriptionRu, subjectType, recommendedByCommunity, otherData
  );

  factory TasksetModel.fromJson(Map<String, dynamic> json) => TasksetModel(
    json['namespaceCode'] as String? ?? '',
    json['code'] as String? ?? '',
    json['version'] as int? ?? 0,
    json['nameEn'] as String? ?? '',
    (json['tasks'] as List<dynamic>)
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['nameRu'] as String? ?? '',
    json['descriptionShortEn'] as String? ?? '',
    json['descriptionShortRu'] as String? ?? '',
    json['descriptionEn'] as String? ?? '',
    json['descriptionRu'] as String? ?? '',
    json['subjectType'] as String? ?? '',
    json['recommendedByCommunity'] as bool? ?? false,
    json['otherData'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'namespaceCode': namespaceCode,
    'code': code,
    'version': version,
    'nameEn': nameEn,
    'tasks': tasks,
    'nameRu': nameRu,
    'descriptionShortEn': descriptionShortEn,
    'descriptionShortRu': descriptionShortRu,
    'descriptionEn': descriptionEn,
    'descriptionRu': descriptionRu,
    'subjectType': subjectType,
    'recommendedByCommunity': recommendedByCommunity,
    'otherData': otherData,
  };
}