import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lista_facil/data/services/i_database_service.dart';

class SharedPreferencesService implements IDatabaseService {
  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  @override
  Future<void> init() async{
    await _prefs;
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> data) async{
    final prefs = await _prefs;
    final List<String> storedLists = prefs.getStringList(table) ?? [];
    data['id'] = storedLists.length + 1;
    storedLists.add(jsonEncode(data));
    await prefs.setStringList(table, storedLists);
    return data['id'];
  }

  @override
  Future<int> update(String table, Map<String, dynamic> data, String column, dynamic value) async{
    final prefs = await _prefs;
    final List<String> storedLists = prefs.getStringList(table) ?? [];
    List<Map<String, dynamic>> decodedData = storedLists
        .map<Map<String, dynamic>>((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();

    for (var item in decodedData){
      if (item[column] == value){
        item.addAll(data);
        break;
      }
    }
    await prefs.setStringList(table, decodedData.map((e) => jsonEncode(e)).toList());
    return 1;
  }

  @override
  Future<int> delet(String table, String column, dynamic value) async{
    final prefs = await _prefs;
    final List<String> storedLists = prefs.getStringList(table) ?? [];
    List<Map<String, dynamic>> decodedData = storedLists
        .map<Map<String, dynamic>>((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
    decodedData.removeWhere((item) => item[column] == value);
    await prefs.setStringList(table, decodedData.map((e) => jsonEncode(e)).toList());
    return 1;
  }

  @override
  Future<List<Map<String, dynamic>>> queryAll(String table) async{
    final prefs = await _prefs;
    final List<String> storedLists = prefs.getStringList(table) ?? [];
    return storedLists
        .map<Map<String, dynamic>>((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> queryBy(String table, String column, dynamic value) async{
    final List<Map<String, dynamic>> allData = await queryAll(table);
    return allData.where((item) => item[column] == value).toList();
  }
}
