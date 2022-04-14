import 'dart:convert';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_game_crossplatform/json_data_models/rule_data.dart';

import 'json_data_models/task_data.dart';
import 'json_data_models/taskset_data.dart';
import 'math_util.dart' as math_util;
import 'math_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _expression = "expression";

  @override
  void initState() {
    super.initState();
    //_tryResolveExpression("((1/2+((cos(x-3/2)*(tg(x)/ctg(x)))/sin(-x+(x+y)/2))*14*sin(x*y/2))/(-(-35+x/2)))^(-1/2)", false);
    _parseGame();
  }

  void _parseGame() {
    DefaultAssetBundle.of(context).loadString("assets/games/global__CheckYourselfCompleteTrigonometry.json").then((value) {
      Map<String, dynamic> json = jsonDecode(value);
      var full = FullTaskset.fromJson(json);
      _loadLevel(full.taskset.tasks[0]);
    });
  }

  void _loadLevel(Task task) {
    math_util.resolveExpression(task.originalExpressionStructureString, true).then((value) {
      setState(() {
        _expression = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double padding = 20;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MathView(_expression, MediaQuery.of(context).size.width - padding * 2),
          ],
        ),
      ),
    );
  }
}
