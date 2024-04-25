import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDataBase() async {
  final String path = join(await getDatabasesPath(), 'lista_facil2.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute('CREATE TABLE new_lists('
        'id INTEGER PRIMARY KEY, '
        'name TEXT )');
  }, version: 1);
}
