import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_game_crossplatform/main.dart';
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

  Color? _getSelectionColor(BuildContext context, LevelProvider provider, Point cur) {
    int selectedTimes = 0;
    provider.selectedNodes?.forEach((box) {
      if (cur.isInside(box)) {
        selectedTimes++;
      }
    });
    if (selectedTimes > 0) {
      if (!provider.multiselectionModeOn) {
        return Theme.of(context).primaryColor;
      }
      if (selectedTimes % 2 == 0) {
        return CustomColors.multiselect2;
      }
      if (selectedTimes % 2 == 1) {
        return CustomColors.multiselect1;
      }
    }
    return null;
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
            var selectionColor = _getSelectionColor(context, levelProvider, current);
            return TableCell(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Text(
                  char.value,
                  style: selectionColor != null ?
                    Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: _width * 1.69,
                        color: selectionColor,
                    ) :
                    Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: _width * 1.69),
                ),
                onTap: () {
                  levelProvider.selectNode(current);
                },
                onLongPress: () {
                  HapticFeedback.mediumImpact();
                  levelProvider.toggleMultiselection(current);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: levelProvider.multiselectionModeOn ?
                      const Text('Режим мультивыбора включен') :
                      const Text('Режим мультивыбора отключен'),
                    action: SnackBarAction(
                      label: 'Отменить',
                      onPressed: () {
                        levelProvider.toggleMultiselection(current);
                      },
                    ),
                    duration: const Duration(seconds: 4),
                  ));
                },
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

