import 'package:my_app/database/list_database.dart';
import 'package:my_app/models/new_items.dart';
import 'package:sqflite/sqflite.dart';

class ItemsDao {
  static const String _nameTable = 'new_itens';
  static const String _id = 'id';
  static const String _item = 'item';
  static const String _quantity = 'quantity';

  static const String tableSQLitens = 'CREATE TABLE $_nameTable('
      '$_id INTEGER PRIMARY KEY, '
      '$_item TEXT,'
      '$_quantity INTEGER )';

  Future<int> save(NewItems items) async {
    final Database db = await getDataBase();
    return _toMap(items, db);
  }

  Future<int> _toMap(NewItems items, Database db) {
    return _toList(items, db);
  }

  Future<int> _toList(NewItems items, Database db) {
    final Map<String, dynamic> newItem = {};
    newItem[_id] = items.id;
    newItem[_item] = items.items;
    newItem[_quantity] = items.quantity;
    return db.insert(_nameTable, newItem);
  }

  Future<List<NewItems>> findAll() async {
    final Database db = await getDataBase();
    final List<Map<String, dynamic>> result = await db.query(_nameTable);
    final List<NewItems> items = [];
    for (Map<String, dynamic> row in result) {
      final NewItems newItem = NewItems(
        row[_id],
        row[_item],
        row[_quantity]
      );
      items.add(newItem);
    }
    return items;
  }
}
