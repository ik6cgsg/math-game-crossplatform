import 'package:flutter/material.dart';

class TaskDescriptionView extends StatelessWidget {
  final String shortDescription;
  final String goalExpresion;

  const TaskDescriptionView(this.shortDescription, this.goalExpresion, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              shortDescription,
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10,),
            goalExpresion.isNotEmpty ?
            Text(
              goalExpresion,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ) :
            Container(),
            goalExpresion.isNotEmpty ? const SizedBox(height: 10,) : Container(),
          ]
        )
    );
  }
}