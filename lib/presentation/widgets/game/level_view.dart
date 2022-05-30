import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/main.dart';

class LevelView extends StatelessWidget {
  final int index;
  final String desc;
  final Result? result;
  final AutoSizeGroup descGroup;
  final AutoSizeGroup titleGroup;
  final void Function() onTap;

  const LevelView({
    required this.index,
    required this.desc,
    required this.result,
    required this.descGroup,
    required this.titleGroup,
    required this.onTap,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return InkWell(
        child: GridTile(
            header: _header(context, constraints),
            child: Opacity(
              opacity: 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset('assets/images/back.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            footer: _resultFooter(context, constraints)
        ),
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
        //),
      );
    });
  }

  Widget _header(BuildContext context, BoxConstraints constraints) {
    return SizedBox(
      height: constraints.maxHeight / 3 * 2,
      child: GridTileBar(
        title: AutoSizeText(
          'Уровень #$index',
          style: Theme.of(context).textTheme.headline1,
          maxLines: 1,
          minFontSize: 5,
          group: titleGroup,
        ),
        subtitle: AutoSizeText(
          '$desc\n',
          maxLines: 2,
          wrapWords: false,
          minFontSize: 5,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(height: 1),
          group: titleGroup,
        ),
      ),
    );
  }

  Widget _resultFooter(BuildContext context, BoxConstraints constraints) {
    return SizedBox(
      height: constraints.maxHeight / 3,
      child: GridTileBar(
        leading: Icon(
          result?.state == LevelState.locked ?
          Icons.lock_outline_rounded :
          result?.state == LevelState.paused ?
            Icons.pause_rounded :
          result?.state == LevelState.passed ?
            Icons.done_rounded:
            Icons.play_arrow_rounded,
          color: Theme.of(context).primaryColor,
          size: constraints.maxHeight / 5,
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText(
            result == null ? 'попробуй пройти!' : 'текущий результат',
            style: Theme.of(context).textTheme.headline1,
            minFontSize: 5,
            maxLines: 1,
            group: descGroup,
          ),
        ),
        subtitle: result == null ? Container() : Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText(
            '${result?.stepCount ?? '―'} 👣',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(height: 1),
            minFontSize: 5,
            maxLines: 1,
            group: descGroup,
          ),
        ),
      ),
    );
  }
}
