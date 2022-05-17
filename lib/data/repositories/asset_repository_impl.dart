import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter/services.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/data/datasources/asset_data_source.dart';
import 'package:math_game_crossplatform/data/datasources/platform_data_source.dart';
import 'package:math_game_crossplatform/data/models/platform_models.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';
import 'package:math_game_crossplatform/domain/entities/task.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';

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
    } catch(e) {
      log.info('AssetRepositoryImpl: loadFullTaskset failed with $e');
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
      await platformDataSource.compileConfiguration(CompileInput(
        task.getAllRules(_fullTaskset!.getAllPacksMap()),
        task.otherCheckSolutionData as Map<String, String>? ?? {}
      ));
      return Right(task);
    } on PlatformException {
      log.info('AssetRepositoryImpl: loadTask failed to platform compile level');
      return Left(PlatformFailure());
    } catch(e) {
      log.info('AssetRepositoryImpl: loadTask failed with $e');
      return Left(AssetFailure());
    }
  }

  @override
  Either<Failure, TaskInfo> getTaskInfo(int i) {
    if (_fullTaskset == null) {
      return Left(AssetFailure());
    }
    try {
      final task = _fullTaskset!.taskset.tasks[i];
      return Right(TaskInfo(task.namespaceCode, task.code, task.version));
    } catch(_) {
      return Left(AssetFailure());
    }
  }

  @override
  int? get tasksCount => _fullTaskset?.taskset.tasks.length;
}