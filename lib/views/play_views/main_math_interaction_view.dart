import 'package:flutter/material.dart';
import 'package:math_game_crossplatform/providers/level_provider.dart';
import 'package:math_game_crossplatform/views/play_views/main_math_view.dart';
import 'package:provider/provider.dart';

import '../../util/math_util.dart';

class MathInteractionView extends StatefulWidget {
  const MathInteractionView({Key? key}): super(key: key);

  @override
  State<MathInteractionView> createState() => _MathInteractionViewState();
}

class _MathInteractionViewState extends State<MathInteractionView> {
  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;
  double _scale = 1.0;
  double _initialScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      clipBehavior: Clip.hardEdge,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          alignment: Alignment.center,
            child: OverflowBox(
              maxWidth: double.infinity,
              maxHeight: double.infinity,
              child: Transform.translate(
                offset: _offset + _sessionOffset,
                child: Transform.scale(
                  scale: _scale,
                  child: const MainMathView(),
              ),
            ),
          ),
        ),
        onTap: () {
          //todo: unselect all
        },
        onScaleStart: (details) {
          _initialFocalPoint = details.focalPoint;
          _initialScale = _scale;
        },
        onScaleUpdate: (details) {
          setState(() {
            _sessionOffset = details.focalPoint - _initialFocalPoint;
            _scale = _initialScale * details.scale;
          });
        },
        onScaleEnd: (details) {
          setState(() {
            _offset += _sessionOffset;
            _sessionOffset = Offset.zero;
          });
        },
      ),
    );
  }
}