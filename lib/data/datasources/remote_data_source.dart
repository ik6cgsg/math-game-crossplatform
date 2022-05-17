import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/data/models/stat_models.dart';

abstract class RemoteDataSource {
  Future<void> logEvent(StatisticAction action);
}

class RemoteDataSourceFirebase implements RemoteDataSource {
  @override
  Future<void> logEvent(StatisticAction action) async {
    await FirebaseAnalytics.instance.logEvent(
      name: action.name,
      parameters: action.toMap(),
    );
    log.info('RemoteDataSourceFirebase: event ${action.name} logged successfully');
  }
}