import 'package:lista_facil/data/services/local_db/items_dao.dart';
import 'package:lista_facil/data/services/local_db/lists_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDataBase() async {
  final String path = join(await  getDatabasesPath(), 'lista_facil1.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute(ListsDao.tableSQL);
    db.execute(ItemsDao.tableSQLitens);
  }, version: 1);
}