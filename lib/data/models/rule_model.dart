import 'package:math_game_crossplatform/domain/entities/rule.dart';

class RuleModel extends Rule {
  const RuleModel(String leftStructureString, String rightStructureString, String code, String nameEn, String nameRu,
      String descriptionShortEn, String descriptionShortRu, String descriptionEn, String descriptionRu,
      String normalizationType, bool basedOnTaskContext, bool matchJumbledAndNested, bool isExtending,
      bool simpleAdditional, int priority, double weight
  ): super(
      leftStructureString, rightStructureString, code, nameEn, nameRu, descriptionShortEn,
      descriptionShortRu, descriptionEn, descriptionRu, normalizationType, basedOnTaskContext,
      matchJumbledAndNested, isExtending, simpleAdditional, priority, weight
  );

  factory RuleModel.fromJson(Map<String, dynamic> json) => RuleModel(
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

  Map<String, dynamic> toJson() => <String, dynamic>{
    'leftStructureString': leftStructureString,
    'rightStructureString': rightStructureString,
    'code': code,
    'nameEn': nameEn,
    'nameRu': nameRu,
    'descriptionShortEn': descriptionShortEn,
    'descriptionShortRu': descriptionShortRu,
    'descriptionEn': descriptionEn,
    'descriptionRu': descriptionRu,
    'normalizationType': normalizationType,
    'basedOnTaskContext': basedOnTaskContext,
    'matchJumbledAndNested': matchJumbledAndNested,
    'isExtending': isExtending,
    'simpleAdditional': simpleAdditional,
    'priority': priority,
    'weight': weight,
  };
}