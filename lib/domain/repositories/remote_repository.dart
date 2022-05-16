import 'package:dartz/dartz.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';

abstract class RemoteRepository {
  Future<Either<Failure, void>> logEvent(StatisticAction action);
}