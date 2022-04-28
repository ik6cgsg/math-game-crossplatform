import 'package:flutter/material.dart';
import 'rule_math_view.dart';

class RulesListView extends StatelessWidget {
  final List<String> results;
  final void Function(int) ruleSelected;

  const RulesListView(this.results, this.ruleSelected, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        width: constraints.maxWidth,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: results.asMap().entries.map((pair) {
              return RuleMathView(pair.value, () => ruleSelected(pair.key),);
            }).toList(),
          ),
        ),
      );
    });
  }
}