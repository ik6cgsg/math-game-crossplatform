import 'package:math_game_crossplatform/domain/entities/result.dart';

class ResultModel extends Result {
  ResultModel(String taskCode, String expression, int stepCount, String state) :
    super(taskCode, expression, stepCount, LevelState.values.firstWhere((e) => e.toString() == state));

  factory ResultModel.fromEntity(Result r) => ResultModel(
      r.taskCode, r.expression, r.stepCount, r.state.toString()
  );
}