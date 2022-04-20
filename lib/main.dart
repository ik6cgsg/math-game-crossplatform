import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:math_game_crossplatform/json_data_models/rule_data.dart';
import 'package:math_game_crossplatform/logger.dart';
import 'json_data_models/task_data.dart';
import 'json_data_models/taskset_data.dart';
import 'math_util.dart';
import 'views/main_math_view.dart';
import 'views/rule_math_view.dart';

void main() {
  initLogger();
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
  //Task? _task;
  String _expr = "expression";
  NodeSelectionInfo? _info;
  double _dy = 0;
  final double _dividerHeight = 20;

  @override
  void initState() {
    super.initState();
    //_tryResolveExpression("((1/2+((cos(x-3/2)*(tg(x)/ctg(x)))/sin(-x+(x+y)/2))*14*sin(x*y/2))/(-(-35+x/2)))^(-1/2)", false);
    _parseGame();
  }

  Future<void> _parseGame() async {
    var value = await DefaultAssetBundle.of(context).loadString("assets/games/global__CheckYourselfCompleteTrigonometry.json");
    Map<String, dynamic> json = jsonDecode(value);
    var full = FullTaskset.fromJson(json);
    await _loadLevel(full.taskset.tasks[0], full.rulePacks);
    setState((){});
  }

  Future<void> _loadLevel(Task task, List<RulePackage> allPacks) async {
    Map<String, RulePackage> allPacksMap = {};
    for (var e in allPacks) {
      allPacksMap[e.code] = e;
    }
    //_task = task;
    _expr = task.originalExpressionStructureString;//await math_util.resolveExpression(task.originalExpressionStructureString, true);
    var allRules = {...?task.rules};
    task.rulePacks?.forEach((element) {
      var packRules = allPacksMap[element.rulePackCode]?.getAllRules(allPacksMap);
      allRules = {...allRules, ...?packRules};
    });
    compileConfiguration(allRules);
  }

  void _nodeSelected(Point current) {
    getNodeByTouch(current).then((value) {
      setState(() {
        _info = value;
      });
    });
  }

  void _ruleSelected(int i) {
    performSubstitution(i).then((value) {
      setState(() {
        _expr = value;
        _info = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double padding = 20;
    return Scaffold(
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2 - _dividerHeight / 2 + _dy,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: padding, right: padding),
            child: MainMathView(
              _expr,
              MediaQuery.of(context).size.width - padding * 2,
              _nodeSelected,
              ltSelected: _info?.lt,
              rbSelected: _info?.rb
            )
          ),
          GestureDetector(
            child: Container(
              height: _dividerHeight,
              width: _dividerHeight * 4,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Colors.teal
              ),
              //color: Colors.teal,
            ),
            onVerticalDragUpdate: (details) {
              setState(() {
                _dy += details.delta.dy;
              });
            },
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            ),
            height: MediaQuery.of(context).size.height / 2 - _dividerHeight / 2 - _dy,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: padding, right: padding),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _info?.results.asMap().entries.map((pair) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: RuleMathView(pair.value, MediaQuery.of(context).size.width - padding * 2),
                      onTap: () => _ruleSelected(pair.key),
                    ),
                  );
                }).toList() ?? [Text("no rules")],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
