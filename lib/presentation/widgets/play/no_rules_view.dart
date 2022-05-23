import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_event.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_state.dart';

class NoRulesView extends StatefulWidget {
  const NoRulesView({Key? key}) : super(key: key);

  @override
  State<NoRulesView> createState() => _NoRulesViewState();
}

class _NoRulesViewState extends State<NoRulesView> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playBloc = BlocProvider.of<PlayBloc>(context, listen: true);
    var group = AutoSizeGroup();
    var subGroup = AutoSizeGroup();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0.1).animate(_controller),
          child: AutoSizeText(
            'Сведи выражение к цели сверху:\n'
            '👇 Кликни место в выражении\n'
            '🤔 Выбери преобразование из появившихся\n'
            '✨ Выражение автоматически преобразуется',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline1,
            minFontSize: 7,
            maxLines: 4,
          )
        ),
        Column(
          children: [
            Card(
              child: ListTile(
                title: AutoSizeText(
                  'Режим мультивыделения',
                  maxLines: 2,
                  wrapWords: false,
                  minFontSize: 5,
                  maxFontSize: 16,
                  group: group,
                ),
                subtitle: AutoSizeText(
                  'Для выделения нескольких мест в выражении',
                  maxLines: 2,
                  wrapWords: false,
                  minFontSize: 5,
                  maxFontSize: 13,
                  group: subGroup,
                ),
                trailing: Switch(
                  value: (playBloc.state as Step).state.multiselectMode,
                  onChanged: (_) {
                    playBloc.add(ToggleMultiselectEvent(null));
                  }
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: AutoSizeText('Текущий результат', group: group,),
                subtitle: AutoSizeText('${(playBloc.state as Step).state.stepCount} 👣', group: subGroup,),
              ),
            ),
          ]
        )
      ]
    );
  }
}