import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MathView extends StatefulWidget {
  final String expression;
  final MethodChannel channel;

  const MathView(this.expression, this.channel, {Key? key}) : super(key: key);

  @override
  State<MathView> createState() => _MathViewState();
}

class _MathViewState extends State<MathView> {
  var lt = [0, 0];
  var rb = [0, 0];
  double defaultWidth = 10;

  void _tryGetNodeByTouch(int x, int y) {
    try {
      widget.channel.invokeMapMethod('getNodeByTouch', <String, dynamic>{
        "coords": [x, y]
      }).then((value) {
        print("_tryGetNodeByTouch got $value");
        var resMap = value?.cast<String, dynamic>();
        if (resMap != null) {
          setState(() {
            lt = List<int>.from(resMap["lt"]);
            rb = List<int>.from(resMap["rb"]);
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
    var lines = widget.expression.split('\n');
    double width = defaultWidth;
    var frac = (MediaQuery.of(context).size.width - 40) / (defaultWidth * lines[0].length);
    if (frac < 1) {
      width *= frac;
      print("width changed to $width");
    }
    return Table(
      //border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
      defaultColumnWidth: FixedColumnWidth(width),
      children: lines.asMap().entries.map((ex) {
        return TableRow(
          children: ex.value.split('').asMap().entries.map((symb) {
            var selected = _isInside([symb.key, ex.key], lt, rb);
            return TableCell(
              child: GestureDetector(
                child: Text(
                  symb.value,
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: width * 1.69,
                      height: 0.69,
                      color: selected ? Colors.teal : Colors.black,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal),
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