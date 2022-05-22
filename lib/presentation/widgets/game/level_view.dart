import 'package:flutter/material.dart';
import 'package:math_game_crossplatform/domain/entities/result.dart';

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
            subtitle: Text(
              desc,
              maxLines: 2,
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
    return GridTileBar(
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
        child: FittedBox(
          child: Text(
            result == null ? 'попробуй пройти!' : 'текущий результат',
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      subtitle: result == null ? null : Align(
        alignment: Alignment.centerRight,
        child: FittedBox(
          child: Text(
            '${result?.stepCount ?? '―'} шагов',
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(height: 1, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
