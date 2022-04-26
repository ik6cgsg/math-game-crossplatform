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
  double _width = 10;
  String _output = "";
  String _curExpr = "";
  bool _loaded = false;

  void _updateWidth() {
    var lines = _output.split('\n');
    var ratio = MediaQuery.of(context).size.width / (_width * lines[0].length);
    if (ratio < 1) {
      _width *= ratio;
    }
  }

  void _updateExpression() {
    if (_curExpr != widget.expression) {
      //setState(() => _loaded = false);
      _curExpr = widget.expression;
      resolveExpression(_curExpr, true, false).then((res) {
          _output = res;
          _updateWidth();
          setState(() => _loaded = true);
      });
    }
  }

  Widget _loadingBody(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.width / 5,
        child: const LinearProgressIndicator(
          color: Colors.teal,
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
                child: Text(
                  char.value,
                  style: GoogleFonts.notoSansMono(
                    fontSize: _width * 1.69,
                    height: 0.69,
                    color: selected ? Colors.teal : Colors.black,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal),
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

