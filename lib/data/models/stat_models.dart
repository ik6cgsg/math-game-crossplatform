import 'package:equatable/equatable.dart';

class StatisticAction extends Equatable {
  final String name;

  const StatisticAction(this.name);
  
  @override
  List<Object?> get props => [name];
  Map<String, Object?>? toMap() => null;
}

class StatisticActionScreenOpen extends StatisticAction {
  final String screenClass;

  const StatisticActionScreenOpen(this.screenClass) : super('screen_view');

  @override
  List<Object?> get props => [name, screenClass];

  @override
  Map<String, Object?>? toMap() => <String, Object?>{
    'screen_class': screenClass,
  };
}

class StatisticActionScreenClose extends StatisticAction {
  final String screenClass;

  const StatisticActionScreenClose(this.screenClass) : super('screen_close');

  @override
  List<Object?> get props => [name, screenClass];

  @override
  Map<String, Object?>? toMap() => <String, Object?>{
    'screen_class': screenClass,
  };
}

class StatisticActionLevelStart extends StatisticAction {
  final String code;
  final int index;

  const StatisticActionLevelStart(this.code, this.index) : super('level_start');

  @override
  List<Object?> get props => [name, code, index];

  @override
  Map<String, Object?>? toMap() => <String, Object?>{
    'level_name': code,
    'level_index': index,
  };
}

class StatisticActionSelectNode extends StatisticAction {
  final int nodeCount;
  final int ruleCount;
  final bool multiselection;

  const StatisticActionSelectNode(this.nodeCount, this.ruleCount, this.multiselection)
      : super('select_node');

  @override
  List<Object?> get props => [name, nodeCount, ruleCount, multiselection];

  @override
  Map<String, Object?>? toMap() => <String, Object?>{
    'node_count': nodeCount,
    'rule_count': ruleCount,
    'multiselection': multiselection,
  };
}

class StatisticActionSelectRule extends StatisticAction {
  final int index;
  final int stepCount;

  const StatisticActionSelectRule(this.index, this.stepCount)
      : super('select_rule');

  @override
  List<Object?> get props => [name, index, stepCount];

  @override
  Map<String, Object?>? toMap() => <String, Object?>{
    'index': index,
    'step_count': stepCount
  };
}

class StatisticActionUndo extends StatisticAction {
  final int nodeCount;
  final int ruleCount;
  final bool multiselection;
  final int stepCount;

  const StatisticActionUndo(this.nodeCount, this.ruleCount, this.multiselection, this.stepCount)
      : super('undo');

  @override
  List<Object?> get props => [name, nodeCount, ruleCount, multiselection, stepCount];

  @override
  Map<String, Object?>? toMap() => <String, Object?>{
    'node_count': nodeCount,
    'rule_count': ruleCount,
    'multiselection': multiselection,
    'step_count': stepCount,
  };
}

class StatisticActionRestart extends StatisticAction {
  final String code;
  final int index;

  const StatisticActionRestart(this.code, this.index) : super('level_restart');

  @override
  List<Object?> get props => [name, code, index];

  @override
  Map<String, Object?>? toMap() => <String, Object?>{
    'level_name': code,
    'level_index': index,
  };
}

class StatisticActionLevelEnd extends StatisticAction {
  final String code;
  final bool success;
  final int stepCount;

  const StatisticActionLevelEnd(this.code, this.success, this.stepCount) : super('level_end');

  @override
  List<Object?> get props => [name, code, success, stepCount];

  @override
  Map<String, Object?>? toMap() => <String, Object?>{
    'level_name': code,
    'success': success,
    'step_count': stepCount,
  };
}

class StatisticActionLevelRate extends StatisticAction {
  final String code;
  final int rate;

  const StatisticActionLevelRate(this.code, this.rate) : super('level_rate');

  @override
  List<Object?> get props => [name, code, rate];

  @override
  Map<String, Object?>? toMap() => <String, Object?>{
    'level_name': code,
    'rate': rate,
  };
}