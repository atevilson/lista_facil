import 'package:lista_facil/database/dao/create_list_dao.dart';
import 'package:lista_facil/database/list_database.dart';
import 'package:lista_facil/models/new_items.dart';
import 'package:sqflite/sqflite.dart';

class ItemsDao {
  static const String nameTable = 'new_itens';
  static const String id = 'id';
  static const String item = 'item';
  static const String quantity = 'quantity';
  static const String listId = 'list_id';
  static const String price = 'price';
  static const String createAt = 'createdAt';

  static const String tableSQLitens = 'CREATE TABLE $nameTable('
      '$id INTEGER PRIMARY KEY AUTOINCREMENT, '
      '$item TEXT, '
      '$quantity INTEGER, '
      '$price REAL, '
      '$listId INTEGER, '
      '$createAt TEXT, '
      'FOREIGN KEY ($listId) REFERENCES ${ListsDao.nameTable} (${ListsDao.id}))';

  Future<int> save(NewItems items) async {
    final Database db = await getDataBase();
    return _toMap(items, db);
  }

  Future<int> delete(NewItems items) async {
    final Database db = await getDataBase();
    return _toMapDelete(items, db);
  }

  Future<int> _toMap(NewItems items, Database db) {
    return _toInsert(items, db);
  }

  Future<int> _toMapDelete(NewItems items, Database db) {
    return _toDelete(items, db);
  }

  Future<int> _toInsert(NewItems items, Database db) {
    final Map<String, dynamic> newItem = {};
    newItem[id] = items.id;
    newItem[item] = items.items;
    newItem[quantity] = items.quantity;
    newItem[price] = items.price;
    newItem[listId] = items.listId;
    newItem[createAt] = items.createdAt ?? DateTime.now().toIso8601String();
    return db.insert(nameTable, newItem);
  }

  Future<int> _toDelete(NewItems items, Database db) {
    return db.delete(
      nameTable,
      where: "$id = ?",
      whereArgs: [items.id]
    );
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
          price: row[price],
          listId: row[listId],
          createdAt: row[createAt]);
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
          price: row[price],
          listId: row[listId]);
      items.add(newItem);
    }
    return items;
  }

  Future<int> updateItem(NewItems items) async {
    final Database db = await getDataBase();
    return db.update(
      nameTable, {
        item: items.items, 
        quantity: items.quantity,
        price: items.price,
        },
        where: "$id = ?",
      whereArgs: [items.id],
    );
  }
}
