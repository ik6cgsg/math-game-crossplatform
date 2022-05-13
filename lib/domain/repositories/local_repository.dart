import 'package:dartz/dartz.dart' hide Task;
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';
import 'package:math_game_crossplatform/domain/entities/task.dart';

import '../../core/failures.dart';

abstract class LocalRepository {
  Future<Either<Failure, void>> saveLevelResult(Result result);
  Future<Either<Failure, List<Result>>> loadAllResults();
  Future<Either<Failure, Result>> loadResultFor(int i);
}