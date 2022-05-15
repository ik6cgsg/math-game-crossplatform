import 'package:dartz/dartz.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/data/datasources/remote_data_source.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';
import 'package:math_game_crossplatform/domain/repositories/remote_repository.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final RemoteDataSource remoteDataSource;

  RemoteRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> logEvent(StatisticAction action) async {
    try {
      return Right(await remoteDataSource.logEvent(action));
    } catch(_) {
      log.info('RemoteRepositoryImpl: failed to send event $action');
      return Left(RemoteFailure());
    }
  }
}