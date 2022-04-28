import 'package:flutter/services.dart';
import 'package:math_game_crossplatform/logger.dart';
import 'json_data_models/rule_data.dart';

const MethodChannel _channel = MethodChannel('mathhelper.games.crossplatform/math_util');

class Point {
  final int x, y;

  Point(this.x, this.y);

  bool isInside(Point lt, Point rb) => x >= lt.x && x <= rb.x && y >= lt.y && y <= rb.y;

  @override
  String toString() => '($x, $y)';
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
  final Point lt, rb;
  final List<String> results;

  NodeSelectionInfo(this.expression, this.lt, this.rb, this.results);
}

Future<NodeSelectionInfo?> getNodeByTouch(Point tap) async {
  log.info('getNodeByTouch($tap)');
  NodeSelectionInfo? res;
  try {
    var invokeRes = await _channel.invokeMapMethod('getNodeByTouch', <String, dynamic>{
      "coords": [tap.x, tap.y]
    });
    var map = invokeRes?.cast<String, dynamic>();
    if (map != null) {
      var lt = List<int>.from(map["lt"]);
      var rb = List<int>.from(map["rb"]);
      var results = List<String>.from(map["results"]);
      log.info('getNodeByTouch results = $results');
      res = NodeSelectionInfo(
          map["node"],
          Point(lt[0], lt[1]),
          Point(rb[0], rb[1]),
          results
      );
    }
  } on PlatformException {
    log.info('getNodeByTouch failed with PlatformException');
    res = null;
  }
  return res;
}

void compileConfiguration(Set<Rule> rules) {
  log.info('compileConfiguration(); size == ${rules.length}');
  try {
    _channel.invokeMethod('compileConfiguration', <String, dynamic>{
      "rules": rules.map((e) => e.toJson()).toList()
    }).then((v){
      log.info('compileConfiguration finished');
    });
  } on PlatformException {
    log.info('compileConfiguration failed with PlatformException');
  }
}

Future<String> performSubstitution(int index) async {
  log.info('performSubstitution($index)');
  String res = '';
  try {
    res = await _channel.invokeMethod<String>('performSubstitution', <String, dynamic>{
      'index': index
    }) ?? 'failed';
  } on PlatformException {
    log.info('resolveExpression failed with PlatformException');
    res = 'failed';
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