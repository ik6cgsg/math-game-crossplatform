import 'package:math_game_crossplatform/data/models/rule_model.dart';
import 'package:math_game_crossplatform/domain/entities/rule.dart';
import 'package:math_game_crossplatform/domain/entities/rule_package.dart';

class RulePackLinkModel extends RulePackLink {
  const RulePackLinkModel(String namespaceCode, String rulePackCode,
    String rulePackNameEn, String rulePackNameRu
  ): super(namespaceCode, rulePackCode, rulePackNameEn, rulePackNameRu);

  factory RulePackLinkModel.fromJson(Map<String, dynamic> json) => RulePackLinkModel(
    json['namespaceCode'] as String? ?? '',
    json['rulePackCode'] as String? ?? '',
    json['rulePackNameEn'] as String? ?? '',
    json['rulePackNameRu'] as String? ?? '',
  );
      
  Map<String, dynamic> toJson() => <String, dynamic>{
    'namespaceCode': namespaceCode,
    'rulePackCode': rulePackCode,
    'rulePackNameEn': rulePackNameEn,
    'rulePackNameRu': rulePackNameRu,
  };
}

class RulePackageModel extends RulePackage {
  const RulePackageModel(String namespaceCode, String code, int version, String nameEn, String nameRu,
    String descriptionShortEn, String descriptionShortRu, String descriptionEn, String descriptionRu,
    List<RulePackLinkModel>? rulePacks, List<RuleModel>? rules, Object? otherData): super(
      namespaceCode, code, version, nameEn, nameRu, descriptionShortEn, descriptionShortRu, descriptionEn,
      descriptionRu, rulePacks, rules, otherData
  );

  factory RulePackageModel.fromJson(Map<String, dynamic> json) => RulePackageModel(
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
        ?.map((e) => RulePackLinkModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['rules'] as List<dynamic>?)
        ?.map((e) => RuleModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['otherData'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'namespaceCode': namespaceCode,
    'code': code,
    'version': version,
    'nameEn': nameEn,
    'nameRu': nameRu,
    'descriptionShortEn': descriptionShortEn,
    'descriptionShortRu': descriptionShortRu,
    'descriptionEn': descriptionEn,
    'descriptionRu': descriptionRu,
    'rulePacks': rulePacks,
    'rules': rules,
    'otherData': otherData,
  };

  Set<RuleModel>? getAllRules(Map<String, RulePackageModel> allPacks) {
    var res = {...?rules};
    rulePacks?.forEach((element) {
      var fullPack = allPacks[element.rulePackCode];
      var rules = fullPack?.getAllRules(allPacks);
      res = {...res, ...?rules};
    });
    return res.map((e) => e as RuleModel).toSet();
  }
}