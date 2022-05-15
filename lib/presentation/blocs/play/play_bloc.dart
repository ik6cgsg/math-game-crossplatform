import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/entities/step_state.dart';
import 'package:math_game_crossplatform/domain/usecases/check_end.dart' as ce;
import 'package:math_game_crossplatform/domain/usecases/load_task.dart' as lt;
import 'package:math_game_crossplatform/domain/usecases/perform_substitution.dart' as ps;
import 'package:math_game_crossplatform/domain/usecases/select_node.dart' as sn;
import 'package:math_game_crossplatform/domain/usecases/undo_step.dart' as us;

import 'play_event.dart';
import 'play_state.dart';

const String kErrorTaskNotFound = 'Уровень не найден';
const String kErrorTaskNotLoad = 'Ошибка загрузки уровня';
const String kErrorNodeSelectFailed = 'Не удалось выбрать указанный узел';
const String kErrorSubstitutionFailed = 'Не удалось выполнить преобразование';
const String kErrorInternal = 'Что то пошло не так, попробуй еще раз';

class PlayBloc extends Bloc<PlayEvent, PlayState> {
  final lt.LoadTask loadTask;
  final sn.SelectNode selectNode;
  final ps.PerformSubstitution performSubstitution;
  final ce.CheckEnd checkEnd;
  final us.UndoStep undoStep;

  late int _levelIndex;
  late String _levelCode;
  late String? _goalExpression, _goalPattern;
  late String _shortDescription, _startExpression;
  List<Step> _history = [];

  int get levelIndex => _levelIndex;
  String get levelCode => _levelCode;
  String get goalExpression => _goalExpression ?? '';
  String get goalPattern => _goalPattern ?? '';
  String get shortDescription => _shortDescription;
  bool get canUndo => _history.length > 1;

  PlayBloc(this.loadTask, this.selectNode, this.performSubstitution, this.checkEnd, this.undoStep): super(Loading()) {
    on<LoadTaskEvent>(_handleLoadTaskEvent);
    on<RestartEvent>(_handleRestartEvent);
    on<NodeSelectedEvent>(_handleNodeSelectedEvent);
    on<ToggleMultiselectEvent>(_handleToggleMultiselectEvent);
    on<RuleSelectedEvent>(_handleRuleSelectedEvent);
    on<UndoEvent>(_handleUndoEvent);
  }

  void _emitStep(Emitter emit, Step step) {
    _history.add(step);
    emit(step);
  }

  void _handleLoadTaskEvent(LoadTaskEvent event, Emitter emit) async {
    emit(Loading());
    log.info('PlayBloc::LoadTaskEvent($event)');
    _levelIndex = event.index;
    _history = [];
    final res = await loadTask(lt.Params(event.index));
    log.info('PlayBloc::LoadTaskEvent: res = $res');
    await res.fold(
      (failure) {
        if (failure is AssetFailure) {
          emit(Error(kErrorTaskNotFound));
        }
        if (failure is PlatformFailure) {
          emit(Error(kErrorTaskNotLoad));
        }
      },
      (data) async {
        _levelCode = data.task.code;
        _goalExpression = data.task.goalExpressionStructureString;
        _goalPattern = data.task.goalPattern;
        _shortDescription = data.task.descriptionShortRu;
        _startExpression = data.task.originalExpressionStructureString;
        var step = Step(StepState(data.task.originalExpressionStructureString, false, null, null, 0));
        log.info('PlayBloc::LoadTaskEvent: result = ${data.result}');
        if (data.result == null) {
          _emitStep(emit, step);
        } else {
          if (data.result!.state == LevelState.passed) {
            final end = await checkEnd(ce.Params(levelIndex, levelCode, '', '', '', 0, ignoreCheck: true));
            end.fold(
              (failure) => emit(Error(kErrorSubstitutionFailed)),
              (passedData) => emit(Passed(passedData.hasPrev ?? false, passedData.hasNext ?? false))
            );
          } else {
            _emitStep(emit, Step(StepState(data.result!.expression, false, null, null, data.result!.stepCount)));
          }
        }
      },
    );
  }

  void _handleRestartEvent(RestartEvent event, Emitter emit) async {
    emit(Loading());
    log.info('PlayBloc::RestartEvent($event)');
    _history = [];
    _emitStep(emit, Step(StepState(_startExpression, false, null, null, 0)));
  }

  void _handleNodeSelectedEvent(NodeSelectedEvent event, Emitter emit) async {
    log.info('PlayBloc::NodeSelectedEvent($event)');
    if (state is Step) {
      final prevStep = state as Step;
      final res = await selectNode(sn.Params(event.tap, prevStep.state));
      log.info('PlayBloc::NodeSelectedEvent: res = $res');
      res.fold(
        (failure) => emit(Error(kErrorNodeSelectFailed)),
        (state) => _emitStep(emit, Step(state)),
      );
    } else {
      emit(Error(kErrorInternal));
    }
  }

  void _handleToggleMultiselectEvent(ToggleMultiselectEvent event, Emitter emit) async {
    log.info('PlayBloc::ToggleMultiselectEvent');
    if (state is Step) {
      final prevStep = state as Step;
      final res = await selectNode(sn.Params(event.tap, StepState(
        prevStep.state.currentExpression, !prevStep.state.multiselectMode, null, null, prevStep.state.stepCount)
      ));
      log.info('PlayBloc::ToggleMultiselectEvent: res = $res');
      res.fold(
        (failure) => emit(Error(kErrorNodeSelectFailed)),
        (state) => _emitStep(emit, Step(state)),
      );
    } else {
      emit(Error(kErrorInternal));
    }
  }

  void _handleRuleSelectedEvent(RuleSelectedEvent event, Emitter emit) async {
    log.info('PlayBloc::RuleSelectedEvent');
    if (state is Step) {
      final prevStep = state as Step;
      final res = await performSubstitution(ps.Params(levelIndex, event.index, prevStep.state));
      log.info('PlayBloc::RuleSelectedEvent: performSubstitution res = $res');
      await res.fold(
        (failure) async => emit(Error(kErrorSubstitutionFailed)),
        (state) async {
          final end = await checkEnd(ce.Params(levelIndex, levelCode, state.currentExpression, goalExpression, goalPattern, state.stepCount));
          log.info('PlayBloc::RuleSelectedEvent: checkEnd res = $end');
          end.fold(
            (failure) => emit(Error(kErrorSubstitutionFailed)),
            (passedData) {
              if (passedData.passed) {
                emit(Passed(passedData.hasPrev ?? false, passedData.hasNext ?? false));
              } else {
                _emitStep(emit, Step(state));
              }
            }
          );
        }
      );
    } else {
      emit(Error(kErrorInternal));
    }
  }

  void _handleUndoEvent(UndoEvent event, Emitter emit) async {
    log.info('PlayBloc::UndoEvent');
    final res = await undoStep(us.Params(levelIndex, _history));
    res.fold(
      (fail) {},
      (history) {
        _history = history;
        emit(_history.last);
      }
    );
  }
}