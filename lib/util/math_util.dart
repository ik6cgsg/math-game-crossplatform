import 'package:flutter/services.dart';
import 'package:math_game_crossplatform/util/logger.dart';
import '../json_data_models/rule_data.dart';

const MethodChannel _channel = MethodChannel('mathhelper.games.crossplatform/math_util');

class Point {
  final int x, y;

  Point(this.x, this.y);

  bool isInside(SelectionBox b) => x >= b.lt.x && x <= b.rb.x && y >= b.lt.y && y <= b.rb.y;

  @override
  String toString() => '($x, $y)';
}

class SelectionBox {
  final Point lt, rb;

  SelectionBox(this.lt, this.rb);
}

Future<String> resolveExpression(String expressionStr, bool isStructured, bool isRule) async {
  log.info('resolveExpression($expressionStr, $isStructured)');
  String res = '';
  try {
    res = await _channel.invokeMethod<String>('resolveExpression', <String, dynamic>{
      'expression': expressionStr,
      'structured': isStructured,
      'isRule': isRule
    }) ?? 'failed';
  } on PlatformException {
    log.info('resolveExpression failed with PlatformException');
    res = 'failed';
  }
  return res;
}

class NodeSelectionInfo {
  final String expression;
  final int nodeId;
  final SelectionBox selection;

  NodeSelectionInfo(this.expression, this.nodeId, this.selection);
}

Future<NodeSelectionInfo?> getNodeByTouch(Point tap) async {
  log.info('getNodeByTouch($tap)');
  NodeSelectionInfo? res;
  try {
    var invokeRes = await _channel.invokeMapMethod('getNodeByTouch', <String, dynamic>{
      'coords': [tap.x, tap.y]
    });
    var map = invokeRes?.cast<String, dynamic>();
    if (map != null) {
      var lt = List<int>.from(map['lt']);
      var rb = List<int>.from(map['rb']);
      res = NodeSelectionInfo(
        map['node'],
        map['id'] as int,
        SelectionBox(Point(lt[0], lt[1]), Point(rb[0], rb[1])),
      );
    }
  } on PlatformException {
    log.info('getNodeByTouch failed with PlatformException');
    res = null;
  }
  return res;
}

class SubstitutionInfo {
  final List<String> rules;
  final List<String> results;

  SubstitutionInfo(this.rules, this.results);
}

Future<SubstitutionInfo?> getSubstitutionInfo(List<int> nodeIds) async {
  log.info('getSubstitutionInfo($nodeIds)');
  SubstitutionInfo? res;
  try {
    var invokeRes = await _channel.invokeMapMethod('getSubstitutionInfo', <String, dynamic>{
      'ids': nodeIds
    });
    var map = invokeRes?.cast<String, dynamic>();
    if (map != null) {
      res = SubstitutionInfo(
        List<String>.from(map['rules']),
        List<String>.from(map['results'])
      );
    }
  } on PlatformException {
    log.info('getSubstitutionInfo failed with PlatformException');
    res = null;
  }
  return res;
}

Future<bool> compileConfiguration(Set<Rule> rules) async {
  log.info('compileConfiguration(); size == ${rules.length}');
  bool res = false;
  try {
    await _channel.invokeMethod('compileConfiguration', <String, dynamic>{
      'rules': rules.map((e) => e.toJson()).toList()
    });
    res = true;
  } on PlatformException {
    log.info('compileConfiguration failed with PlatformException');
    res = false;
  }
  return res;
}

Future<bool> checkEnd(String expression, String goal, String pattern) async {
  log.info('checkEnd($expression)');
  bool res = false;
  try {
    res = await _channel.invokeMethod<bool>('checkEnd', <String, dynamic>{
      'expression': expression,
      'goal': goal,
      'pattern': pattern
    }) ?? false;
  } on PlatformException {
    log.info('checkEnd failed with PlatformException');
    res = false;
  }
  return res;
}