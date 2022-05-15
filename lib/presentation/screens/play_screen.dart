import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';
import 'package:math_game_crossplatform/domain/repositories/remote_repository.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_event.dart';
import 'package:math_game_crossplatform/presentation/widgets/play/passed_view.dart';

import '../../di.dart';
import '../../main.dart';
import '../blocs/play/play_bloc.dart';
import '../blocs/play/play_state.dart';
import '../widgets/play/main_math_interaction_view.dart';
import '../widgets/play/rules_list_view.dart';
import '../widgets/play/task_description_view.dart';

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
    di<RemoteRepository>().logEvent(const StatisticActionScreenOpen('PlayScreen'));
  }

  @override
  void dispose() {
    SystemChrome.restoreSystemUIOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)?.settings.arguments as int;
    return BlocProvider(
      create: (_) => di<PlayBloc>()..add(LoadTaskEvent(index)),
      child: BlocBuilder<PlayBloc, PlayState>(builder: (context, state) {
        log.info('PlayScreen::build: $state');
        return Scaffold(
          appBar: _appBar(context),
          body: SafeArea(
            child: state is Loading ?
              _loadingBody(context) :
            state is Passed ?
              PassedView((rate) {
                di<RemoteRepository>().logEvent(StatisticActionLevelRate(BlocProvider.of<PlayBloc>(context).levelCode, rate));
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Оценка отправлена, спасибо!'),
                  action: SnackBarAction(label: '👌', onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  }),
                ));
              }) :
            state is Error ?
              _errorBody(context, state.message) :
            MediaQuery.of(context).orientation == Orientation.portrait ?
              _portraitBody(context) :
              _landscapeBody(context),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: state is Passed ? _passedActions(context, state) : null
        );
      })
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    var index = '';
    final playBloc = BlocProvider.of<PlayBloc>(context, listen: true);
    if (playBloc.state is !Loading) {
      index = playBloc.levelIndex.toString();
    }
    return AppBar(
      title: Text(
          'Уровень #$index',
          style: Theme.of(context).textTheme.headline1!
              .copyWith(color: Theme.of(context).backgroundColor)
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.repeat_rounded),
          color: Theme.of(context).backgroundColor,
          tooltip: 'Перезапуск уровня',
          onPressed: int.tryParse(index) == null ? null : () {
            di<RemoteRepository>().logEvent(StatisticActionRestart(playBloc.levelCode, playBloc.levelIndex));
            playBloc.add(RestartEvent());
          },
        ),
        IconButton(
          icon: const Icon(Icons.undo_rounded),
          color: Theme.of(context).backgroundColor,
          tooltip: 'Отмена действия',
          onPressed: !playBloc.canUndo ? null : () {
            playBloc.add(UndoEvent());
          },
        ),
      ],
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

  Widget _passedActions(BuildContext context, Passed info) {
    final bloc = BlocProvider.of<PlayBloc>(context);
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            heroTag: 'prev',
            label: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Предыдущий уровень',
            backgroundColor: !info.hasPrev ? Colors.grey : Theme.of(context).primaryColor,
            onPressed: !info.hasPrev ? null : () {
              bloc.add(LoadTaskEvent(bloc.levelIndex - 1));
            },
          ),
          const SizedBox(width: 30,),
          FloatingActionButton.extended(
            heroTag: 'reload',
            label: const Icon(Icons.repeat_rounded),
            tooltip: 'Перезапуск уровня',
            onPressed: () {
              di<RemoteRepository>().logEvent(StatisticActionRestart(bloc.levelCode, bloc.levelIndex));
              bloc.add(RestartEvent());
            },
          ),
          const SizedBox(width: 30,),
          FloatingActionButton.extended(
            heroTag: 'next',
            label: const Icon(Icons.arrow_forward_rounded),
            tooltip: 'Следующий уровень',
            backgroundColor: !info.hasNext ? Colors.grey : Theme.of(context).primaryColor,
            onPressed: !info.hasNext ? null : () {
              bloc.add(LoadTaskEvent(bloc.levelIndex + 1));
            },
          ),
        ]
    );
  }

  Widget _errorBody(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dangerous_rounded,
            size: MediaQuery.of(context).size.shortestSide / 2,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 20,),
          Text(
            error,
            style: Theme.of(context).textTheme.headline2
          )
        ]
      )
    );
  }
}