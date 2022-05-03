import 'package:flutter/material.dart';
import 'rule_math_view.dart';

class RulesListView extends StatelessWidget {
  final List<String> results;
  final void Function(int) ruleSelected;

  const RulesListView(this.results, this.ruleSelected, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      color: Theme.of(context).primaryColor.withAlpha(20),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: results.asMap().entries.map((pair) {
              return RuleMathView(pair.value, () => ruleSelected(pair.key),);
            }).toList(),
          ),
        ),
      ),
    );
  }
}