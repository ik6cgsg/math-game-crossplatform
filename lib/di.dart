import 'package:get_it/get_it.dart';
import 'package:math_game_crossplatform/data/datasources/asset_data_source.dart';
import 'package:math_game_crossplatform/data/datasources/local_data_source.dart';
import 'package:math_game_crossplatform/data/datasources/platform_data_source.dart';
import 'package:math_game_crossplatform/data/datasources/remote_data_source.dart';
import 'package:math_game_crossplatform/data/repositories/asset_repository_impl.dart';
import 'package:math_game_crossplatform/data/repositories/local_repository_impl.dart';
import 'package:math_game_crossplatform/data/repositories/platform_repository_impl.dart';
import 'package:math_game_crossplatform/data/repositories/remote_repository_impl.dart';
import 'package:math_game_crossplatform/domain/repositories/asset_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/local_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/platform_repository.dart';
import 'package:math_game_crossplatform/domain/repositories/remote_repository.dart';
import 'package:math_game_crossplatform/domain/usecases/check_end.dart';
import 'package:math_game_crossplatform/domain/usecases/get_passed_data.dart';
import 'package:math_game_crossplatform/domain/usecases/load_task.dart';
import 'package:math_game_crossplatform/domain/usecases/load_taskset.dart';
import 'package:math_game_crossplatform/domain/usecases/perform_substitution.dart';
import 'package:math_game_crossplatform/domain/usecases/resolve_expression.dart';
import 'package:math_game_crossplatform/domain/usecases/select_node.dart';
import 'package:math_game_crossplatform/domain/usecases/undo_step.dart';
import 'package:math_game_crossplatform/presentation/blocs/game/game_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_bloc.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Blocs
  di.registerFactory(() => GameBloc(di()),);
  di.registerFactory(() => PlayBloc(di(), di(), di(), di(), di(), di()),);
  di.registerFactory(() => ResolverBloc(di()),);

  // Use cases
  di.registerLazySingleton(() => LoadTaskset(di(), di(), di(),));
  di.registerLazySingleton(() => LoadTask(di(), di(), di(),));
  di.registerLazySingleton(() => ResolveExpression(di(),));
  di.registerLazySingleton(() => SelectNode(di(), di(),));
  di.registerLazySingleton(() => PerformSubstitution(di(), di(),));
  di.registerLazySingleton(() => CheckEnd(di(), di(),));
  di.registerLazySingleton(() => UndoStep(di(), di(),));
  di.registerLazySingleton(() => GetPassedData(di(), di()));

  // Repository
  di.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(di(), di(),),
  );
  di.registerLazySingleton<PlatformRepository>(
    () => PlatformRepositoryImpl(di(),),
  );
  di.registerLazySingleton<LocalRepository>(
    () => LocalRepositoryImpl(di(),),
  );
  di.registerLazySingleton<RemoteRepository>(
    () => RemoteRepositoryImpl(di(),),
  );

  // Data sources
  di.registerLazySingleton<AssetDataSource>(
    () => AssetDataSourceImpl(),
  );
  di.registerLazySingleton<PlatformDataSource>(
    () => PlatformDataSourceImpl(),
  );
  di.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(),
  );
  di.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceFirebase(),
  );
}