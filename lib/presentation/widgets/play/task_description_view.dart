import 'package:flutter/material.dart' hide Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_game_crossplatform/data/models/platform_models.dart';
import 'package:math_game_crossplatform/presentation/blocs/play/play_state.dart' hide Error;
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_event.dart';
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_state.dart';

import '../../../di.dart';
import '../../blocs/play/play_bloc.dart';

class TaskDescriptionView extends StatelessWidget {
  const TaskDescriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PlayBloc>(context);
    if (bloc.goalExpression.isEmpty) {
      return _resolvedBody(context, '', bloc.shortDescription);
    }
    return BlocProvider(
      create: (_) => di<ResolverBloc>()..add(Resolve(
        ResolutionInput(bloc.goalExpression, bloc.subjectType, true, false)
      )),
      child: BlocBuilder<ResolverBloc, ResolverState>(builder: (context, state) {
        if (state is Resolving) return _resolvedBody(context, '', bloc.shortDescription);
        if (state is Resolved) return _resolvedBody(context, state.matrix, bloc.shortDescription);
        return _errorBody(context, (state as Error).message);
      })
    );
  }

  Widget _resolvedBody(BuildContext context, String output, String desc) {
    return Card(
      color: Theme.of(context).primaryColor.withAlpha(20),
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 5),
      child: MediaQuery.of(context).orientation == Orientation.portrait ?
      Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          children: _children(context, desc, output)
        ),
      ) :
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _children(context, desc, output),
        ),
      ),
    );
  }

  List<Widget> _children(BuildContext context, String descr, String output) {
    final textTheme = Theme.of(context).textTheme;
    return [
      const SizedBox(height: 10, width: 10,),
      Text(
        descr,
        style: textTheme.headline1?.copyWith(height: textTheme.bodyText1!.height),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 10, width: 10,),
      output.isNotEmpty ?
      Text(
        output,
        style: textTheme.bodyText1,
      ) :
      Container(),
      output.isNotEmpty ? const SizedBox(height: 10, width: 10,) : Container(),
    ];
  }

  Widget _errorBody(BuildContext context, String error) {
    return Card(
      margin: const EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 5),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2
        ),
      )
    );
  }
}