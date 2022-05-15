import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';
import 'package:math_game_crossplatform/domain/entities/step_state.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/remote_repository.dart';

import '../../core/usecase.dart';

class SelectNode implements UseCase<StepState, Params> {
  final PlatformRepository platformRepository;
  final RemoteRepository remoteRepository;

  SelectNode(this.platformRepository, this.remoteRepository);

  @override
  Future<Either<Failure, StepState>> call(Params params) async {
    log.info('Usecase::SelectNode($params)');
    final prevStep = params.currentStep;
    if (params.tap == null) {
      remoteRepository.logEvent(StatisticActionSelectNode(0, 0, params.currentStep.multiselectMode));
      return Right(StepState(prevStep.currentExpression, prevStep.multiselectMode, null, null, prevStep.stepCount));
    }
    final selectInfo = await platformRepository.getNodeByTouch(params.tap!);
    log.info('Usecase::SelectNode: selectInfo = $selectInfo');
    var newSelectionInfoList = {...?prevStep.selectionInfo};
    return selectInfo.fold(
      (fail) => Left(fail),
      (selectInfo) async {
        var alreadyHave = newSelectionInfoList.any((e) => e.nodeId == selectInfo.nodeId);
        if (alreadyHave == true) {
          newSelectionInfoList.removeWhere((e) => e.nodeId == selectInfo.nodeId);
        } else if (prevStep.multiselectMode) {
          newSelectionInfoList.add(selectInfo);
        } else {
          newSelectionInfoList = {selectInfo};
        }
        if (newSelectionInfoList.isNotEmpty) {
          final substInfo = await platformRepository.getSubstitutionInfo(newSelectionInfoList.map((e) => e.nodeId).toList());
          log.info('Usecase::SelectNode: substInfo = $substInfo');
          return substInfo.fold(
            (fail) => Left(fail),
            (substInfo) {
              remoteRepository.logEvent(StatisticActionSelectNode(
                newSelectionInfoList.length,
                substInfo.results.length,
                params.currentStep.multiselectMode
              ));
              return Right(StepState(
                prevStep.currentExpression,
                prevStep.multiselectMode,
                newSelectionInfoList,
                substInfo,
                prevStep.stepCount
              ));
            }
          );
        } else {
          remoteRepository.logEvent(StatisticActionSelectNode(0, 0, params.currentStep.multiselectMode));
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