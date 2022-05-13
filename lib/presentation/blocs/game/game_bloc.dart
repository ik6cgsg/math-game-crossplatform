import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/core/usecase.dart';
import 'package:math_game_crossplatform/domain/usecases/load_taskset.dart';

import 'game_event.dart';
import 'game_state.dart';

const String kErrorLoadTaskset = 'Ошибка загрузка игры';

class GameBloc extends Bloc<GameEvent, GameState> {
  final LoadTaskset loadFullTaskset;

  GameBloc(this.loadFullTaskset): super(Loading()) {
    on<LoadTasksetEvent>((_, emit) async {
      emit(Loading());
      log.info('GameBloc::LoadTasksetEvent');
      final res = await loadFullTaskset(NoParams());
      log.info('GameBloc::LoadTasksetEvent: res = $res');
      res.fold(
        (failure) => emit(Error(kErrorLoadTaskset)),
        (res) => emit(Loaded(res.taskset, res.results)),
      );
    });
  }
}