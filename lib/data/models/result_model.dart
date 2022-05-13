import 'package:math_game_crossplatform/domain/entities/result.dart';

class ResultModel extends Result {
  ResultModel(int levelIndex, String expression, int stepCount, String state) :
    super(levelIndex, expression, stepCount, LevelState.values.firstWhere((e) => e.toString() == state));

  factory ResultModel.fromEntity(Result r) => ResultModel(
      r.levelIndex, r.expression, r.stepCount, r.state.toString()
  );
}