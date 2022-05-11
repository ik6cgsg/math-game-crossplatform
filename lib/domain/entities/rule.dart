import 'package:equatable/equatable.dart';

class Rule extends Equatable {
  final String leftStructureString;
  final String rightStructureString;
  final String code;
  final String nameEn;
  final String nameRu;
  final String descriptionShortEn;
  final String descriptionShortRu;
  final String descriptionEn;
  final String descriptionRu;
  final String normalizationType;
  final bool basedOnTaskContext;
  final bool matchJumbledAndNested;
  final bool isExtending;
  final bool simpleAdditional;
  final int priority;
  final double weight;

  const Rule(this.leftStructureString, this.rightStructureString, this.code, this.nameEn, this.nameRu, this.descriptionShortEn,
      this.descriptionShortRu, this.descriptionEn, this.descriptionRu, this.normalizationType, this.basedOnTaskContext,
      this.matchJumbledAndNested, this.isExtending, this.simpleAdditional, this.priority, this.weight);

  @override
  List<Object?> get props => [leftStructureString, rightStructureString, code, nameEn, nameRu, descriptionShortEn,
    descriptionShortRu, descriptionEn, descriptionRu, normalizationType, basedOnTaskContext,
    matchJumbledAndNested, isExtending, simpleAdditional, priority, weight];
}