import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_game_crossplatform/util/logger.dart';
import 'package:math_game_crossplatform/providers/level_provider.dart';
import 'package:math_game_crossplatform/screens/play_screen.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';

void main() {
  initLogger();
  runApp(const MyApp());
}

class CustomColors {
  static const Color multiselect1 = Colors.yellow;
  static const Color multiselect2 = Colors.blue;
}

class UIConstants {
  static const double borderRadius = 5;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: GameProvider(),
        ),
        ChangeNotifierProvider.value(
          value: LevelProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          backgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              fontFamily: 'NotoSansMono',
              fontSize: 13,
              height: 0.69,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            bodyText2: TextStyle(
              fontFamily: 'NotoSansMono',
              fontSize: 13,
              height: 0.69,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
            headline1: TextStyle(
              fontFamily: 'NotoSansMono',
              fontSize: 15,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold
            )
          ),
          cardTheme: CardTheme(
            color: Theme.of(context).primaryColor.withAlpha(20),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }
          )
        ),
        home: const PlayScreen(),
        routes: {
          PlayScreen.routeName: (ctx) => const PlayScreen()
          // todo: HomeScreen
        },
      )
    );
  }
}
