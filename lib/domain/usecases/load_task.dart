import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/local_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/remote_repository.dart';

import '../../core/usecase.dart';
import '../entities/task.dart';

class LoadTask implements UseCase<TaskWithResult, Params> {
  final AssetRepository assetRepository;
  final LocalRepository localRepository;
  final RemoteRepository remoteRepository;

  LoadTask(this.assetRepository, this.localRepository, this.remoteRepository);

  @override
  Future<Either<Failure, TaskWithResult>> call(Params params) async {
    final task = await assetRepository.loadTask(params.number);
    return await task.fold(
      (fail) async => Left(fail),
      (task) async {
        remoteRepository.logEvent(StatisticActionLevelStart(task.code, params.number));
        final res = await localRepository.loadResultFor(task.code);
        return res.fold(
            (fail) => Right(TaskWithResult(task, null)),
            (result) => Right(TaskWithResult(task, result))
        );
      }
    );
  }
}

class TaskWithResult extends Equatable {
  final Task task;
  final Result? result;

  const TaskWithResult(this.task, this.result);

  @override
  List<Object?> get props => [task, result];
}

class Params extends Equatable {
  final int number;

  const Params(this.number);

  @override
  List<Object> get props => [number];
}