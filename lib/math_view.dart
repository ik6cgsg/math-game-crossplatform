import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'math_util.dart' as math_util;

class MathView extends StatefulWidget {
  final String expression;
  final double maxWidth;

  const MathView(this.expression, this.maxWidth, {Key? key}) : super(key: key);

  @override
  State<MathView> createState() => _MathViewState();
}

class _MathViewState extends State<MathView> {
  math_util.Point? _ltSelected;
  math_util.Point? _rbSelected;
  final double _defaultWidth = 10;

  @override
  Widget build(BuildContext context) {
    var lines = widget.expression.split('\n');
    double width = _defaultWidth;
    var ratio = widget.maxWidth / (_defaultWidth * lines[0].length);
    if (ratio < 1) {
      width *= ratio;
    }
    return Table(
      //border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
      defaultColumnWidth: FixedColumnWidth(width),
      children: lines.asMap().entries.map((line) {
        return TableRow(
          children: line.value.split('').asMap().entries.map((char) {
            var current = math_util.Point(char.key, line.key);
            var selected = false;
            if (_ltSelected != null && _rbSelected != null) {
              selected = current.isInside(_ltSelected!, _rbSelected!);
            }
            return TableCell(
              child: GestureDetector(
                child: Text(
                  char.value,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: width * 1.69,
                    height: 0.69,
                    color: selected ? Colors.teal : Colors.black,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal),
                ),
                onTap: () {
                  math_util.getNodeByTouch(current).then((value) {
                    print('getNodeByTouch($current) got $value');
                    setState(() {
                      _ltSelected = value?[0];
                      _rbSelected = value?[1];
                    });
                  });
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

