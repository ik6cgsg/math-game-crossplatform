import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String _expr = "";
  String _goalExpr = "";
  Task? _task;
  NodeSelectionInfo? _info;
  bool _loaded = false;
  final double padding = 20;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    _parseGame();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.restoreSystemUIOverlays();
  }

  Future<void> _parseGame() async {
    var value = await DefaultAssetBundle.of(context).loadString("assets/games/global__CheckYourselfCompleteTrigonometry.json");
    Map<String, dynamic> json = jsonDecode(value);
    var full = FullTaskset.fromJson(json);
    await _loadLevel(full.taskset.tasks[1], full.rulePacks);
    _loaded = true;
    setState((){});
  }

  Future<void> _loadLevel(Task task, List<RulePackage> allPacks) async {
    Map<String, RulePackage> allPacksMap = {};
    for (var e in allPacks) {
      allPacksMap[e.code] = e;
    }
    _task = task;
    _expr = task.originalExpressionStructureString;
    if (task.goalExpressionStructureString != null && task.goalExpressionStructureString!.isNotEmpty) {
      _goalExpr = await resolveExpression(task.goalExpressionStructureString!, true, true);
    }
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
    return Scaffold(
      body: _loaded == false ?
        _loadingBody(context) :
      MediaQuery.of(context).orientation == Orientation.portrait ?
        _portraitBody(context) :
        _landscapeBody(context)
    );
  }

  Widget _loadingBody(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        height: MediaQuery.of(context).size.width / 5,
        child: const CircularProgressIndicator(
          color: Colors.teal,
          strokeWidth: 6,
        ),
      ),
    );
  }

  Widget _portraitBody(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
              padding: EdgeInsets.only(left: padding, right: padding, top: padding / 2, bottom: padding / 2),
              child: Column(
                  children: [
                    Text(
                        _task!.descriptionShortEn,
                        style: GoogleFonts.notoSansMono(
                            fontSize: 15,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    SizedBox(height: 10),
                    _goalExpr.isNotEmpty ? Text(
                      _goalExpr,
                      style: GoogleFonts.notoSansMono(
                          fontSize: 15,
                          height: 0.69,
                          color: Colors.black,
                          fontWeight: FontWeight.normal
                      ),
                    ) : Container()
                  ]
              )
          ),
        ),
        Flexible(
          flex: 6,
          child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: padding, right: padding),
              child: MainMathView(
                  _expr,
                  _nodeSelected,
                  ltSelected: _info?.lt,
                  rbSelected: _info?.rb
              )
          ),
        ),
        Flexible(
          flex: 6,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
            ),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _info?.results.asMap().entries.map((pair) {
                  return RuleMathView(pair.value, () => _ruleSelected(pair.key),);
                }).toList() ?? [const Text("no rules")],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _landscapeBody(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: padding, right: padding, top: padding / 2, bottom: padding / 2),
                child: Column(
                  children: [
                    Text(
                      _task!.descriptionShortEn,
                      style: GoogleFonts.notoSansMono(
                          fontSize: 15,
                          color: Colors.teal,
                          fontWeight: FontWeight.bold
                      )
                    ),
                    SizedBox(height: 10),
                    _goalExpr.isNotEmpty ? Text(
                      _goalExpr,
                      style: GoogleFonts.notoSansMono(
                        fontSize: 15,
                        height: 0.69,
                        color: Colors.black,
                        fontWeight: FontWeight.normal
                      ),
                    ) : Container()
                  ]
                )
              ),
            ),
            Flexible(
              flex: 5,
              child: Container(
                //height: MediaQuery.of(context).size.height - padding,
                width: MediaQuery.of(context).size.width / 5 * 3,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: padding, right: padding),
                child: MainMathView(
                    _expr,
                    _nodeSelected,
                    ltSelected: _info?.lt,
                    rbSelected: _info?.rb
                )
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal, width: 2),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 5 * 2,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _info?.results.asMap().entries.map((pair) {
                    return RuleMathView(pair.value, () => _ruleSelected(pair.key),);
                  }).toList() ?? [const Text("no rules")],
                ),
              ),
            ),
          ]
        )
      ]
    );
  }
}
