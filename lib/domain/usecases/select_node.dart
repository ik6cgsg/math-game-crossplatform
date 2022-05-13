import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';
import 'package:math_game_crossplatform/domain/entities/step_state.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';

import '../../core/usecase.dart';

class SelectNode implements UseCase<StepState, Params> {
  final PlatformRepository repository;

  SelectNode(this.repository);

  @override
  Future<Either<Failure, StepState>> call(Params params) async {
    log.info('Usecase::SelectNode($params)');
    final prevStep = params.currentStep;
    if (params.tap == null) {
      return Right(StepState(prevStep.currentExpression, prevStep.multiselectMode, null, null, prevStep.stepCount));
    }
    final selectInfo = await repository.getNodeByTouch(params.tap!);
    log.info('Usecase::SelectNode: selectInfo = $selectInfo');
    Set<NodeSelectionInfo>? newSelectionInfoList = prevStep.selectionInfo == null ? null : Set.from(prevStep.selectionInfo!);
    return selectInfo.fold(
      (fail) => Left(fail),
      (selectInfo) async {
        var alreadyHave = newSelectionInfoList?.any((e) => e.nodeId == selectInfo.nodeId);
        if (alreadyHave == true) {
          newSelectionInfoList?.removeWhere((e) => e.nodeId == selectInfo.nodeId);
          if (newSelectionInfoList?.isEmpty == true) {
            newSelectionInfoList = null;
          }
        } else if (prevStep.multiselectMode) {
          newSelectionInfoList ??= {};
          newSelectionInfoList?.add(selectInfo);
        } else {
          newSelectionInfoList = {selectInfo};
        }
        if (newSelectionInfoList != null) {
          final substInfo = await repository.getSubstitutionInfo(newSelectionInfoList!.map((e) => e.nodeId).toList());
          log.info('Usecase::SelectNode: substInfo = $substInfo');
          return substInfo.fold(
            (fail) => Left(fail),
            (substInfo) => Right(StepState(
                prevStep.currentExpression,
                prevStep.multiselectMode,
                newSelectionInfoList,
                substInfo,
                prevStep.stepCount
            ))
          );
        } else {
          return Right(StepState(prevStep.currentExpression, prevStep.multiselectMode, null, null, prevStep.stepCount));
        }
      }
    );
  }
}

class Params extends Equatable {
  final Point? tap;
  final StepState currentStep;

  const Params(this.tap, this.currentStep);

  @override
  List<Object?> get props => [tap, currentStep];
}