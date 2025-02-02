import 'package:lista_facil/data/services/local_db/items_dao.dart';
import 'package:lista_facil/data/services/local_db/app_database.dart';
import 'package:lista_facil/domain/models/lists.dart';
import 'package:sqflite/sqflite.dart';

class ListsDao {
  static const String nameTable = 'new_lists';
  static const String id = 'id';
  static const String name = 'name';
  static const String budget = 'budget';
  static const String createdAt = 'createdAt';

  static const String tableSQL = 'CREATE TABLE $nameTable('
      '$id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$name TEXT, '
      '$budget REAL, '
      '$createdAt TEXT)';

  Future<int> save(Lists listas) async {
    final Database db = await getDataBase();
    return _toMap(listas, db);
  }

  Future<int> deleteLists(Lists listas) async {
    final Database db = await getDataBase();
    return _toMapDelete(listas, db);
  }

  Future<int> _toMapDelete(Lists listas, Database db) {
    return _toDelete(listas, db);
  }


  Future<int> _toMap(Lists listas, Database db) {
    return _toList(listas, db);
  }
  // métdo ajustado para que ao excluir a lista remova primeiro seus itens.
  Future<int> _toDelete(Lists listas, Database db) async {
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

  Future<int> _toList(Lists listas, Database db) {
    final Map<String, dynamic> newLists = {};
    newLists[name] = listas.nameList;
    newLists[budget] = listas.budget;
    newLists[createdAt] = (listas.createdAt == null || listas.createdAt!.isEmpty) ? DateTime.now().toIso8601String() :
    listas.createdAt;
    return db.insert(nameTable, newLists);
  }

  Future<List<Lists>> findAll() async {
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> result = await db.query(nameTable);
    final List<Lists> lists = [];
    for (Map<String, dynamic> row in result) {
      final Lists listNew = Lists(
        row[id],
        row[name],
        row[budget],
        row[createdAt],
      );
      lists.add(listNew);
    }
    return lists;
  }

  Future<int> updateList(Lists list) async {
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
