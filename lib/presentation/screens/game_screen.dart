import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/domain/entities/taskset.dart';
import 'package:math_game_crossplatform/domain/repositories/remote_repository.dart';
import 'package:math_game_crossplatform/presentation/blocs/game/game_event.dart';
import 'package:math_game_crossplatform/presentation/blocs/game/game_state.dart';
import 'package:math_game_crossplatform/presentation/screens/play_screen.dart';
import 'package:math_game_crossplatform/presentation/widgets/game/level_view.dart';

import '../../di.dart';
import '../blocs/game/game_bloc.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Уровни',
            style: Theme.of(context).textTheme.headline1!.copyWith(color: Theme.of(context).backgroundColor)
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (_) => di<GameBloc>()..add(LoadTasksetEvent()),
          child: BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              if (state is Loading) return _loadingBody(context);
              if (state is Loaded) return _loadedBody(context, state);
              return _errorBody(context, (state as Error).message);
            },
          ),
        ),
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

  Widget _loadedBody(BuildContext context, Loaded state) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: state.taskset.tasks.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isPortrait ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (ctx, i) => LevelView(
        i,
        state.taskset.tasks[i].descriptionShortRu,
        state.results?.firstWhereOrNull((e) => e.taskCode == state.taskset.tasks[i].code),
        () {
          Navigator.of(ctx).pushNamed(PlayScreen.routeName, arguments: i).then((_) {
            di<RemoteRepository>().logEvent(const StatisticActionScreenClose('PlayScreen'));
            BlocProvider.of<GameBloc>(context).add(LoadTasksetEvent());
          });
        }
      ),
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