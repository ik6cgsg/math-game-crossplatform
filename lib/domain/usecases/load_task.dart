import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';

import '../../core/usecase.dart';
import '../entities/task.dart';

class LoadTask implements UseCase<Task, Params> {
  final AssetRepository repository;

  LoadTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(Params params) async {
    return await repository.loadTask(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params(this.number);

  @override
  List<Object> get props => [number];
}