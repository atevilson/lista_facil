import 'package:my_app/database/dao/create_list_dao.dart';
import 'package:my_app/database/list_database.dart';
import 'package:my_app/models/new_items.dart';
import 'package:sqflite/sqflite.dart';

class ItemsDao {
  static const String nameTable = 'new_itens';
  static const String id = 'id';
  static const String item = 'item';
  static const String quantity = 'quantity';
  static const String listId = 'list_id';

  static const String tableSQLitens = 'CREATE TABLE $nameTable('
      '$id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$item TEXT,'
      '$quantity INTEGER,'
      '$listId INTEGER,'
      'FOREIGN KEY ($listId) REFERENCES ${ListsDao.nameTable} (${ListsDao.id}))';

  Future<int> save(NewItems items) async {
    final Database db = await getDataBase();
    return _toMap(items, db);
  }

  Future<int> _toMap(NewItems items, Database db) {
    return _toList(items, db);
  }

  Future<int> _toList(NewItems items, Database db) {
    final Map<String, dynamic> newItem = {};
    newItem[id] = items.id;
    newItem[item] = items.items;
    newItem[quantity] = items.quantity;
    newItem[listId] = items.listId;
    return db.insert(nameTable, newItem);
  }

  Future<List<NewItems>> findAll() async {
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> result = await db.query(nameTable);
    final List<NewItems> items = [];
    for (Map<String, dynamic> row in result) {
      final NewItems newItem = NewItems(
          id: row[id],
          items: row[item],
          quantity: row[quantity],
          listId: row[listId]);
      items.add(newItem);
    }
    return items;
  }

  Future<List<NewItems>> findByListId(int value) async {
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> result =
        await db.query(nameTable, where: " $listId = $value");
    final List<NewItems> items = [];
    for (Map<String, dynamic> row in result) {
      final NewItems newItem = NewItems(
          id: row[id],
          items: row[item],
          quantity: row[quantity],
          listId: row[listId]);
      items.add(newItem);
    }
    return items;
  }
}
