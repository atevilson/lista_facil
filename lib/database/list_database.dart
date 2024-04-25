import 'package:my_app/database/dao/create_list_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDataBase() async {
  final String path = join(await getDatabasesPath(), 'lista_facil2.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute(ListsDao.tableSQL);
  }, version: 1);
}
