import 'package:flutter/material.dart' hide Step;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/main.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_event.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_state.dart' hide Error;
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_event.dart';
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_state.dart';

import '../../../di.dart';
import '../../../domain/entities/platform_entities.dart';

class MainMathView extends StatefulWidget {
  const MainMathView({Key? key}): super(key: key);

  @override
  State<MainMathView> createState() => _MainMathViewState();
}

class _MainMathViewState extends State<MainMathView> {
  final double _width = 10;
  String _currentExpression = '';

  @override
  Widget build(BuildContext context) {
    final playState = BlocProvider.of<PlayBloc>(context, listen: true).state;
    return BlocProvider(
      create: (_) => di<ResolverBloc>(),
      child: BlocBuilder<ResolverBloc, ResolverState>(builder: (context, state) {
        if (playState is Step) {
          if (_currentExpression != playState.currentExpression) {
            _currentExpression = playState.currentExpression;
            BlocProvider.of<ResolverBloc>(context).add(Resolve(_currentExpression, true, true));
          }
          if (state is Resolving) return _loadingBody(context);
          if (state is Resolved) return _resolvedBody(context, state.matrix, playState);
          return _errorBody(context, (state as Error).message);
        } else {
          return _loadingBody(context);
        }
      },)
    );
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

  Widget _resolvedBody(BuildContext context, String output, Step playState) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
      defaultColumnWidth: FixedColumnWidth(_width),
      children: output.split('\n').asMap().entries.map((line) {
        return TableRow(
          children: line.value.split('').asMap().entries.map((char) {
            var current = Point(char.key, line.key);
            var selectionColor = _getSelectionColor(context, current, playState);
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
                  BlocProvider.of<PlayBloc>(context).add(NodeSelectedEvent(current));
                },
                onLongPress: () {
                  HapticFeedback.mediumImpact();
                  BlocProvider.of<PlayBloc>(context).add(ToggleMultiselectEvent(current));
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: playState.multiselectMode ?
                    const Text('Режим мультивыбора отключен') :
                    const Text('Режим мультивыбора включен'),
                    action: SnackBarAction(
                      label: 'Отменить',
                      onPressed: () {
                        BlocProvider.of<PlayBloc>(context).add(ToggleMultiselectEvent(current));
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

  Color? _getSelectionColor(BuildContext context, Point cur, Step playState) {
    int selectedTimes = 0;
    playState.selectionInfo?.forEach((info) {
      if (cur.isInside(info.selection)) {
        selectedTimes++;
      }
    });
    if (selectedTimes > 0) {
      if (!playState.multiselectMode) {
        return Theme.of(context).primaryColor;
      } else {
        final hsl = HSLColor.fromColor(CustomColors.multiselect1);
        final hslDark = hsl.withLightness((hsl.lightness - 0.1 * selectedTimes).clamp(0.0, 1.0));
        return hslDark.toColor();
      }
      /*if (selectedTimes % 2 == 0) {
        return CustomColors.multiselect2;
      }
      if (selectedTimes % 2 == 1) {
        return CustomColors.multiselect1;
      }*/
    }
    return null;
  }

  Widget _errorBody(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(
        error,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline2
      ),
    );
  }
}
