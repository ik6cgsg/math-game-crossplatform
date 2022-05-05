import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_game_crossplatform/main.dart';
import '../../util/math_util.dart';

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
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return !_loaded ?
      _loadingBody(context) :
      Card(
        color: Theme.of(context).backgroundColor,
        elevation: 5,
        margin: const EdgeInsets.only(top: 3, bottom: 3),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(UIConstants.borderRadius)),
          onTap: widget.onTap,
          child:  Container(
            width: constraints.maxWidth,
            alignment: Alignment.center,
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
    });
  }
}

