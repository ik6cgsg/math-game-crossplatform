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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0.1).animate(_controller),
          child: Text(
            'Нет правил.\nВыбери узел\nв выражении!',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headline1,
          )
        ),
        Column(
          children: [
            Card(
              child: ListTile(
                title: Text('Режим мультивыбора'),
                subtitle: Text('включается также долгим нажатием'),
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
                title: Text('Текущий результат'),
                subtitle: Text('${(playBloc.state as Step).state.stepCount} шагов'),
              ),
            ),
          ]
        )
      ]
    );
  }
}