// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rule _$RuleFromJson(Map<String, dynamic> json) => Rule(
      json['leftStructureString'] as String? ?? '',
      json['rightStructureString'] as String? ?? '',
      json['code'] as String? ?? '',
      json['nameEn'] as String? ?? '',
      json['nameRu'] as String? ?? '',
      json['descriptionShortEn'] as String? ?? '',
      json['descriptionShortRu'] as String? ?? '',
      json['descriptionEn'] as String? ?? '',
      json['descriptionRu'] as String? ?? '',
      json['normalizationType'] as String? ?? 'ORIGINAL',
      json['basedOnTaskContext'] as bool? ?? false,
      json['matchJumbledAndNested'] as bool? ?? false,
      json['isExtending'] as bool? ?? false,
      json['simpleAdditional'] as bool? ?? false,
      json['priority'] as int? ?? 0,
      (json['weight'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$RuleToJson(Rule instance) => <String, dynamic>{
      'leftStructureString': instance.leftStructureString,
      'rightStructureString': instance.rightStructureString,
      'code': instance.code,
      'nameEn': instance.nameEn,
      'nameRu': instance.nameRu,
      'descriptionShortEn': instance.descriptionShortEn,
      'descriptionShortRu': instance.descriptionShortRu,
      'descriptionEn': instance.descriptionEn,
      'descriptionRu': instance.descriptionRu,
      'normalizationType': instance.normalizationType,
      'basedOnTaskContext': instance.basedOnTaskContext,
      'matchJumbledAndNested': instance.matchJumbledAndNested,
      'isExtending': instance.isExtending,
      'simpleAdditional': instance.simpleAdditional,
      'priority': instance.priority,
      'weight': instance.weight,
    };

RulePackLink _$RulePackLinkFromJson(Map<String, dynamic> json) => RulePackLink(
      json['namespaceCode'] as String? ?? '',
      json['rulePackCode'] as String? ?? '',
      json['rulePackNameEn'] as String? ?? '',
      json['rulePackNameRu'] as String? ?? '',
    );

Map<String, dynamic> _$RulePackLinkToJson(RulePackLink instance) =>
    <String, dynamic>{
      'namespaceCode': instance.namespaceCode,
      'rulePackCode': instance.rulePackCode,
      'rulePackNameEn': instance.rulePackNameEn,
      'rulePackNameRu': instance.rulePackNameRu,
    };

RulePackage _$RulePackageFromJson(Map<String, dynamic> json) => RulePackage(
      json['namespaceCode'] as String? ?? '',
      json['code'] as String? ?? '',
      json['version'] as int? ?? 0,
      json['nameEn'] as String? ?? '',
      json['nameRu'] as String? ?? '',
      json['descriptionShortEn'] as String? ?? '',
      json['descriptionShortRu'] as String? ?? '',
      json['descriptionEn'] as String? ?? '',
      json['descriptionRu'] as String? ?? '',
      (json['rulePacks'] as List<dynamic>?)
          ?.map((e) => RulePackLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['rules'] as List<dynamic>?)
          ?.map((e) => Rule.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['otherData'],
    );

Map<String, dynamic> _$RulePackageToJson(RulePackage instance) =>
    <String, dynamic>{
      'namespaceCode': instance.namespaceCode,
      'code': instance.code,
      'version': instance.version,
      'nameEn': instance.nameEn,
      'nameRu': instance.nameRu,
      'descriptionShortEn': instance.descriptionShortEn,
      'descriptionShortRu': instance.descriptionShortRu,
      'descriptionEn': instance.descriptionEn,
      'descriptionRu': instance.descriptionRu,
      'rulePacks': instance.rulePacks,
      'rules': instance.rules,
      'otherData': instance.otherData,
    };
