import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:math_game_crossplatform/core/failures.dart';
import 'package:math_game_crossplatform/data/models/taskset_model.dart';

abstract class AssetDataSource {
  Future<FullTasksetModel> getFullTaskset();
}

const kGamePath = 'assets/game/game.json';
const kSettingsPath = 'assets/game/settings.json';

class BadSettings extends AssetFailure {}

class AssetDataSourceImpl implements AssetDataSource {
  @override
  Future<FullTasksetModel> getFullTaskset() async {
    var json = await rootBundle.loadString(kSettingsPath);
    final order = Settings.fromJson(jsonDecode(json)).orderedTaskCodes;
    json = await rootBundle.loadString(kGamePath);
    final fullTaskset = FullTasksetModel.fromJson(jsonDecode(json));
    fullTaskset.taskset.tasks.sort((t1, t2) {
      final i1 = order.indexOf(t1.code);
      final i2 = order.indexOf(t2.code);
      if (i1 < 0 || i2 < 0) throw BadSettings();
      return i1.compareTo(i2);
    });
    return Future.value(fullTaskset);
  }
}

class Settings {
  final List<String> orderedTaskCodes;

  const Settings(this.orderedTaskCodes);

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    (json['orderedTaskCodes'] as List<dynamic>?)!.map((e) => e as String).toList()
  );
}