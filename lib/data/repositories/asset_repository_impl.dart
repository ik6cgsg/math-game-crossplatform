import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter/services.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/datasources/asset_data_source.dart';
import 'package:math_game_crossplatform/data/datasources/platform_data_source.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';
import 'package:math_game_crossplatform/domain/entities/task.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';

import '../../core/exceptions.dart';
import '../models/task_model.dart';
import '../models/taskset_model.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetDataSource assetDataSource;
  final PlatformDataSource platformDataSource;

  FullTasksetModel? _fullTaskset;

  AssetRepositoryImpl(this.assetDataSource, this.platformDataSource);

  @override
  Future<Either<Failure, Taskset>> loadFullTaskset() async {
    if (_fullTaskset != null) return Right(_fullTaskset!.taskset);
    try {
      _fullTaskset = await assetDataSource.getFullTaskset();
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