import 'package:flutter/material.dart';
import 'package:math_game_crossplatform/views/main_math_view.dart';

import '../math_util.dart';

class MathInteractionView extends StatefulWidget {
  final String expression;
  final void Function(Point) tapHandle;
  final Point? ltSelected;
  final Point? rbSelected;

  const MathInteractionView(
      this.expression, this.tapHandle, {Key? key, this.ltSelected, this.rbSelected}
  ): super(key: key);

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
                  child: MainMathView(widget.expression, widget.tapHandle, ltSelected: widget.ltSelected,
                    rbSelected: widget.rbSelected),
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