import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:math_game_crossplatform/data/models/taskset_model.dart';

abstract class AssetDataSource {
  Future<FullTasksetModel> getFullTaskset();
}

const kGamePath = 'assets/game/game.json';

class AssetDataSourceImpl implements AssetDataSource {
  @override
  Future<FullTasksetModel> getFullTaskset() async {
    var json = await rootBundle.loadString(kGamePath);
    return Future.value(FullTasksetModel.fromJson(jsonDecode(json)));
  }
}