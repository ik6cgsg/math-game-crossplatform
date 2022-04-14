import 'package:flutter/services.dart';

const MethodChannel _channel = MethodChannel('mathhelper.games.crossplatform/math_util');

class Point {
  final int x, y;

  Point(this.x, this.y);

  bool isInside(Point lt, Point rb) => x >= lt.x && x <= rb.x && y >= lt.y && y <= rb.y;

  @override
  String toString() => '($x, $y)';
}

Future<String> resolveExpression(String expressionStr, bool isStructured) async {
  String res = '';
  try {
    res = await _channel.invokeMethod<String>('resolveExpression', <String, dynamic>{
      'expression': expressionStr,
      'structured': isStructured,
    }) ?? 'failed';
  } on PlatformException {
    res = 'failed';
  }
  return res;
}

Future<List?> getNodeByTouch(Point tap) async {
  List? res;
  try {
    var invokeRes = await _channel.invokeMapMethod('getNodeByTouch', <String, dynamic>{
      "coords": [tap.x, tap.y]
    });
    var map = invokeRes?.cast<String, dynamic>();
    if (map != null) {
      var lt = List<int>.from(map["lt"]);
      var rb = List<int>.from(map["rb"]);
      res = [Point(lt[0], lt[1]), Point(rb[0], rb[1])];
    }
  } on PlatformException {
    res = null;
  }
  return res;
}