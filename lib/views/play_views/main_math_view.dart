import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../util/math_util.dart';
import '../../providers/level_provider.dart';

class MainMathView extends StatefulWidget {
  const MainMathView({Key? key}): super(key: key);

  @override
  State<MainMathView> createState() => _MainMathViewState();
}

class _MainMathViewState extends State<MainMathView> {
  final double _width = 10;
  String _output = "";
  String _curExpr = "";
  bool _loaded = false;

  void _updateExpression(String expression) {
    if (_curExpr != expression) {
      _curExpr = expression;
      resolveExpression(_curExpr, true, false).then((res) {
          _output = res;
          _loaded = true;
          setState(() {});
      });
    }
  }

  Widget _loadingBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      child: LinearProgressIndicator(
        color: Theme.of(context).primaryColor,
        minHeight: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final levelProvider = Provider.of<LevelProvider>(context);
    _updateExpression(levelProvider.currentExpression);
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
            if (levelProvider.selectionInfo?.lt != null && levelProvider.selectionInfo?.rb != null) {
              selected = current.isInside(levelProvider.selectionInfo!.lt, levelProvider.selectionInfo!.rb);
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
                  levelProvider.selectNode(current);
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

