import 'package:my_app/database/list_database.dart';
import 'package:my_app/models/new_lists.dart';
import 'package:sqflite/sqflite.dart';

class ListsDao {
  static const String _nameTable = 'new_lists';
  static const String _id = 'id';
  static const String _name = 'name';

  static const String tableSQL = 'CREATE TABLE $_nameTable('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT )';

  Future<int> save(NewLists listas) async {
    final Database db = await getDataBase();
    return _toMap(listas, db);
  }

  Future<int> _toMap(NewLists listas, Database db) {
    return _toList(listas, db);
  }

  Future<int> _toList(NewLists listas, Database db) {
    final Map<String, dynamic> newLists = {};
    newLists[_name] = listas.nameList;
    return db.insert(_nameTable, newLists);
  }

  Future<List<NewLists>> findAll() async {
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> result = await db.query(_nameTable);
    final List<NewLists> lists = [];
    for (Map<String, dynamic> row in result) {
      final NewLists listNew = NewLists(
        row[_id],
        row[_name],
      );
      lists.add(listNew);
    }
    return lists;
  }
}
