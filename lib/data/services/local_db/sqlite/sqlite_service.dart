
import 'package:lista_facil/data/services/i_database_service.dart';
import 'package:lista_facil/data/services/local_db/items_dao.dart';
import 'package:lista_facil/data/services/local_db/lists_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService implements IDatabaseService {
  Database? _database;

  @override
  Future<void> init() async{
    final String path = join(await getDatabasesPath(), "lista_facil.db");
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(ListsDao.tableSQL);
      db.execute(ItemsDao.tableSQLitens);
    });
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async{
    return await _database!.insert(table, data);
  }

  @override
  Future<int> update(String table, Map<String, dynamic> data, String column, value) async{
    return await _database!.update(table, data, where: "$column = ?", whereArgs: [value]);
  }

  @override
  Future<int> delet(String table, String coloumn, value) async{
    return await _database!.delete(table, where: "$coloumn = ?", whereArgs: [value]);
  }

  @override
  Future<List<Map<String, dynamic>>> queryAll(String table) async{
    return await _database!.query(table);
  }

  @override
  Future<List<Map<String, dynamic>>> queryBy(String table, String column, value) async{
    return  await _database!.query(table, where: "$column = ?", whereArgs: [value]);
  }

}