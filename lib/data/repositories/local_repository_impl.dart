import 'package:dartz/dartz.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/datasources/local_data_source.dart';
import 'package:math_game_crossplatform/data/models/result_model.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/repositories/local_repository.dart';

class LocalRepositoryImpl implements LocalRepository {
  final LocalDataSource localDataSource;

  LocalRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> saveLevelResult(Result result) async {
    try {
      return Right(await localDataSource.saveLevelResult(ResultModel.fromEntity(result)));
    } catch(_) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, List<Result>>> loadAllResults() async {
    try {
      return Right(await localDataSource.loadAllResults());
    } catch(_) {
      return Left(LocalStorageFailure());
    }
  }

  @override
  Future<Either<Failure, Result>> loadResultFor(String code) async {
    try {
      return Right(await localDataSource.loadResultFor(code));
    } catch(_) {
      return Left(LocalStorageFailure());
    }
  }
}