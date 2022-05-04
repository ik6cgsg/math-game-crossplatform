import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:math_game_crossplatform/json_data_models/rule_data.dart';

import '../json_data_models/taskset_data.dart';

class GameProvider with ChangeNotifier {
  Taskset? _taskset;
  List<RulePackage>? _allRulePacks;
  bool _loaded = false;
  bool _loadStarted = false;
  int _currentLevel = 0;

  bool get loaded {
    return _loaded;
  }

  Taskset? get taskset {
    return _taskset;
  }

  List<RulePackage>? get allRulePacks {
    return _allRulePacks;
  }

  int get currentLevel {
    return _currentLevel;
  }

  void load(BuildContext ctx) {
    if (_loadStarted) return;
    _loadStarted = true;
    DefaultAssetBundle.of(ctx).loadString("assets/games/global__CheckYourselfTrigonometry.json").then((value) {
      Map<String, dynamic> json = jsonDecode(value);
      var full = FullTaskset.fromJson(json);
      _taskset = full.taskset;
      _allRulePacks = full.rulePacks;
      _loaded = true;
      notifyListeners();
    });
  }
}