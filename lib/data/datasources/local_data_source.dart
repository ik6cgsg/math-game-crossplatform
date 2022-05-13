import 'package:math_game_crossplatform/core/logger.dart';
import 'package:math_game_crossplatform/data/models/result_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDataSource {
  Future<void> saveLevelResult(ResultModel result);
  Future<List<ResultModel>> loadAllResults();
  Future<ResultModel> loadResultFor(String code);
}

const kStorageDBName = 'local_storage.db';
const kResultTable = 'results';

class LocalDataSourceImpl implements LocalDataSource {
  Future<Database> _database() async {
    return await openDatabase(
      join(await getDatabasesPath(), kStorageDBName),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $kResultTable(
              task_code TEXT PRIMARY KEY, 
              expression TEXT, 
              step_count INTEGER,
              state TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  @override
  Future<void> saveLevelResult(ResultModel result) async {
    log.info('LocalDataSourceImpl::saveLevelResult($result)');
    final db = await _database();
    await db.execute(
      '''
      REPLACE INTO $kResultTable (task_code, expression, step_count, state) VALUES (?,?,?,?)
      ''',
      [result.taskCode, result.expression, result.stepCount, result.state.toString()]
    );
  }

  @override
  Future<List<ResultModel>> loadAllResults() async {
    log.info('LocalDataSourceImpl::loadAllResults()');
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(kResultTable);
    log.info('LocalDataSourceImpl::loadAllResults: query res = $maps');
    return List.generate(maps.length, (i) {
      return ResultModel(
        maps[i]['task_code'],
        maps[i]['expression'],
        maps[i]['step_count'],
        maps[i]['state']
      );
    });
  }

  @override
  Future<ResultModel> loadResultFor(String code) async {
    log.info('LocalDataSourceImpl::loadResultFor($code)');
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(kResultTable, where: 'task_code = ?', whereArgs: [code]);
    log.info('LocalDataSourceImpl::loadResultFor: query res = $maps');
    return ResultModel(
        maps[0]['task_code'],
        maps[0]['expression'],
        maps[0]['step_count'],
        maps[0]['state']
    );
  }
}