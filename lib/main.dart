import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_game_crossplatform/json_data_models/rule_data.dart';
import 'package:math_game_crossplatform/logger.dart';
import 'package:math_game_crossplatform/views/rules_list_view.dart';
import 'package:math_game_crossplatform/views/task_description_view.dart';
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
        textTheme: TextTheme(
          bodyText1: GoogleFonts.notoSansMono(
            fontSize: 13,
            height: 0.69,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: GoogleFonts.notoSansMono(
            fontSize: 13,
            height: 0.69,
            color: Colors.teal,
            fontWeight: FontWeight.bold,
          ),
          headline1: GoogleFonts.notoSansMono(
            fontSize: 15,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold
          )
        )
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String _expr = "";
  String _goalExpr = "";
  Task? _task;
  NodeSelectionInfo? _info;
  bool _loaded = false;
  bool _passed = false;
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
    await _loadLevel(full.taskset.tasks[2], full.rulePacks);
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
      checkEnd(_expr, _task!.goalExpressionStructureString ?? '', _task!.goalPattern ?? '').then((passed) {
        setState(() {
          _passed = passed;
          _expr = value;
          _info = null;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      _loaded == false ?
        _loadingBody(context) :
      _passed ?
        Center(child: Text('PASSED'),) :
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
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
          strokeWidth: 6,
        ),
      ),
    );
  }

  Widget _portraitBody(BuildContext context) {
    var animation = AnimationController(vsync: this, duration: Duration(seconds: 3),)..repeat(reverse: true);
    var _fadeInFadeOut = Tween<double>(begin: 1, end: 0.1).animate(animation);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: TaskDescriptionView(_task!.descriptionShortEn, _goalExpr)
        ),
        Flexible(
          flex: 5,
          child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.all(padding),
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
          child: _info == null ?
          FadeTransition(
            opacity: _fadeInFadeOut,
            child: Text(
              "No rules, choose expression's node",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1
            )
          ) :
          RulesListView(_info!.results, _ruleSelected)
        ),
      ],
    );
  }

  Widget _landscapeBody(BuildContext context) {
    var animation = AnimationController(vsync: this, duration: Duration(seconds: 3),)..repeat(reverse: true);
    var _fadeInFadeOut = Tween<double>(begin: 1, end: 0.1).animate(animation);
    return Row(
      children: [
        Column(
          children: [
            Flexible(
              flex: 1,
              child: TaskDescriptionView(_task!.descriptionShortEn, _goalExpr)
            ),
            Flexible(
              flex: 6,
              child: Container(
                width: MediaQuery.of(context).size.width / 5 * 3,
                alignment: Alignment.center,
                padding: EdgeInsets.all(padding),
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
        Container(
          width: MediaQuery.of(context).size.width / 5 * 2,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: _info == null ?
            FadeTransition(
              opacity: _fadeInFadeOut,
              child: Text(
                "No rules,\nchoose\nexpression's\nnode",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1)
            ) :
            RulesListView(_info!.results, _ruleSelected)
        )
      ]
    );
  }
}
