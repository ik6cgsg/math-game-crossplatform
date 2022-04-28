import 'package:flutter/material.dart';

class TaskDescriptionView extends StatelessWidget {
  static const double _padding = 20;
  final String shortDescription;
  final String goalExpresion;

  const TaskDescriptionView(this.shortDescription, this.goalExpresion, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: _padding, right: _padding, top: _padding / 2, bottom: _padding / 2),
      child: Column(
        children: [
          Text(
            shortDescription,
            style: Theme.of(context).textTheme.headline1
          ),
          const Spacer(),
          goalExpresion.isNotEmpty ?
          Text(
            goalExpresion,
            style: Theme.of(context).textTheme.bodyText1
          ) :
          Container()
        ]
      )
    );
  }
}