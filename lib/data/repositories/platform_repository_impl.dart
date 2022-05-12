import 'package:dartz/dartz.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/models/platform_models.dart';
import 'package:math_game_crossplatform/domain/entities/platform_entities.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';

import '../datasources/platform_data_source.dart';

class PlatformRepositoryImpl implements PlatformRepository {
  final PlatformDataSource platformDataSource;

  PlatformRepositoryImpl(this.platformDataSource);

  @override
  Future<Either<Failure, String>> resolveExpression(ResolutionInput input) async {
    try {
      return Right(await platformDataSource.resolveExpression(ResolutionInputModel.fromEntity(input)));
    } catch(_) {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, NodeSelectionInfo>> getNodeByTouch(Point tap) async {
    try {
      return Right(await platformDataSource.getNodeByTouch(PointModel.fromEntity(tap)));
    } catch(_) {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, SubstitutionInfo>> getSubstitutionInfo(List<int> nodeIds) async {
    try {
      return Right(await platformDataSource.getSubstitutionInfo(nodeIds));
    } catch(_) {
      return Left(PlatformFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkEnd(CheckEndInput input) async {
    try {
      return Right(await platformDataSource.checkEnd(CheckEndInputModel.fromEntity(input)));
    } catch(_) {
      return Left(PlatformFailure());
    }
  }
}