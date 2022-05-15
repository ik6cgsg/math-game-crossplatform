import 'package:dartz/dartz.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/domain/entities/stat_entities.dart';

abstract class RemoteRepository {
  Future<Either<Failure, void>> logEvent(ActionInfo action, GeneralInfo general);
}