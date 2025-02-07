
import 'package:hive/hive.dart';
import 'package:lista_facil/data/services/i_database_service.dart';

class HiveService implements IDatabaseService{
  late Box _box;
  
  @override
  Future<void> init() async{
    Hive.init("hive_database");
    _box = await Hive.openBox("app_data");
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async{
    await _box.put(data["id"], data);
    return 1;
  }

  @override
  Future<int> update(String table, Map<String, dynamic> data, String column, value) async{
    await _box.put(value, data);
    return 1;
  }

  @override
  Future<int> delet(String table, String coloumn, value) async{
    await _box.delete(value);
    return 1;
  }

  @override
  Future<List<Map<String, dynamic>>> queryAll(String table) async{
    return _box.values.cast<Map<String, dynamic>>().toList();
  }

  @override
  Future<List<Map<String, dynamic>>> queryBy(String table, String column, value) async{
    final result = _box.get(value);
    return result != null ? [result] : [];
  }

}