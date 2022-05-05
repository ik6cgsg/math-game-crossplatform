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

  List<Widget> _children(BuildContext context, String descr) {
    return [
      const SizedBox(height: 10, width: 10,),
      Text(
        descr,
        style: Theme.of(context).textTheme.headline1,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 10, width: 10,),
      _output.isNotEmpty ?
      Text(
        _output,
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.center,
      ) :
      Container(),
      _output.isNotEmpty ? const SizedBox(height: 10, width: 10,) : Container(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final levelProvider = Provider.of<LevelProvider>(context);
    _loadOutput(levelProvider);
    return Card(
      color: Theme.of(context).primaryColor.withAlpha(20),
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 5),
      child: MediaQuery.of(context).orientation == Orientation.portrait ?
      Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          children: _children(context, levelProvider.shortDescription)
        ),
      ) :
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _children(context, levelProvider.shortDescription),
        ),
      ),
    );
  }
}