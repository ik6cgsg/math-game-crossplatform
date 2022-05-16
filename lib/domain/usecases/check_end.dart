import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/entities/step_state.dart';
import 'package:math_game_crossplatform/domain/repositories/local_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';

import '../../core/usecase.dart';

class CheckEnd implements UseCase<bool, Params> {
  final PlatformRepository platformRepository;
  final LocalRepository localRepository;

  CheckEnd(this.platformRepository, this.localRepository);

  @override
  Future<Either<Failure, bool>> call(Params params) async {
    final res = await platformRepository.checkEnd(
      CheckEndInput(params.currentStep.currentExpression, params.goalExpression, params.goalPattern)
    );
    return res.fold(
      (fail) => Left(fail),
      (passed) {
        if (passed) {
          localRepository.saveLevelResult(Result(params.levelCode, params.currentStep.currentExpression,
              params.currentStep.stepCount, LevelState.passed));
          return const Right(true);
        }
        return const Right(false);
      }
    );
  }
}

class Params extends Equatable {
  final String levelCode;
  final String goalExpression, goalPattern;
  final StepState currentStep;

  const Params(this.levelCode, this.goalExpression, this.goalPattern, this.currentStep);

  @override
  List<Object?> get props => [levelCode, goalExpression, goalPattern, currentStep];
}

