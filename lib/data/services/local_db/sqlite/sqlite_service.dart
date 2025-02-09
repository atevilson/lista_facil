
import 'package:lista_facil/data/services/i_database_service.dart';
import 'package:lista_facil/data/services/local_db/items_dao.dart';
import 'package:lista_facil/data/services/local_db/lists_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService implements IDatabaseService {
  Database? _database;

  @override
  Future<Database> init() async{
    if(_database != null) return _database!;
    final String path = join(await getDatabasesPath(), 'lista_facil1.db');
     _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(ListsDao.tableSQL);
      db.execute(ItemsDao.tableSQLitens);
    });
    return _database!;
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async{
    final Database db = await init();
    return db.insert(table, data); 
  }

  @override
  Future<int> update(String table, Map<String, dynamic> data, String column, value) async{
    final Database db = await init();
    return db.update(table, data, where: "$column = ?", whereArgs: [value]);
  }

  @override
  Future<int> delet(String table, String coloumn, value) async{
    final Database db = await init();
    return db.delete(table, where: "$coloumn = ?", whereArgs: [value]);
  }

  @override
  Future<List<Map<String, dynamic>>> queryAll(String table) async{
    final Database db = await init();
    return db.query(table);
  }

  @override
  Future<List<Map<String, dynamic>>> queryBy(String table, String column, value) async{
    final Database db = await init();
    return db.query(table, where: "$column = ?", whereArgs: [value]);
  }

}