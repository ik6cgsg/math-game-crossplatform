import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:math_game_crossplatform/data/models/taskset_model.dart';

abstract class LocalDataSource {
  Future<FullTasksetModel> getFullTaskset();
}

const kGamePath = 'assets/game/game.json';

class LocalDataSourceImpl implements LocalDataSource {
  @override
  Future<FullTasksetModel> getFullTaskset() async {
    var json = await rootBundle.loadString(kGamePath);
    return Future.value(FullTasksetModel.fromJson(jsonDecode(json)));
  }
}