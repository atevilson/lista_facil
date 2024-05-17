import 'package:my_app/database/dao/create_itens_dao.dart';
import 'package:my_app/database/dao/create_list_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDataBase() async {
  final String path = join(await  getDatabasesPath(), 'lista_facil.db');
  return openDatabase(path, onCreate: (db, version) {
    db.execute(ListsDao.tableSQL);
    db.execute(ItemsDao.tableSQLitens);
  }, version: 1);
}

// Coloquei para validar a lista de itens, REMOVER APÓS OS TESTES!!!!
Future<void> listarItens() async {
  final Database db = await getDataBase();
  final List<Map<String, dynamic>> result = await db.query('new_itens');
  if (result.isNotEmpty) {
    print("Itens na tabela 'new_itens':");
    for (Map<String, dynamic> row in result) {
      print(
          "ID: ${row['id']}, Nome do Item: ${row['item']}, Quantidade: ${row['quantity']}, list_id: ${row['list_id']}");
    }
  } else {
    print("Nenhum item encontrado na tabela 'new_itens'.");
  }
}

Future<void> listarListas() async {
  final Database db = await getDataBase();
  final List<Map<String, dynamic>> result1 = await db.query('new_lists');
  if (result1.isNotEmpty) {
    print("Lista na tabela 'new_lists':");
    for (Map<String, dynamic> row in result1) {
      print("ID: ${row['id']}, Lista: ${row['name']}");
    }
  } else {
    print("Nenhuma lista encontrada na tabela 'new_lists'.");
  }
}