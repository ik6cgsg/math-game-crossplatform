import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/entities/step_state.dart';
import 'package:math_game_crossplatform/domain/repositories/local_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';

import '../../core/usecase.dart';

class PerformSubstitution implements UseCase<StepState, Params> {
  final LocalRepository repository;

  PerformSubstitution(this.repository);

  @override
  Future<Either<Failure, StepState>> call(Params params) async {
    final substitutionInfo = params.currentStep.substitutionInfo;
    if (substitutionInfo == null) return Left(InternalFailure());
    if (params.ruleIndex >= substitutionInfo.results.length) return Left(InternalFailure());
    final currentExpression = substitutionInfo.results[params.ruleIndex];
    final step = StepState(currentExpression, params.currentStep.multiselectMode, null, null, params.currentStep.stepCount + 1);
    repository.saveLevelResult(Result(params.levelIndex, step.currentExpression, step.stepCount, LevelState.paused));
    // todo: log subst
    return Right(step);
  }
}

class Params extends Equatable {
  final int levelIndex;
  final int ruleIndex;
  final StepState currentStep;

  const Params(this.levelIndex, this.ruleIndex, this.currentStep);

  @override
  List<Object?> get props => [levelIndex, ruleIndex, currentStep];
}