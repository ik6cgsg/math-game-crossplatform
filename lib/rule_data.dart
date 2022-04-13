import 'package:json_annotation/json_annotation.dart';
part 'rule_data.g.dart';

@JsonSerializable()
class Rule {
  @JsonKey(defaultValue: "")
  final String leftStructureString;
  @JsonKey(defaultValue: "")
  final String rightStructureString;
  @JsonKey(defaultValue: "")
  final String code;
  @JsonKey(defaultValue: "")
  final String nameEn;
  @JsonKey(defaultValue: "")
  final String nameRu;
  @JsonKey(defaultValue: "")
  final String descriptionShortEn;
  @JsonKey(defaultValue: "")
  final String descriptionShortRu;
  @JsonKey(defaultValue: "")
  final String descriptionEn;
  @JsonKey(defaultValue: "")
  final String descriptionRu;
  @JsonKey(defaultValue: "ORIGINAL")
  final String normalizationType;
  @JsonKey(defaultValue: false)
  final bool basedOnTaskContext;
  @JsonKey(defaultValue: false)
  final bool matchJumbledAndNested;
  @JsonKey(defaultValue: false)
  final bool isExtending;
  @JsonKey(defaultValue: false)
  final bool simpleAdditional;
  @JsonKey(defaultValue: 0)
  final int priority;
  @JsonKey(defaultValue: 1.0)
  final double weight;

  Rule(this.leftStructureString, this.rightStructureString, this.code, this.nameEn, this.nameRu, this.descriptionShortEn, this.descriptionShortRu, this.descriptionEn, this.descriptionRu, this.normalizationType, this.basedOnTaskContext, this.matchJumbledAndNested, this.isExtending, this.simpleAdditional, this.priority, this.weight);

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);
  Map<String, dynamic> toJson() => _$RuleToJson(this);
}

/*
data class RulePackLink(
var namespaceCode: String,
var rulePackCode: String,
var rulePackNameEn: String,
var rulePackNameRu: String
)

data class RulePackage(
/** Required values **/
@property:Required
var namespaceCode: String = "",
@property:Required
var code: String = "",
@property:Required
var version: Int = 0,
/** Optional values **/
var nameEn: String = "",
var nameRu: String = "",
var descriptionShortEn: String = "",
var descriptionShortRu: String = "",
var descriptionEn: String = "",
var descriptionRu: String = "",
var rulePacks: List<RulePackLink>? = null,
var rules: List<JsonObject>? = null,
var otherData: JsonElement? = null
)
*/