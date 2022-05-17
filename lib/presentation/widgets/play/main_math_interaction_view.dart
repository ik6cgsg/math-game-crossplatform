import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_event.dart';

import 'main_math_view.dart';

class MathInteractionView extends StatefulWidget {
  const MathInteractionView({Key? key}): super(key: key);

  @override
  State<MathInteractionView> createState() => _MathInteractionViewState();
}

class _MathInteractionViewState extends State<MathInteractionView> {
  static const double _maxScale = 10;
  static const double _minScale = 0.3;

  Offset _offset = Offset.zero;
  Offset _initialFocalPoint = Offset.zero;
  Offset _sessionOffset = Offset.zero;
  double _scale = 1.0;
  double _initialScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor,
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
          BlocProvider.of<PlayBloc>(context).add(NodeSelectedEvent(null));
        },
        onScaleStart: (details) {
          _initialFocalPoint = details.focalPoint;
          _initialScale = _scale;
        },
        onScaleUpdate: (details) {
          _sessionOffset = details.focalPoint - _initialFocalPoint;
          _scale = _initialScale * details.scale;
          if (_scale < _minScale) {
            _scale = _minScale;
          } else if (_scale > _maxScale) {
            _scale = _maxScale;
          }
          setState(() {});
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