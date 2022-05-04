import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/math_util.dart' as mu;
import '../../providers/level_provider.dart';

class TaskDescriptionView extends StatefulWidget {
  const TaskDescriptionView({Key? key}) : super(key: key);

  @override
  State<TaskDescriptionView> createState() => _TaskDescriptionViewState();
}

class _TaskDescriptionViewState extends State<TaskDescriptionView> {
  String _output = '';

  void _loadOutput(LevelProvider provider) {
    if (_output.isEmpty && provider.goalExpression.isNotEmpty) {
      mu.resolveExpression(provider.goalExpression, true, true).then((value) {
        setState(() {
          _output = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelProvider = Provider.of<LevelProvider>(context);
    _loadOutput(levelProvider);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      color: Theme.of(context).primaryColor.withAlpha(20),
      //shadowColor: Theme.of(context).primaryColor.withAlpha(20),
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 5),
      child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 10,),
            Text(
              levelProvider.shortDescription,
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),
            _output.isNotEmpty ?
            Text(
              _output,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ) :
            Container(),
            _output.isNotEmpty ? const SizedBox(height: 10,) : Container(),
          ]
        )
    );
  }
}