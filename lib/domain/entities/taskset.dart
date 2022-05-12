import 'package:equatable/equatable.dart';

import 'rule_package.dart';
import 'task.dart';

class FullTaskset extends Equatable {
  final Taskset taskset;
  final List<RulePackage> rulePacks;

  const FullTaskset(this.taskset, this.rulePacks);

  @override
  List<Object?> get props => [taskset, rulePacks];
}

class Taskset extends Equatable {
  final String namespaceCode;
  final String code;
  final int version;
  final String nameEn;
  final List<Task> tasks;
  final String nameRu;
  final String descriptionShortEn;
  final String descriptionShortRu;
  final String descriptionEn;
  final String descriptionRu;
  final String subjectType;
  final bool recommendedByCommunity;
  final Object? otherData;

  const Taskset(this.namespaceCode, this.code, this.version, this.nameEn, this.tasks,
      this.nameRu, this.descriptionShortEn,
      this.descriptionShortRu, this.descriptionEn, this.descriptionRu,
      this.subjectType, this.recommendedByCommunity, this.otherData);

  @override
  List<Object?> get props => [
    namespaceCode, code, version, nameEn, tasks, nameRu, descriptionShortEn,
    descriptionShortRu, descriptionEn, descriptionRu,
    subjectType, recommendedByCommunity, otherData
  ];
}