import 'package:lista_facil/data/services/i_database_service.dart';
import 'package:lista_facil/data/services/local_db/app_database_factory.dart';
import 'package:lista_facil/data/services/local_db/lists_dao.dart';
import 'package:lista_facil/domain/models/items.dart';

class ItemsDao {
  final IDatabaseService _dbService = AppDatabaseFactory.getDatabaseService();

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
    return await _dbService.insert(nameTable, {
      id: items.id,
      item: items.items,
      quantity: items.quantity,
      price: items.price,
      listId: items.listId,
      createAt: items.createdAt ?? DateTime.now().toIso8601String(),
    });
  }

  Future<int> delete(Items items) async {
    return await _dbService.delet(nameTable, id, items.id);
  }

  Future<List<Items>> findAll() async {
    final List<Map<String, dynamic>> result = await _dbService.queryAll(nameTable);
    return result.map((row) => Items(
          id: row[id],
          items: row[item],
          quantity: row[quantity],
          price: row[price],
          listId: row[listId],
          createdAt: row[createAt],
          )).toList();
  }

  Future<List<Items>> findByListId(int value) async {
    final List<Map<String, dynamic>> result = await _dbService.queryBy(nameTable, listId, value);
      return result.map((row) => Items(
          id: row[id],
          items: row[item],
          quantity: row[quantity],
          price: row[price],
          listId: row[listId],
          createdAt: row[createAt],
    )).toList();
  }

  Future<int> updateItem(Items items) async {
    return await _dbService.update(nameTable, {
      item: items.items,
      quantity: items.quantity,
      price: items.price,
    }, id, items.id);
  }
}