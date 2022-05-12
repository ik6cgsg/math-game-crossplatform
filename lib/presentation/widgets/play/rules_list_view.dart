import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_event.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_state.dart';
import 'no_rules_view.dart';
import 'rule_math_view.dart';

class RulesListView extends StatelessWidget {
  const RulesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playBloc = BlocProvider.of<PlayBloc>(context, listen: true);
    if (playBloc.state is Step) {
      final step = playBloc.state as Step;
      return Card(
        color: Theme.of(context).primaryColor.withAlpha(20),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          alignment: Alignment.center,
          child: step.substitutionInfo == null ?
          const NoRulesView() :
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: step.substitutionInfo!.rules.asMap().entries.map((pair) {
                return RuleMathView(
                  pair.value,
                  () => playBloc.add(RuleSelectedEvent(pair.key)),
                  key: ValueKey(pair.value),
                );
              }).toList(),
            ),
          ),
        ),
      );
    } else {
      return const NoRulesView();
    }
  }
}