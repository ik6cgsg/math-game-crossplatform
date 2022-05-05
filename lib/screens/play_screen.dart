import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../main.dart';
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
            'Уровень #${gameProvider.currentLevel}',
            style: Theme.of(context).textTheme.headline1!.copyWith(color: Theme.of(context).backgroundColor)
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.repeat_rounded),
            color: Theme.of(context).backgroundColor,
            tooltip: 'Перезапуск уровня',
            onPressed: () {
              levelProvider.unload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.undo_rounded),
            color: Theme.of(context).backgroundColor,
            tooltip: 'Отмена действия',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('To be developed')));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: !levelProvider.loaded ?
          _loadingBody(context) :
        levelProvider.passed ?
          _passedBody(context) :
        MediaQuery.of(context).orientation == Orientation.portrait ?
          _portraitBody(context) :
          _landscapeBody(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !levelProvider.passed ? null : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              label: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Предыдущий уровень',
              onPressed: () {
                // todo: prev level
              },
            ),
            const SizedBox(width: 30,),
            FloatingActionButton.extended(
              label: const Icon(Icons.repeat_rounded),
              tooltip: 'Перезапуск уровня',
              onPressed: () {
                levelProvider.unload();
              },
            ),
            const SizedBox(width: 30,),
            FloatingActionButton.extended(
              label: const Icon(Icons.arrow_forward_rounded),
              tooltip: 'Следующий уровень',
              onPressed: () {
                // todo: next level
              },
            ),
          ]

      ),
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

  Widget _passedBody(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var h = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: isPortrait ? h / 3 : h / 6,),
          Text(
            '🎉 Уровень пройден 🎉',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 25)
          ),
          SizedBox(height: 30,),
          Text(
            'Как тебе уровень?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1?.copyWith(fontStyle: FontStyle.normal)
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _emojiButton('😭️'),
                _emojiButton('🙁'),
                _emojiButton('🤨'),
                _emojiButton('🙂'),
                _emojiButton('😊'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _emojiButton(String smile) {
    return Card(
        child: InkWell (
          borderRadius: const BorderRadius.all(Radius.circular(UIConstants.borderRadius)),
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(smile),
          ),
        )
    );
  }
}