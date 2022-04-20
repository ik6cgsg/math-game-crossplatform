import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../math_util.dart';

class RuleMathView extends StatefulWidget {
  final String expression;
  final double maxWidth;

  const RuleMathView(
      this.expression, this.maxWidth, {Key? key}
  ): super(key: key);

  @override
  State<RuleMathView> createState() => _RuleMathViewState();
}

class _RuleMathViewState extends State<RuleMathView> {
  final double _defaultWidth = 10;
  String _output = "loading...";
  String _curExpr = "";

  void _resolve() {
    if (_curExpr != widget.expression) {
      _curExpr = widget.expression;
      resolveExpression(_curExpr, true, true).then((res) {
        setState(() {
          _output = res;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _resolve();
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: EdgeInsets.all(10),
      //margin: EdgeInsets.only(top: 5,bottom: 5),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          _output,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            height: 0.69,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

