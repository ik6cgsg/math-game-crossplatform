import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';
import 'package:math_game_crossplatform/domain/entities/step_state.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';

import '../../core/usecase.dart';

class CheckEnd implements UseCase<PassedData, Params> {
  final AssetRepository assetRepository;
  final PlatformRepository platformRepository;

  CheckEnd(this.assetRepository, this.platformRepository);

  @override
  Future<Either<Failure, PassedData>> call(Params params) async {
    final res = await platformRepository.checkEnd(
      CheckEndInput(params.currentExpression, params.goalExpression, params.goalPattern)
    );
    return res.fold(
      (fail) => Left(fail),
      (passed) {
        if (passed) {
          final len = assetRepository.tasksCount;
          if (len == 0) return Left(InternalFailure());
          return Right(PassedData(true, params.index > 0, params.index < len! - 1));
        }
        return Right(PassedData(false, null, null));
      }
    );
  }
}

class Params extends Equatable {
  final int index;
  final String currentExpression, goalExpression, goalPattern;

  const Params(this.index, this.currentExpression, this.goalExpression, this.goalPattern);

  @override
  List<Object?> get props => [index, currentExpression, goalExpression, goalPattern];
}

class PassedData extends Equatable {
  final bool passed;
  final bool? hasPrev, hasNext;

  const PassedData(this.passed, this.hasPrev, this.hasNext);

  @override
  List<Object?> get props => [passed, hasPrev, hasNext];
}