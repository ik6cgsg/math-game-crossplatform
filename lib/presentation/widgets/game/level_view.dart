import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';
import 'package:math_game_crossplatform/main.dart';

class LevelView extends StatelessWidget {
  final int index;
  final String desc;
  final Result? result;
  final void Function() onTap;

  const LevelView(this.index, this.desc, this.result, this.onTap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: GridTile(
          header: GridTileBar(
            title: Text(
              'Уровень #$index',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            subtitle: AutoSizeText(
              desc,
              maxLines: 2,
              wrapWords: false,
              maxFontSize: 14,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(height: 1),
            ),
          ),
          child: Opacity(
            opacity: 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset('assets/images/back.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          footer: _resultFooter(context)
        ),
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
      //),
    );
  }

  Widget _resultFooter(BuildContext context) {
    var myGroup = AutoSizeGroup();
    return SizedBox(
      height: 50,
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
          size: 30,
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText(
            result == null ? 'попробуй пройти!' : 'текущий результат',
            style: Theme.of(context).textTheme.headline1,
            minFontSize: 9,
            maxLines: 1,
            group: myGroup,
          ),
        ),
        subtitle: result == null ? Container() : Align(
          alignment: Alignment.centerRight,
          child: AutoSizeText(
            '${result?.stepCount ?? '―'} 👣',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(height: 1),
            minFontSize: 9,
            maxLines: 1,
            group: myGroup,
          ),
        ),
      ),
    );
  }
}
