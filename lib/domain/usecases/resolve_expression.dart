import 'package:dartz/dartz.dart' hide Task;
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/models/platform_models.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';

import '../../core/usecase.dart';

class ResolveExpression implements UseCase<String, ResolutionInput> {
  final PlatformRepository repository;

  ResolveExpression(this.repository);

  @override
  Future<Either<Failure, String>> call(ResolutionInput params) async {
    return await repository.resolveExpression(params);
  }
}