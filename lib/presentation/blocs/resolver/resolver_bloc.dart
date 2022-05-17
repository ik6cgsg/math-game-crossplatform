import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/data/models/platform_models.dart';
import 'package:math_game_crossplatform/domain/usecases/resolve_expression.dart';

import 'resolver_event.dart';
import 'resolver_state.dart';

const String kErrorResolveFailed = 'Ошибка вывода формулы';

class ResolverBloc extends Bloc<ResolverEvent, ResolverState> {
  final ResolveExpression resolveExpression;

  ResolverBloc(this.resolveExpression): super(Resolving()) {
    on<Resolve>((event, emit) async {
      emit(Resolving());
      log.info('ResolverBloc::Resolve');
      final res = await resolveExpression(event.input);
      log.info('ResolverBloc::Resolve: res = $res');
      res.fold(
        (failure) => emit(Error(kErrorResolveFailed + '\n(${event.input.expressionStr})')),
        (expression) => emit(Resolved(expression)),
      );
    });
  }
}