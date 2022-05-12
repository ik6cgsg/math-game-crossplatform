import 'package:equatable/equatable.dart';

import 'rule.dart';

class RulePackLink extends Equatable {
  final String namespaceCode;
  final String rulePackCode;
  final String rulePackNameEn;
  final String rulePackNameRu;

  const RulePackLink(this.namespaceCode, this.rulePackCode, this.rulePackNameEn, this.rulePackNameRu);

  @override
  List<Object?> get props => [
    namespaceCode, rulePackCode, rulePackNameEn, rulePackNameRu
  ];
}

class RulePackage extends Equatable {
  final String namespaceCode;
  final String code;
  final int version;
  final String nameEn;
  final String nameRu;
  final String descriptionShortEn;
  final String descriptionShortRu;
  final String descriptionEn;
  final String descriptionRu;
  final List<RulePackLink>? rulePacks;
  final List<Rule>? rules;
  final Object? otherData;

  const RulePackage(this.namespaceCode, this.code, this.version, this.nameEn, this.nameRu, this.descriptionShortEn,
      this.descriptionShortRu, this.descriptionEn, this.descriptionRu, this.rulePacks, this.rules, this.otherData);

  @override
  List<Object?> get props => [
    namespaceCode, code, version, nameEn, nameRu, descriptionShortEn,
    descriptionShortRu, descriptionEn, descriptionRu, rulePacks, rules, otherData
  ];
}