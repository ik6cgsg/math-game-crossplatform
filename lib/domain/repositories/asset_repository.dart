import 'package:dartz/dartz.dart' hide Task;
import 'package:math_game_crossplatform/domain/entities/taskset.dart';
import 'package:math_game_crossplatform/domain/entities/task.dart';

import '../../core/failures.dart';

abstract class AssetRepository {
  Future<Either<Failure, Taskset>> loadFullTaskset();
  Future<Either<Failure, Task>> loadTask(int i);
  int? get tasksCount;
}