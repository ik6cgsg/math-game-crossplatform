import 'package:get_it/get_it.dart';
import 'package:math_game_crossplatform/data/datasources/local_data_source.dart';
import 'package:math_game_crossplatform/data/datasources/platform_data_source.dart';
import 'package:math_game_crossplatform/data/repositories/asset_repository_impl.dart';
import 'package:math_game_crossplatform/data/repositories/platform_repository_impl.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';
import 'package:math_game_crossplatform/domain/usecases/check_end.dart';
import 'package:math_game_crossplatform/domain/usecases/load_task.dart';
import 'package:math_game_crossplatform/domain/usecases/load_taskset.dart';
import 'package:math_game_crossplatform/domain/usecases/perform_substitution.dart';
import 'package:math_game_crossplatform/domain/usecases/resolve_expression.dart';
import 'package:math_game_crossplatform/domain/usecases/select_node.dart';
import 'package:math_game_crossplatform/presentation/blocs/game/game_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_bloc.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Blocs
  di.registerFactory(() => GameBloc(di()),);
  di.registerFactory(() => PlayBloc(di(), di(), di(), di()),);
  di.registerFactory(() => ResolverBloc(di()),);

  // Use cases
  di.registerLazySingleton(() => LoadTaskset(di()));
  di.registerLazySingleton(() => LoadTask(di()));
  di.registerLazySingleton(() => ResolveExpression(di()));
  di.registerLazySingleton(() => SelectNode(di()));
  di.registerLazySingleton(() => PerformSubstitution(di()));
  di.registerLazySingleton(() => CheckEnd(di(), di()));

  // Repository
  di.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(di(), di()),
  );
  di.registerLazySingleton<PlatformRepository>(
    () => PlatformRepositoryImpl(di(),),
  );

  // Data sources
  di.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(),
  );
  di.registerLazySingleton<PlatformDataSource>(
    () => PlatformDataSourceImpl(),
  );
}