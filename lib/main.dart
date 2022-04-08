import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

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
  static const MethodChannel _channel = MethodChannel('math_helper_util');
  String _expression = "insert expression";

  @override
  void initState() {
    super.initState();
  }

  void _tryResolveExpression(String text) {
    try {
      _channel.invokeMethod<String>('resolveExpression', <String, dynamic>{
        'expression': text,
        'structured': false,
      }).then((value) {
        setState(() {
          _expression = value ?? 'failed to resolve';
        });
      });
    } on PlatformException {
      setState(() {
        _expression = 'failed to resolve';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "BASED"
              ),
              onSubmitted: _tryResolveExpression,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            SelectText(_expression, _channel),
          ],
        ),
      ),
    );
  }
}

class SelectText extends StatefulWidget {
  final String expression;
  final MethodChannel channel;

  const SelectText(this.expression, this.channel, {Key? key}) : super(key: key);

  @override
  State<SelectText> createState() => _SelectTextState();
}

class _SelectTextState extends State<SelectText> {
  var x = 0;
  var y = 0;
  var lt = [0, 0];
  var rb = [0, 0];

  void _tryGetNodeByTouch(int x, int y) {
    try {
      widget.channel.invokeMapMethod('getNodeByTouch', <String, dynamic>{
        "coords": [x, y]
      }).then((value) {
        print("_tryGetNodeByTouch got $value");
        var resMap = value?.cast<String, dynamic>();//Map<String, dynamic>;
        print("_tryGetNodeByTouch node = ${resMap?["node"]}");
        if (resMap != null) {
          setState(() {
            lt = List<int>.from(resMap["lt"]);
            rb = List<int>.from(resMap["rb"]);
            print("_tryGetNodeByTouch lt = $lt");
            print("_tryGetNodeByTouch rb = $rb");
          });
        }
      });
    } on PlatformException {
      print("_tryGetNodeByTouch failed");
    }
  }

  bool _isInside(List<int> tap, List<int> lt, List<int> rb) =>
    tap[0] >= lt[0] && tap[0] <= rb[0] && tap[1] >= lt[1] && tap[1] <= rb[1];


  @override
  Widget build(BuildContext context) {
    double w = 10;
    return Table(
      //border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
      defaultColumnWidth: FixedColumnWidth(w),
      children: widget.expression.split('\n').asMap().entries.map((ex) {
        return TableRow(
          children: ex.value.split('').asMap().entries.map((symb) {
            var isshit = _isInside([symb.key, ex.key], lt, rb);
            return TableCell(
              child: GestureDetector(
                child: Text(
                  symb.value,
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: w * 1.7,
                      height: 0.7,
                      color: isshit ? Colors.teal : Colors.black,
                      fontWeight: isshit ? FontWeight.bold : FontWeight.normal),
                ),
                onTap: () {
                  _tryGetNodeByTouch(symb.key, ex.key);
                },
                onLongPress: () {
                  HapticFeedback.mediumImpact();
                },
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
