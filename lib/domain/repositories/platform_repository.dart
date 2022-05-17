import 'package:dartz/dartz.dart';
import 'package:math_game_crossplatform/data/models/platform_models.dart';

import '../entities/platform_entities.dart';
import '../../core/failures.dart';

abstract class PlatformRepository {
  Future<Either<Failure, String>> resolveExpression(ResolutionInput input);
  Future<Either<Failure, NodeSelectionInfo>> getNodeByTouch(Point tap);
  Future<Either<Failure, SubstitutionInfo>> getSubstitutionInfo(List<int> nodeIds);
  Future<Either<Failure, bool>> checkEnd(CheckEndInput input);
}