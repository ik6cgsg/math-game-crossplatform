import 'package:flutter/material.dart';

class NoRulesView extends StatefulWidget {
  const NoRulesView({Key? key}) : super(key: key);

  @override
  State<NoRulesView> createState() => _NoRulesViewState();
}

class _NoRulesViewState extends State<NoRulesView> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0.1).animate(_controller),
          child: Text(
            "Нет правил.\nВыбери узел\nв выражении!",
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headline1,
          )
      ),
    );
  }
}