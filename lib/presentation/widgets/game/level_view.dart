import 'package:flutter/material.dart';

class LevelView extends StatelessWidget {
  final int index;
  final String desc;
  final void Function() onTap;

  const LevelView(this.index, this.desc, this.onTap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: GridTile(
          header: GridTileBar(
            backgroundColor: Colors.white.withOpacity(0.5),
            title: Text(
              'Уровень #$index',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
            subtitle: Text(
              'Тип: $desc',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(height: 1),
            ),
          ),
          child: Opacity(
            opacity: 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset('assets/images/back.jpeg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.white.withOpacity(0.5),
            leading: Icon(
              Icons.play_arrow_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(5),
        onTap: onTap,
      ),
    );
  }
}
