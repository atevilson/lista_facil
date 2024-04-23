import 'package:my_app/models/new_lists.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> createDataBase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'lista_facil2.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute('CREATE TABLE new_lists('
          'id INTEGER PRIMARY KEY, '
          'name TEXT )');
    }, version: 1);
  });
}

Future<int> save(NewLists listas) {
  return createDataBase().then((db) {
    final Map<String, dynamic> newLists = {};
    //newLists['id'] = listas.id;
    newLists['name'] = listas.nameList;
    return db.insert('new_lists', newLists);
  });
}

Future<List<NewLists>> findAll() {
  return createDataBase().then(
    (db) => db.query('new_lists').then((maps) {
      final List<NewLists> lists = [];
      for (Map<String, dynamic> map in maps) {
        final NewLists listNew = NewLists(
          map['id'],
          map['name'],
        );
        lists.add(listNew);
      }
      return lists;
    }),
  );
}
