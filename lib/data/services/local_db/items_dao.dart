import 'package:lista_facil/data/services/local_db/lists_dao.dart';
import 'package:lista_facil/data/services/local_db/app_database.dart';
import 'package:lista_facil/domain/models/items.dart';
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

  Future<int> save(Items items) async {
    final Database db = await getDataBase();
    return _toMap(items, db);
  }

  Future<int> delete(Items items) async {
    final Database db = await getDataBase();
    return _toMapDelete(items, db);
  }

  Future<int> _toMap(Items items, Database db) {
    return _toInsert(items, db);
  }

  Future<int> _toMapDelete(Items items, Database db) {
    return _toDelete(items, db);
  }

  Future<int> _toInsert(Items items, Database db) {
    final Map<String, dynamic> newItem = {};
    newItem[id] = items.id;
    newItem[item] = items.items;
    newItem[quantity] = items.quantity;
    newItem[price] = items.price;
    newItem[listId] = items.listId;
    newItem[createAt] = items.createdAt ?? DateTime.now().toIso8601String();
    return db.insert(nameTable, newItem);
  }

  Future<int> _toDelete(Items items, Database db) {
    return db.delete(
      nameTable,
      where: "$id = ?",
      whereArgs: [items.id]
    );
  }

  Future<List<Items>> findAll() async {
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> result = await db.query(nameTable);
    final List<Items> items = [];
    for (Map<String, dynamic> row in result) {
      final Items newItem = Items(
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

  Future<List<Items>> findByListId(int value) async {
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> result =
        await db.query(nameTable, where: " $listId = $value");
    final List<Items> items = [];
    for (Map<String, dynamic> row in result) {
      final Items newItem = Items(
          id: row[id],
          items: row[item],
          quantity: row[quantity],
          price: row[price],
          listId: row[listId]);
      items.add(newItem);
    }
    return items;
  }

  Future<int> updateItem(Items items) async {
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
