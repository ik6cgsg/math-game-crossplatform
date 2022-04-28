import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../math_util.dart';

class RuleMathView extends StatefulWidget {
  final String expression;
  final void Function() onTap;

  const RuleMathView(
      this.expression, this.onTap, {Key? key}
  ): super(key: key);

  @override
  State<RuleMathView> createState() => _RuleMathViewState();
}

class _RuleMathViewState extends State<RuleMathView> {
  static const double _borderRadius = 10;
  String _output = "";
  String _curExpr = "";
  bool _loaded = false;

  void _updateExpression() {
    if (_curExpr != widget.expression) {
      //setState(() => _loaded = false);
      _curExpr = widget.expression;
      resolveExpression(_curExpr, true, true).then((res) {
        _output = res;
        setState(() => _loaded = true);
      });
    }
  }

  Widget _loadingBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      width: MediaQuery.of(context).size.width,
      height: 35,
      child: LinearProgressIndicator(
        color: Theme.of(context).primaryColor
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _updateExpression();
    return !_loaded ?
    _loadingBody(context) :
    Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(_borderRadius)),
        onTap: widget.onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: const BorderRadius.all(Radius.circular(_borderRadius)),
          ),
          alignment: Alignment.center,
          //margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10),
            child: Text(
              _output,
              style: Theme.of(context).textTheme.bodyText1
            ),
          ),
        ),
      ),
    );
  }
}

