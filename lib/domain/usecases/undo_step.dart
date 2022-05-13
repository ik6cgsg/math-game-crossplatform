import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/entities/step_state.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/local_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_state.dart';

import '../../core/usecase.dart';

class NoStepsForUndoFailure extends Failure {}

class UndoStep implements UseCase<List<Step>, Params> {
  final LocalRepository localRepository;

  UndoStep(this.localRepository);

  @override
  Future<Either<Failure, List<Step>>> call(Params params) async {
    if (params.steps.length < 2) return Left(NoStepsForUndoFailure());
    final history = [...params.steps];
    final old = history.removeLast();
    if (history.last.state.stepCount != old.state.stepCount) {
      final saveRes = await localRepository.saveLevelResult(Result(params.levelIndex, history.last.state.currentExpression, history.last.state.stepCount, LevelState.paused));
      return saveRes.fold(
        (fail) => Left(fail),
        (_) => Right([...history])
      );
    }
    return Right([...history]);
  }
}

class Params extends Equatable {
  final int levelIndex;
  final List<Step> steps;

  const Params(this.levelIndex, this.steps);

  @override
  List<Object?> get props => [levelIndex, steps];
}