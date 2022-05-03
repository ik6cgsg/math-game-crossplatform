import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../math_util.dart';

class MainMathView extends StatefulWidget {
  final String expression;
  final void Function(Point) tapHandle;
  final Point? ltSelected;
  final Point? rbSelected;

  const MainMathView(
      this.expression, this.tapHandle, {Key? key, this.ltSelected, this.rbSelected}
  ): super(key: key);

  @override
  State<MainMathView> createState() => _MainMathViewState();
}

class _MainMathViewState extends State<MainMathView> {
  final double _width = 10;
  String _output = "";
  String _curExpr = "";
  bool _loaded = false;

  void _updateExpression() {
    if (_curExpr != widget.expression) {
      _curExpr = widget.expression;
      resolveExpression(_curExpr, true, false).then((res) {
          _output = res;
          _loaded = true;
          setState(() {});
      });
    }
  }

  Widget _loadingBody(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.width / 5,
        child: LinearProgressIndicator(
          color: Theme.of(context).primaryColor,
          minHeight: 6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _updateExpression();
    return !_loaded ?
    _loadingBody(context) :
    Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
      defaultColumnWidth: FixedColumnWidth(_width),
      children: _output.split('\n').asMap().entries.map((line) {
        return TableRow(
          children: line.value.split('').asMap().entries.map((char) {
            var current = Point(char.key, line.key);
            var selected = false;
            if (widget.ltSelected != null && widget.rbSelected != null) {
              selected = current.isInside(widget.ltSelected!, widget.rbSelected!);
            }
            return TableCell(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Text(
                  char.value,
                  style: selected ?
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: _width * 1.69) :
                  Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: _width * 1.69),
                ),
                onTap: () {
                  widget.tapHandle(current);
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

