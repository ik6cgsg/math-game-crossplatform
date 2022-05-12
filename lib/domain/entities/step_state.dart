import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';

class StepState extends Equatable {
  final String currentExpression;
  final bool multiselectMode;
  final Set<NodeSelectionInfo>? selectionInfo;
  final SubstitutionInfo? substitutionInfo;

  const StepState(this.currentExpression, this.multiselectMode, this.selectionInfo, this.substitutionInfo);

  @override
  List<Object?> get props => [currentExpression, multiselectMode, selectionInfo, substitutionInfo];
}