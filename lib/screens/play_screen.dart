import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../providers/level_provider.dart';
import '../views/play_views/main_math_interaction_view.dart';
import '../views/play_views/rules_list_view.dart';
import '../views/play_views/task_description_view.dart';

class PlayScreen extends StatefulWidget {
  static const String routeName = '/play';

  const PlayScreen({Key? key}) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final levelProvider = Provider.of<LevelProvider>(context);
    gameProvider.load(context);
    if (gameProvider.loaded) {
      levelProvider.load(gameProvider.taskset!.tasks[gameProvider.currentLevel], gameProvider.allRulePacks!);
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
              levelProvider.name,
              style: Theme.of(context).textTheme.bodyText1
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.repeat_rounded),
              tooltip: 'Restart level',
              onPressed: () {
                levelProvider.unload();
                //Navigator.pushReplacementNamed(context, PlayScreen.routeName);
              },
            ),
            IconButton(
              icon: const Icon(Icons.undo_rounded),
              tooltip: 'Undo',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Undo')));
              },
            ),
          ],
        ),
        body: SafeArea(
          child: levelProvider.loaded == false ?
            _loadingBody(context) :
          levelProvider.passed ?
            Center(child: Text('PASSED'),) :
          MediaQuery.of(context).orientation == Orientation.portrait ?
            _portraitBody(context) :
            _landscapeBody(context),
        )
    );
  }

  Widget _loadingBody(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        height: MediaQuery.of(context).size.width / 5,
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
          strokeWidth: 6,
        ),
      ),
    );
  }

  Widget _portraitBody(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const TaskDescriptionView(),
          const Flexible(
            fit: FlexFit.tight,
            child: MathInteractionView(),
          ),
          SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight / 2,
              child: const RulesListView()
          ),
        ],
      );
    });
  }

  Widget _landscapeBody(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints)
    {
      return Row(
        children: [
          SizedBox(
            width: constraints.maxWidth / 5 * 3,
            height: constraints.maxHeight,
            child: Column(
              children: const [
                TaskDescriptionView(),
                Flexible(
                    fit: FlexFit.tight,
                    child: MathInteractionView()
                ),
              ],
            ),
          ),
          SizedBox(
              width: constraints.maxWidth / 5 * 2,
              height: constraints.maxHeight,
              child: const RulesListView()
          )
        ]
      );
    });
  }
}