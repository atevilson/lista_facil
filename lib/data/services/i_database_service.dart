
abstract class IDatabaseService {
  Future<void> init();
  Future<int> insert(String table, Map<String, dynamic> data);
  Future<int> delet(String table, String coloumn, dynamic value);
  Future<int> update(String table, Map<String, dynamic> data, String column, dynamic value);
  Future<List<Map<String, dynamic>>> queryAll(String table);
  Future<List<Map<String, dynamic>>> queryBy(String table, String column, dynamic value);
}