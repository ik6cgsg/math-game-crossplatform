import 'package:dartz/dartz.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';

import '../../core/usecase.dart';

// todo TasksetWithResult
class LoadTaskset implements UseCase<Taskset, NoParams> {
  final AssetRepository repository;

  LoadTaskset(this.repository);

  @override
  Future<Either<Failure, Taskset>> call(NoParams params) async {
    return await repository.loadFullTaskset();
  }
}