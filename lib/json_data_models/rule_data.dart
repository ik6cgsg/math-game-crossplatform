import 'package:json_annotation/json_annotation.dart';

part 'rule_data.g.dart';

@JsonSerializable()
class Rule {
  @JsonKey(defaultValue: "") final String leftStructureString;
  @JsonKey(defaultValue: "") final String rightStructureString;
  @JsonKey(defaultValue: "") final String code;
  @JsonKey(defaultValue: "") final String nameEn;
  @JsonKey(defaultValue: "") final String nameRu;
  @JsonKey(defaultValue: "") final String descriptionShortEn;
  @JsonKey(defaultValue: "") final String descriptionShortRu;
  @JsonKey(defaultValue: "") final String descriptionEn;
  @JsonKey(defaultValue: "") final String descriptionRu;
  @JsonKey(defaultValue: "ORIGINAL") final String normalizationType;
  @JsonKey(defaultValue: false) final bool basedOnTaskContext;
  @JsonKey(defaultValue: false) final bool matchJumbledAndNested;
  @JsonKey(defaultValue: false) final bool isExtending;
  @JsonKey(defaultValue: false) final bool simpleAdditional;
  @JsonKey(defaultValue: 0) final int priority;
  @JsonKey(defaultValue: 1.0) final double weight;

  Rule(this.leftStructureString, this.rightStructureString, this.code, this.nameEn, this.nameRu, this.descriptionShortEn,
      this.descriptionShortRu, this.descriptionEn, this.descriptionRu, this.normalizationType, this.basedOnTaskContext,
      this.matchJumbledAndNested, this.isExtending, this.simpleAdditional, this.priority, this.weight);

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);
  Map<String, dynamic> toJson() => _$RuleToJson(this);
}

@JsonSerializable()
class RulePackLink {
  @JsonKey(defaultValue: "") final String namespaceCode;
  @JsonKey(defaultValue: "") final String rulePackCode;
  @JsonKey(defaultValue: "") final String rulePackNameEn;
  @JsonKey(defaultValue: "") final String rulePackNameRu;

  RulePackLink(this.namespaceCode, this.rulePackCode, this.rulePackNameEn, this.rulePackNameRu);

  factory RulePackLink.fromJson(Map<String, dynamic> json) => _$RulePackLinkFromJson(json);
  Map<String, dynamic> toJson() => _$RulePackLinkToJson(this);
}

@JsonSerializable()
class RulePackage {
  @JsonKey(defaultValue: "") final String namespaceCode;
  @JsonKey(defaultValue: "") final String code;
  @JsonKey(defaultValue: 0) final int version;
  @JsonKey(defaultValue: "") final String nameEn;
  @JsonKey(defaultValue: "") final String nameRu;
  @JsonKey(defaultValue: "") final String descriptionShortEn;
  @JsonKey(defaultValue: "") final String descriptionShortRu;
  @JsonKey(defaultValue: "") final String descriptionEn;
  @JsonKey(defaultValue: "") final String descriptionRu;
  @JsonKey(defaultValue: null) final List<RulePackLink>? rulePacks;
  @JsonKey(defaultValue: null) final List<Rule>? rules;
  @JsonKey(defaultValue: null) final Object? otherData;

  RulePackage(this.namespaceCode, this.code, this.version, this.nameEn, this.nameRu, this.descriptionShortEn,
      this.descriptionShortRu, this.descriptionEn, this.descriptionRu, this.rulePacks, this.rules, this.otherData);

  factory RulePackage.fromJson(Map<String, dynamic> json) => _$RulePackageFromJson(json);

  Map<String, dynamic> toJson() => _$RulePackageToJson(this);

  Set<Rule>? getAllRules(Map<String, RulePackage> allPacks) {
    var res = {...?rules};
    rulePacks?.forEach((element) {
      var fullPack = allPacks[element.rulePackCode];
      var rules = fullPack?.getAllRules(allPacks);
      res = {...res, ...?rules};
    });
    return res;
  }
}
