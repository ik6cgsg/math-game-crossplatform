import 'package:flutter/material.dart';
import 'package:math_game_crossplatform/main.dart';

class PassedView extends StatefulWidget {
  final void Function(int) onTap;
  const PassedView(this.onTap, {Key? key}) : super(key: key);

  @override
  State<PassedView> createState() => _PassedViewState();
}

class _PassedViewState extends State<PassedView> {
  int _selectedRate = 0;

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 30,),
          Text(
              'Как тебе уровень?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1?.copyWith(fontStyle: FontStyle.normal)
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _emojiButton(context, '😭️', 1),
                _emojiButton(context, '🙁', 2),
                _emojiButton(context, '🤨', 3),
                _emojiButton(context, '🙂', 4),
                _emojiButton(context, '😊', 5),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _emojiButton(BuildContext context, String smile, int rate) {
    return Card(
        color: _selectedRate == rate ?
          Theme.of(context).primaryColor.withOpacity(0.5) : null,
        child: InkWell (
          borderRadius: const BorderRadius.all(Radius.circular(UIConstants.borderRadius)),
          onTap: () {
            setState(() {
              _selectedRate = rate;
            });
            widget.onTap(rate);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(smile),
          ),
        )
    );
  }
}