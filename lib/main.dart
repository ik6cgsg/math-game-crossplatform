import 'package:flutter/material.dart';
import 'package:math_game_crossplatform/di.dart' as di;
import 'package:math_game_crossplatform/presentation/screens/play_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/logger.dart';
import 'presentation/screens/game_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initLogger();
  runApp(const MyApp());
}

class CustomColors {
  static const Color multiselect1 = Colors.yellow;
  //static const Color multiselect2 = Colors.blue;
}

class UIConstants {
  static const double borderRadius = 5;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
              headline2: TextStyle(
                fontFamily: 'NotoSansMono',
                fontSize: 15,
                height: 1,
                color: Colors.red,
                fontWeight: FontWeight.normal,
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
      home: const GameScreen(),
      routes: {
        PlayScreen.routeName: (ctx) => PlayScreen()
      },
    );
  }
}
