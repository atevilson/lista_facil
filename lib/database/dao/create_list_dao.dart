import 'package:lista_facil/database/dao/create_itens_dao.dart';
import 'package:lista_facil/database/list_database.dart';
import 'package:lista_facil/models/new_lists.dart';
import 'package:sqflite/sqflite.dart';

class ListsDao {
  static const String nameTable = 'new_lists';
  static const String id = 'id';
  static const String name = 'name';
  static const String budget = 'budget';

  static const String tableSQL = 'CREATE TABLE $nameTable('
      '$id INTEGER PRIMARY KEY, '
      '$name TEXT, '
      '$budget REAL)';

  Future<int> save(NewLists listas) async {
    final Database db = await getDataBase();
    return _toMap(listas, db);
  }

  Future<int> deleteLists(NewLists listas) async {
    final Database db = await getDataBase();
    return _toMapDelete(listas, db);
  }

  Future<int> _toMapDelete(NewLists listas, Database db) {
    return _toDelete(listas, db);
  }


  Future<int> _toMap(NewLists listas, Database db) {
    return _toList(listas, db);
  }
  // métdo ajustado para que ao excluir a lista remova primeiro seus itens.
  Future<int> _toDelete(NewLists listas, Database db) async {
    return await db.transaction((transaction) async {
      transaction.delete(
        ItemsDao.nameTable,
        where: "${ItemsDao.listId} = ?",
        whereArgs: [listas.id]
      );

      return await transaction.delete(
        nameTable,
        where: "$id = ?",
        whereArgs: [listas.id],
      );    
    });
  }

  Future<int> _toList(NewLists listas, Database db) {
    final Map<String, dynamic> newLists = {};
    newLists[name] = listas.nameList;
    newLists[budget] = listas.budget;
    return db.insert(nameTable, newLists);
  }

  Future<List<NewLists>> findAll() async {
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> result = await db.query(nameTable);
    final List<NewLists> lists = [];
    for (Map<String, dynamic> row in result) {
      final NewLists listNew = NewLists(
        row[id],
        row[name],
        row[budget]
      );
      lists.add(listNew);
    }
    return lists;
  }

  Future<int> updateList(NewLists list) async {
    final Database db = await getDataBase();
    return db.update(
      nameTable, {
        name: list.nameList, 
        budget: list.budget
        },
      where: "$id = ?",
      whereArgs: [list.id],
    );
  } 
}
