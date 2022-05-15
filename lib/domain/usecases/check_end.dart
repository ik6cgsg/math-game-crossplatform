import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/local_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/remote_repository.dart';

import '../../core/usecase.dart';

class CheckEnd implements UseCase<PassedData, Params> {
  final AssetRepository assetRepository;
  final PlatformRepository platformRepository;
  final LocalRepository localRepository;
  final RemoteRepository remoteRepository;

  CheckEnd(this.assetRepository, this.platformRepository, this.localRepository, this.remoteRepository);

  @override
  Future<Either<Failure, PassedData>> call(Params params) async {
    final len = assetRepository.tasksCount;
    if (len == 0) return Left(InternalFailure());
    if (params.ignoreCheck) {
      remoteRepository.logEvent(StatisticActionLevelEnd(params.levelCode, true, params.stepCount));
      return Right(PassedData(true, params.levelIndex > 0, params.levelIndex < len! - 1));
    }
    final res = await platformRepository.checkEnd(
      CheckEndInput(params.currentExpression, params.goalExpression, params.goalPattern)
    );
    return res.fold(
      (fail) => Left(fail),
      (passed) {
        if (passed) {
          remoteRepository.logEvent(StatisticActionLevelEnd(params.levelCode, true, params.stepCount));
          localRepository.saveLevelResult(Result(params.levelCode, params.currentExpression, params.stepCount, LevelState.passed));
          return Right(PassedData(true, params.levelIndex > 0, params.levelIndex < len! - 1));
        }
        return const Right(PassedData(false, null, null));
      }
    );
  }
}

class Params extends Equatable {
  final int levelIndex;
  final String levelCode;
  final String currentExpression, goalExpression, goalPattern;
  final int stepCount;
  final bool ignoreCheck;

  const Params(this.levelIndex, this.levelCode, this.currentExpression, this.goalExpression, this.goalPattern, this.stepCount,
    {this.ignoreCheck = false});

  @override
  List<Object?> get props => [levelIndex, levelCode, currentExpression, goalExpression, goalPattern, stepCount, ignoreCheck];
}

class PassedData extends Equatable {
  final bool passed;
  final bool? hasPrev, hasNext;

  const PassedData(this.passed, this.hasPrev, this.hasNext);

  @override
  List<Object?> get props => [passed, hasPrev, hasNext];
}