import 'package:flutter/services.dart';
import 'package:math_game_crossplatform/core/exceptions.dart';

import '../../core/logger.dart';
import '../models/platform_models.dart';
import '../models/rule_model.dart';

abstract class PlatformDataSource {
  Future<void> compileConfiguration(CompileInput input);
  Future<String> resolveExpression(ResolutionInput input);
  Future<NodeSelectionInfoModel> getNodeByTouch(PointModel tap);
  Future<SubstitutionInfoModel> getSubstitutionInfo(List<int> nodeIds);
  Future<bool> checkEnd(CheckEndInput input);
}

const MethodChannel kChannel = MethodChannel('mathhelper.games.crossplatform/math_util');

class PlatformDataSourceImpl implements PlatformDataSource {
  @override
  Future<void> compileConfiguration(CompileInput input) async {
    log.info('compileConfiguration(); size == ${input.rules.length}');
    log.info('compileConfiguration(); additional params == ${input.additionalParams}');
    await kChannel.invokeMethod('compileConfiguration', input.toJson());
  }

  @override
  Future<String> resolveExpression(ResolutionInput input) async {
    log.info('resolveExpression($input)');
    final res = await kChannel.invokeMethod<String>('resolveExpression', input.toJson());
    if (res == null) throw LocalPlatformException();
    return res;
  }

  @override
  Future<NodeSelectionInfoModel> getNodeByTouch(PointModel tap) async {
    log.info('getNodeByTouch($tap)');
    final invokeRes = await kChannel.invokeMapMethod('getNodeByTouch', tap.toJson());
    final map = invokeRes?.cast<String, dynamic>();
    if (map == null) throw LocalPlatformException();
    return NodeSelectionInfoModel.fromJson(map);
  }

  @override
  Future<SubstitutionInfoModel> getSubstitutionInfo(List<int> nodeIds) async {
    log.info('getSubstitutionInfo($nodeIds)');
    var invokeRes = await kChannel.invokeMapMethod('getSubstitutionInfo', <String, dynamic>{
      'ids': nodeIds
    });
    var map = invokeRes?.cast<String, dynamic>();
    if (map == null) throw LocalPlatformException();
    return SubstitutionInfoModel.fromJson(map);
  }

  @override
  Future<bool> checkEnd(CheckEndInput input) async {
    log.info('checkEnd($input)');
    final res = await kChannel.invokeMethod<bool>('checkEnd', input.toJson());
    if (res == null) throw LocalPlatformException();
    return res;
  }
}