import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/entities/step_state.dart';
import 'package:math_game_crossplatform/domain/usecases/check_end.dart' as ce;
import 'package:math_game_crossplatform/domain/usecases/load_task.dart' as lt;
import 'package:math_game_crossplatform/domain/usecases/perform_substitution.dart' as ps;
import 'package:math_game_crossplatform/domain/usecases/select_node.dart' as sn;

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

  late int _levelIndex;
  late String? _goalExpression, _goalPattern;
  late String _shortDescription;
  List<Step> _history = [];

  int get levelIndex => _levelIndex;
  String get goalExpression => _goalExpression ?? '';
  String get goalPattern => _goalPattern ?? '';
  String get shortDescription => _shortDescription;
  bool get canUndo => _history.length > 1;

  PlayBloc(this.loadTask, this.selectNode, this.performSubstitution, this.checkEnd): super(Loading()) {
    on<LoadTaskEvent>(_handleLoadTaskEvent);
    on<NodeSelectedEvent>(_handleNodeSelectedEvent);
    on<ToggleMultiselectEvent>(_handleToggleMultiselectEvent);
    on<RuleSelectedEvent>(_handleRuleSelectedEvent);
    on<UndoEvent>(_handleUndoEvent);
  }

  void _emitStep(Emitter emit, Step step) {
    // todo save to db
    // todo log step
    _history.add(step);
    emit(step);
  }

  void _handleLoadTaskEvent(LoadTaskEvent event, Emitter emit) async {
    emit(Loading());
    // todo log start
    log.info('PlayBloc::LoadTaskEvent($event)');
    _levelIndex = event.index;
    _history = [];
    final res = await loadTask(lt.Params(event.index));
    log.info('PlayBloc::LoadTaskEvent: res = $res');
    res.fold(
      (failure) {
        if (failure is AssetFailure) {
          emit(Error(kErrorTaskNotFound));
        }
        if (failure is PlatformFailure) {
          emit(Error(kErrorTaskNotLoad));
        }
      },
      (data) {
        _goalExpression = data.task.goalExpressionStructureString;
        _goalPattern = data.task.goalPattern;
        _shortDescription = data.task.descriptionShortRu;
        var step = Step(StepState(data.task.originalExpressionStructureString, false, null, null, 0));
        if (data.result != null) {
          step = Step(StepState(data.result!.expression, false, null, null, data.result!.stepCount));
        }
        _emitStep(emit, step);
      },
    );
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
      final res = await performSubstitution(ps.Params(event.index, prevStep.state));
      log.info('PlayBloc::RuleSelectedEvent: performSubstitution res = $res');
      await res.fold(
        (failure) async => emit(Error(kErrorSubstitutionFailed)),
        (state) async {
          final end = await checkEnd(ce.Params(levelIndex, state.currentExpression, goalExpression, goalPattern));
          log.info('PlayBloc::RuleSelectedEvent: checkEnd res = $end');
          end.fold(
            (failure) => emit(Error(kErrorSubstitutionFailed)),
            (passedData) {
              if (passedData.passed) {
                emit(Passed(passedData.hasPrev ?? false, passedData.hasNext ?? false));
                // todo move to usecase: saveLevelResult(Result(_levelIndex, state.currentExpression, state.stepCount, LevelState.passed));
                //todo log passed
              } else {
                _emitStep(emit, Step(state));
                //todo mode to usecase: saveLevelResult(Result(_levelIndex, state.currentExpression, state.stepCount, LevelState.paused));
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
    if (canUndo) {
      // todo remove from db
      // todo log undo
      final old = _history.removeLast();
      if (_history.last.state.stepCount != old.state.stepCount) {
        saveLevelResult(Result(_levelIndex, _history.last.state.currentExpression, _history.last.state.stepCount, LevelState.paused));
      }
      emit(_history.last);
    }
  }
}