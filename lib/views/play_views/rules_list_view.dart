import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../providers/level_provider.dart';
import 'no_rules_view.dart';
import 'rule_math_view.dart';

class RulesListView extends StatelessWidget {
  const RulesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelProvider = Provider.of<LevelProvider>(context);
    return Card(
      color: Theme.of(context).primaryColor.withAlpha(20),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child: levelProvider.substitutionRules == null ?
          const NoRulesView() :
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: levelProvider.substitutionRules!.asMap().entries.map((pair) {
                return RuleMathView(pair.value, () => levelProvider.selectRule(pair.key),);
              }).toList(),
            ),
          ),
      ),
    );
  }
}