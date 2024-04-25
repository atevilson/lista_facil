import 'package:my_app/database/list_database.dart';
import 'package:my_app/models/new_lists.dart';
import 'package:sqflite/sqflite.dart';

class ListsDao {
  Future<int> save(NewLists listas) async {
    final Database db = await getDataBase();
    final Map<String, dynamic> newLists = {};
    newLists['name'] = listas.nameList;
    return db.insert('new_lists', newLists);
  }

  Future<List<NewLists>> findAll() async {
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> result = await db.query('new_lists');
    final List<NewLists> lists = [];
    for (Map<String, dynamic> row in result) {
      final NewLists listNew = NewLists(
        row['id'],
        row['name'],
      );
      lists.add(listNew);
    }
    return lists;
  }
}
