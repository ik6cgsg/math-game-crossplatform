import 'package:math_game_crossplatform/data/models/result_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDataSource {
  Future<void> saveLevelResult(ResultModel result);
  Future<List<ResultModel>> loadAllResults();
  Future<ResultModel> loadResultFor(int i);
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
              level_index INTEGER PRIMARY KEY, 
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
    final db = await _database();
    await db.execute(
      '''
      REPLACE INTO $kResultTable (level_index, expression, step_count, state) VALUES (?,?,?,?)
      ''',
      [result.levelIndex, result.expression, result.stepCount, result.state]
    );
  }

  @override
  Future<List<ResultModel>> loadAllResults() async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(kResultTable);
    return List.generate(maps.length, (i) {
      return ResultModel(
        maps[i]['level_index'],
        maps[i]['expression'],
        maps[i]['step_count'],
        maps[i]['state']
      );
    });
  }

  @override
  Future<ResultModel> loadResultFor(int i) async {
    final db = await _database();
    final List<Map<String, dynamic>> maps = await db.query(kResultTable, where: 'level_index = ?', whereArgs: [i]);
    return ResultModel(
        maps[0]['level_index'],
        maps[0]['expression'],
        maps[0]['step_count'],
        maps[0]['state']
    );
  }
}