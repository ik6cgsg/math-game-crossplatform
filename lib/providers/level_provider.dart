import 'package:flutter/foundation.dart';

import '../json_data_models/rule_data.dart';
import '../json_data_models/task_data.dart';
import '../util/math_util.dart' as mu;

// todo: history
class Step {
  String _currentExpression = '';
  Set<mu.NodeSelectionInfo>? _selectionInfo;
  mu.SubstitutionInfo? _substitutionInfo;
  bool _multiselection = false;
}

class LevelProvider with ChangeNotifier {
  Task? _task;
  bool _loaded = false;
  bool _passed = false;
  bool _loadStarted = false;
  String _currentExpression = '';
  Set<mu.NodeSelectionInfo>? _selectionInfo;
  mu.SubstitutionInfo? _substitutionInfo;
  bool _multiselection = false;

  /// State data

  bool get loaded {
    return _loaded;
  }

  bool get passed {
    return _passed;
  }

  List<mu.SelectionBox>? get selectedNodes {
    var res = _selectionInfo?.map((e) => e.selection).toList();
    if (res?.isEmpty == true) return null;
    return res;
  }

  List<String>? get substitutionRules {
    if (_substitutionInfo?.rules.isEmpty == true) return null;
    return _substitutionInfo?.rules;
  }

  String get currentExpression {
    return _currentExpression;
  }

  bool get multiselectionModeOn {
    return _multiselection;
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

  void clearSelection() {
    _clearSelection();
    notifyListeners();
  }

  void _clearSelection() {
    _selectionInfo = null;
    _substitutionInfo = null;
  }

  void unload() {
    _task = null;
    _loaded = false;
    _passed = false;
    _loadStarted = false;
    _currentExpression = '';
    _multiselection = false;
    _clearSelection();
    notifyListeners();
  }

  Future<void> _getNodeByTouch(mu.Point current) async {
    var value = await mu.getNodeByTouch(current);
    if (value != null) {
      var alreadyHave = _selectionInfo?.any((e) => e.nodeId == value.nodeId);
      if (alreadyHave == true) {
        _selectionInfo?.removeWhere((e) => e.nodeId == value.nodeId);
        if (_selectionInfo?.isEmpty == true) {
          _clearSelection();
        }
      } else if (_multiselection) {
        _selectionInfo ??= {};
        _selectionInfo?.add(value);
      } else {
        _selectionInfo = {value};
      }
    } else {
      _clearSelection();
    }
  }

  Future<void> _getSubstitutionInfo() async {
    if (_selectionInfo == null || _selectionInfo!.isEmpty) return;
    _substitutionInfo = await mu.getSubstitutionInfo(_selectionInfo!.map((e) => e.nodeId).toList());
  }

  void selectNode(mu.Point current) {
    _getNodeByTouch(current).then((_) {
      _getSubstitutionInfo().then((_) {
        notifyListeners();
      });
    });
  }

  void selectRule(int i) {
    if (_substitutionInfo == null) return;
    _currentExpression = _substitutionInfo!.results[i];
    mu.checkEnd(_currentExpression, _task!.goalExpressionStructureString ?? '', _task!.goalPattern ?? '').then((passed) {
      _passed = passed;
      clearSelection();
      notifyListeners();
    });
  }

  void toggleMultiselection(mu.Point point) {
    _selectionInfo = {};
    _multiselection = !_multiselection;
    selectNode(point);
  }
}