import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:math_game_crossplatform/main.dart';
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_bloc.dart';
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_event.dart';
import 'package:math_game_crossplatform/presentation/blocs/resolver/resolver_state.dart';

import '../../../di.dart';

class RuleMathView extends StatelessWidget {
  final String expression;
  final void Function() onTap;

  const RuleMathView(this.expression, this.onTap, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di<ResolverBloc>()..add(Resolve(expression, true, false)),
      child: BlocBuilder<ResolverBloc, ResolverState>(builder: (context, state) {
        if (state is Resolving) return _loadingBody(context);
        if (state is Resolved) return _resolvedBody(state.matrix);
        return _errorBody(context, (state as Error).message);
      })
    );
  }

  Widget _loadingBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      width: MediaQuery.of(context).size.width,
      height: 35,
      child: LinearProgressIndicator(
          color: Theme.of(context).primaryColor
      ),
    );
  }

  Widget _resolvedBody(String output) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Card(
        color: Theme.of(context).backgroundColor,
        elevation: 5,
        margin: const EdgeInsets.only(top: 3, bottom: 3),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(UIConstants.borderRadius)),
          onTap: onTap,
          child:  Container(
            width: constraints.maxWidth,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10),
              child: Text(
                  output,
                  style: Theme.of(context).textTheme.bodyText1
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _errorBody(BuildContext context, String error) {
    return Card(
      color: Theme.of(context).errorColor.withOpacity(0.7),
      elevation: 0,
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: SelectableText(
            error,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(height: 1)
        ),
      )
    );
  }
}

