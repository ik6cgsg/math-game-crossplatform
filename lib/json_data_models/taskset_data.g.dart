// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taskset_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FullTaskset _$FullTasksetFromJson(Map<String, dynamic> json) => FullTaskset(
      Taskset.fromJson(json['taskset'] as Map<String, dynamic>),
      (json['rulePacks'] as List<dynamic>)
          .map((e) => RulePackage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FullTasksetToJson(FullTaskset instance) =>
    <String, dynamic>{
      'taskset': instance.taskset,
      'rulePacks': instance.rulePacks,
    };

Taskset _$TasksetFromJson(Map<String, dynamic> json) => Taskset(
      json['namespaceCode'] as String? ?? '',
      json['code'] as String? ?? '',
      json['version'] as int? ?? 0,
      json['nameEn'] as String? ?? '',
      (json['tasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$TasksetToJson(Taskset instance) => <String, dynamic>{
      'namespaceCode': instance.namespaceCode,
      'code': instance.code,
      'version': instance.version,
      'nameEn': instance.nameEn,
      'tasks': instance.tasks,
      'nameRu': instance.nameRu,
      'descriptionShortEn': instance.descriptionShortEn,
      'descriptionShortRu': instance.descriptionShortRu,
      'descriptionEn': instance.descriptionEn,
      'descriptionRu': instance.descriptionRu,
      'subjectType': instance.subjectType,
      'recommendedByCommunity': instance.recommendedByCommunity,
      'otherData': instance.otherData,
    };
