import 'package:flutter/foundation.dart';

import '../json_data_models/rule_data.dart';
import '../json_data_models/task_data.dart';
import '../util/math_util.dart' as mu;

class LevelProvider with ChangeNotifier {
  Task? _task;
  mu.NodeSelectionInfo? _info;
  bool _loaded = false;
  bool _passed = false;
  bool _loadStarted = false;
  String _currentExpression = '';

  /// State data

  bool get loaded {
    return _loaded;
  }

  bool get passed {
    return _passed;
  }

  mu.NodeSelectionInfo? get selectionInfo {
    return _info;
  }

  String get currentExpression {
    return _currentExpression;
  }

  /// Level data

  String get name {
    // todo: switch lang
    return _task?.nameRu ?? '';
  }

  String get shortDescription {
    // todo: switch lang
    return _task?.descriptionShortRu ?? '';
  }

  String get goalExpression {
    return _task?.goalExpressionStructureString ?? '';
  }

  Future<void> _loadLevelAsync(List<RulePackage> allPacks) async {
    Map<String, RulePackage> allPacksMap = {};
    for (var e in allPacks) {
      allPacksMap[e.code] = e;
    }
    var allRules = {...?_task?.rules};
    _task?.rulePacks?.forEach((element) {
      var packRules = allPacksMap[element.rulePackCode]?.getAllRules(allPacksMap);
      allRules = {...allRules, ...?packRules};
    });
    _loaded = await mu.compileConfiguration(allRules);
  }

  void load(Task task, List<RulePackage> allPacks) {
    if (_loadStarted) return;
    _loadStarted = true;
    _task = task;
    _currentExpression = _task!.originalExpressionStructureString;
    _loadLevelAsync(allPacks).then((_) {
      notifyListeners();
    });
  }

  void unload() {
    _task = null;
    _info = null;
    _loaded = false;
    _passed = false;
    _loadStarted = false;
    _currentExpression = '';
    notifyListeners();
  }

  void selectNode(mu.Point current) {
    mu.getNodeByTouch(current).then((value) {
      _info = value;
      notifyListeners();
    });
  }

  void selectRule(int i) {
    mu.performSubstitution(i).then((value) {
      _currentExpression = value;
      mu.checkEnd(_currentExpression, _task!.goalExpressionStructureString ?? '', _task!.goalPattern ?? '').then((passed) {
        _passed = passed;
        _info = null;
        notifyListeners();
      });
    });
  }
}