import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/repositories/local_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/remote_repository.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_state.dart';

import '../../core/usecase.dart';

class NoStepsForUndoFailure extends Failure {}

class UndoStep implements UseCase<List<Step>, Params> {
  final LocalRepository localRepository;
  final RemoteRepository remoteRepository;

  UndoStep(this.localRepository, this.remoteRepository);

  @override
  Future<Either<Failure, List<Step>>> call(Params params) async {
    if (params.steps.length < 2) return Left(NoStepsForUndoFailure());
    final history = [...params.steps];
    final old = history.removeLast();
    final newStep = history.last.state;
    remoteRepository.logEvent(StatisticActionUndo(
        newStep.selectionInfo?.length ?? 0,
        newStep.substitutionInfo?.results.length ?? 0,
        newStep.multiselectMode,
        newStep.stepCount
    ));
    if (newStep.stepCount != old.state.stepCount) {
        localRepository.saveLevelResult(
          Result(params.levelCode, newStep.currentExpression, newStep.stepCount, LevelState.paused)
        );
        return Right([...history]);
    }
    return Right([...history]);
  }
}

class Params extends Equatable {
  final String levelCode;
  final List<Step> steps;

  const Params(this.levelCode, this.steps);

  @override
  List<Object?> get props => [levelCode, steps];
}