import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/core/usecase.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/remote_repository.dart';

class GetPassedData implements UseCase<PassedData, Params> {
  final AssetRepository assetRepository;
  final RemoteRepository remoteRepository;

  GetPassedData(this.assetRepository, this.remoteRepository);

  @override
  Future<Either<Failure, PassedData>> call(Params params) async {
    final len = assetRepository.tasksCount;
    if (len == 0) return Left(InternalFailure());
    remoteRepository.logEvent(StatisticActionLevelEnd(params.levelCode, true, params.stepCount));
    return Right(PassedData(params.levelIndex > 0, params.levelIndex < len! - 1));
  }
}

class Params extends Equatable {
  final int levelIndex;
  final String levelCode;
  final int stepCount;

  const Params(this.levelIndex, this.levelCode, this.stepCount);

  @override
  List<Object?> get props => [levelIndex, levelCode, stepCount];
}

class PassedData extends Equatable {
  final bool hasPrev, hasNext;

  const PassedData(this.hasPrev, this.hasNext);

  @override
  List<Object?> get props => [hasPrev, hasNext];
}