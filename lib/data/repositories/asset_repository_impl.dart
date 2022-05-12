import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter/services.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/datasources/local_data_source.dart';
import 'package:math_game_crossplatform/data/datasources/platform_data_source.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';
import 'package:math_game_crossplatform/domain/entities/task.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';

import '../../core/exceptions.dart';
import '../models/task_model.dart';
import '../models/taskset_model.dart';

class AssetRepositoryImpl implements AssetRepository {
  final LocalDataSource localDataSource;
  final PlatformDataSource platformDataSource;

  late final FullTasksetModel? _fullTaskset;

  AssetRepositoryImpl(this.localDataSource, this.platformDataSource);

  @override
  Future<Either<Failure, Taskset>> loadFullTaskset() async {
    try {
      _fullTaskset = await localDataSource.getFullTaskset();
      if (_fullTaskset == null) {
        return Left(AssetFailure());
      }
      return Right(_fullTaskset!.taskset);
    } catch(_) {
      return Left(AssetFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> loadTask(int i) async {
    if (_fullTaskset == null) {
      return Left(AssetFailure());
    }
    try {
      final task = _fullTaskset!.taskset.tasks[i] as TaskModel;
      await platformDataSource.compileConfiguration(task.getAllRules(_fullTaskset!.getAllPacksMap()));
      return Right(task);
    } on PlatformException {
      return Left(PlatformFailure());
    }  catch(_) {
      return Left(AssetFailure());
    }
  }

  @override
  int? get tasksCount => _fullTaskset?.taskset.tasks.length;
}