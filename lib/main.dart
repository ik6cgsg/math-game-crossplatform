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
          textTheme: TextTheme(
            // todo: download font to assets
            bodyText1: GoogleFonts.notoSansMono(
              fontSize: 13,
              height: 0.69,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
            bodyText2: GoogleFonts.notoSansMono(
              fontSize: 13,
              height: 0.69,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
            headline1: GoogleFonts.notoSansMono(
              fontSize: 15,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold
            )
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
