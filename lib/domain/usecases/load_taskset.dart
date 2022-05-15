import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/local_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/remote_repository.dart';

import '../../core/usecase.dart';

class LoadTaskset implements UseCase<TasksetWithResult, NoParams> {
  final AssetRepository assetRepository;
  final LocalRepository localRepository;
  final RemoteRepository remoteRepository;

  LoadTaskset(this.assetRepository, this.localRepository, this.remoteRepository);

  @override
  Future<Either<Failure, TasksetWithResult>> call(NoParams params) async {
    remoteRepository.logEvent(const StatisticActionScreenOpen('GameScreen'));
    final res = await assetRepository.loadFullTaskset();
    return await res.fold(
      (fail) async => Left(fail),
      (taskset) async {
        final res = await localRepository.loadAllResults();
        return res.fold(
          (fail) => Right(TasksetWithResult(taskset, null)),
          (results) => Right(TasksetWithResult(taskset, results))
        );
      }
    );
  }
}

class TasksetWithResult extends Equatable {
  final Taskset taskset;
  final List<Result>? results;

  const TasksetWithResult(this.taskset, this.results);

  @override
  List<Object?> get props => [taskset, results];
}