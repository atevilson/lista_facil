import 'package:lista_facil/data/services/i_database_service.dart';
import 'package:lista_facil/data/services/local_db/items_dao.dart';
import 'package:lista_facil/domain/models/lists.dart';
import 'package:lista_facil/data/services/local_db/app_database_factory.dart';

class ListsDao {
  final IDatabaseService _dbService = AppDatabaseFactory.getDatabaseService();

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

  Future<int> save(Lists lists) async {
    return await _dbService.insert(nameTable, {
      name: lists.nameList,
      budget: lists.budget,
      createdAt: (lists.createdAt == null || lists.createdAt!.isEmpty) ? DateTime.now().toIso8601String() :
      lists.createdAt,
    });
  }

  Future<int> deleteLists(Lists lists) async {
    await _dbService.delet(ItemsDao.nameTable, ItemsDao.listId, lists.id);
    return await _dbService.delet(nameTable, id, lists.id);
  }


  Future<List<Lists>> findAll() async {
    final List<Map<String, dynamic>> result = await _dbService.queryAll(nameTable);
      return result.map((row) => Lists(
        row[id],
        row[name],
        row[budget],
        row[createdAt],
      )).toList();
  }

  Future<int> updateList(Lists lists) async {
    return await _dbService.update(
      nameTable, {
        name: lists.nameList, 
        budget: lists.budget
        },id, lists.id,
    );
  } 
}
