import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../math_util.dart';

class MainMathView extends StatefulWidget {
  final String expression;
  final double maxWidth;
  final void Function(Point) tapHandle;
  final Point? ltSelected;
  final Point? rbSelected;

  const MainMathView(
      this.expression, this.maxWidth, this.tapHandle, {Key? key, this.ltSelected, this.rbSelected}
  ): super(key: key);

  @override
  State<MainMathView> createState() => _MainMathViewState();
}

class _MainMathViewState extends State<MainMathView> {
  final double _defaultWidth = 10;
  String _output = "loading...";
  String _curExpr = "";

  void _resolve() {
    if (_curExpr != widget.expression) {
      _curExpr = widget.expression;
      resolveExpression(_curExpr, true, widget.tapHandle == null).then((res) {
        setState(() {
          _output = res;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _resolve();
    var lines = _output.split('\n');
    double width = _defaultWidth;
    var ratio = widget.maxWidth / (_defaultWidth * lines[0].length);
    if (ratio < 1) {
      width *= ratio;
    }
    return Container(
      //padding: EdgeInsets.all(20),
      child: Table(
        //border: TableBorder.all(),
        defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
        defaultColumnWidth: FixedColumnWidth(width),
        children: lines.asMap().entries.map((line) {
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
                      fontSize: width * 1.69,
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
      ),
    );
  }
}

