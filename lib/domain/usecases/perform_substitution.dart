import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';
import 'package:math_game_crossplatform/domain/entities/step_state.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';

import '../../core/usecase.dart';

class PerformSubstitution implements UseCase<StepState, Params> {
  final PlatformRepository repository;

  PerformSubstitution(this.repository);

  @override
  Future<Either<Failure, StepState>> call(Params params) async {
    final substitutionInfo = params.currentStep.substitutionInfo;
    if (substitutionInfo == null) return Left(InternalFailure());
    if (params.index >= substitutionInfo.results.length) return Left(InternalFailure());
    final currentExpression = substitutionInfo.results[params.index];
    return Right(StepState(currentExpression, params.currentStep.multiselectMode, null, null));
  }
}

class Params extends Equatable {
  final int index;
  final StepState currentStep;

  const Params(this.index, this.currentStep);

  @override
  List<Object?> get props => [index, currentStep];
}