import 'package:equatable/equatable.dart';

enum ActionType {
  startLevel, selectNode, selectRule, undo, restart, finishLevel, rate
}

class ActionInfo extends Equatable {
  final ActionType type;
  final String? currExpression;
  final String? appliedRule;
  final String? selectedPlaces;
  final String? otherData;
  final int? stepCount;
  final int? rate;
  final bool? multiselection;
  final bool? passed;

  const ActionInfo(this.type, this.currExpression, this.appliedRule, this.selectedPlaces, this.otherData, this.stepCount, this.rate, this.multiselection, this.passed);

  @override
  List<Object?> get props => [type, currExpression, appliedRule, selectedPlaces, otherData, stepCount, rate, multiselection, passed];
}

class GeneralInfo extends Equatable {
  final String tasksetCode;
  final int tasksetVersion;
  final String taskCode;
  final int taskVersion;
  final String originalExpression;
  final String goalExpression;
  final String goalPattern;
  final double difficulty;

  const GeneralInfo(this.tasksetCode, this.tasksetVersion, this.taskCode, this.taskVersion, this.originalExpression, this.goalExpression, this.goalPattern, this.difficulty);

  @override
  List<Object?> get props => [tasksetCode, tasksetVersion, taskCode, taskVersion, originalExpression, goalExpression, goalPattern, difficulty];
}