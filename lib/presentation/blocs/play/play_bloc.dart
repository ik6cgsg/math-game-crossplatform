import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/core/logger.dart';
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

  int get levelIndex => _levelIndex;
  String get goalExpression => _goalExpression ?? '';
  String get goalPattern => _goalPattern ?? '';
  String get shortDescription => _shortDescription;

  PlayBloc(this.loadTask, this.selectNode, this.performSubstitution, this.checkEnd): super(Loading()) {
    on<LoadTaskEvent>((event, emit) async {
      emit(Loading());
      log.info('PlayBloc::LoadTaskEvent($event)');
      _levelIndex = event.index;
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
        (task) {
          _goalExpression = task.goalExpressionStructureString;
          _goalPattern = task.goalPattern;
          _shortDescription = task.descriptionShortRu;
          emit(Step(task.originalExpressionStructureString, false, null, null));
        },
      );
    });
    on<NodeSelectedEvent>((event, emit) async {
      log.info('PlayBloc::NodeSelectedEvent($event)');
      if (state is Step) {
        final prevStep = state as Step;
        final res = await selectNode(sn.Params(event.tap, StepState(
            prevStep.currentExpression, prevStep.multiselectMode, prevStep.selectionInfo, prevStep.substitutionInfo
        )));
        log.info('PlayBloc::NodeSelectedEvent: res = $res');
        res.fold(
          (failure) => emit(Error(kErrorNodeSelectFailed)),
          (step) => emit(Step(step.currentExpression, step.multiselectMode, step.selectionInfo, step.substitutionInfo)),
        );
      } else {
        emit(Error(kErrorInternal));
      }
    });
    on<ToggleMultiselectEvent>((event, emit) async {
      log.info('PlayBloc::ToggleMultiselectEvent');
      if (state is Step) {
        final prevStep = state as Step;
        final res = await selectNode(sn.Params(event.tap, StepState(
            prevStep.currentExpression, !prevStep.multiselectMode, null, null
        )));
        log.info('PlayBloc::ToggleMultiselectEvent: res = $res');
        res.fold(
          (failure) => emit(Error(kErrorNodeSelectFailed)),
          (step) => emit(Step(step.currentExpression, step.multiselectMode, step.selectionInfo, step.substitutionInfo)),
        );
      } else {
        emit(Error(kErrorInternal));
      }
    });
    on<RuleSelectedEvent>((event, emit) async {
      log.info('PlayBloc::RuleSelectedEvent');
      if (state is Step) {
        final prevStep = state as Step;
        final res = await performSubstitution(ps.Params(event.index, StepState(
            prevStep.currentExpression, prevStep.multiselectMode, prevStep.selectionInfo, prevStep.substitutionInfo
        )));
        log.info('PlayBloc::RuleSelectedEvent: performSubstitution res = $res');
        await res.fold(
          (failure) async => emit(Error(kErrorSubstitutionFailed)),
          (step) async {
            final end = await checkEnd(ce.Params(levelIndex, step.currentExpression, goalExpression, goalPattern));
            log.info('PlayBloc::RuleSelectedEvent: checkEnd res = $end');
            end.fold(
              (failure) => emit(Error(kErrorSubstitutionFailed)),
              (passedData) {
                if (passedData.passed) {
                  emit(Passed(passedData.hasPrev ?? false, passedData.hasNext ?? false));
                } else {
                  emit(Step(step.currentExpression, step.multiselectMode, step.selectionInfo, step.substitutionInfo));
                }
              }
            );
          }
        );
      } else {
        emit(Error(kErrorInternal));
      }
    });
  }
}