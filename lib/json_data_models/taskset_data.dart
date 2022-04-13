import 'package:json_annotation/json_annotation.dart';
import 'package:math_game_crossplatform/json_data_models/rule_data.dart';
import 'package:math_game_crossplatform/json_data_models/task_data.dart';
part 'taskset_data.g.dart';

@JsonSerializable()
class FullTaskset {
  @JsonKey() final Taskset taskset;
  @JsonKey() final List<RulePackage> rulePacks;

  FullTaskset(this.taskset, this.rulePacks);

  factory FullTaskset.fromJson(Map<String, dynamic> json) => _$FullTasksetFromJson(json);
  Map<String, dynamic> toJson() => _$FullTasksetToJson(this);
}

@JsonSerializable()
class Taskset {
  @JsonKey(defaultValue: "") final String namespaceCode;
  @JsonKey(defaultValue: "") final String code;
  @JsonKey(defaultValue: 0) final int version;
  @JsonKey(defaultValue: "") final String nameEn;
  @JsonKey() final List<Task> tasks;
  @JsonKey(defaultValue: "") final String nameRu;
  @JsonKey(defaultValue: "") final String descriptionShortEn;
  @JsonKey(defaultValue: "") final String descriptionShortRu;
  @JsonKey(defaultValue: "") final String descriptionEn;
  @JsonKey(defaultValue: "") final String descriptionRu;
  @JsonKey(defaultValue: "") final String subjectType;
  @JsonKey(defaultValue: false) final bool recommendedByCommunity;
  @JsonKey(defaultValue: null) final Object? otherData;

  Taskset(this.namespaceCode, this.code, this.version, this.nameEn, this.tasks, this.nameRu, this.descriptionShortEn,
      this.descriptionShortRu, this.descriptionEn, this.descriptionRu, this.subjectType, this.recommendedByCommunity, this.otherData);

  factory Taskset.fromJson(Map<String, dynamic> json) => _$TasksetFromJson(json);
  Map<String, dynamic> toJson() => _$TasksetToJson(this);
}