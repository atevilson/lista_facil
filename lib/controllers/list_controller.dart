import 'package:flutter/material.dart';
import 'package:lista_facil/database/dao/create_list_dao.dart';
import 'package:lista_facil/models/new_lists.dart';

class ListController {
  final ListsDao _listsDao = ListsDao();
  final ValueNotifier<List<NewLists>> listaValores =
      ValueNotifier<List<NewLists>>([]);

  bool _ascendingOrder = true; // ordenação default
  bool get isAscending => _ascendingOrder;

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await findAll();
  }

  Future<void> findAll() async {
    listaValores.value = [];
    listaValores.value = await _listsDao.findAll();
  }

  Future<void> deleteItem(NewLists value) async {
    await _listsDao.delete(value);
    await findAll();
  }

  Future<bool> saveList(String value, double budget) async {
    if (value.isNotEmpty) {
      final NewLists newLists = NewLists(0, value, budget);
      await _listsDao.save(newLists);
      await findAll();
      return true;
    }
    return false;
  }

  Future<List<NewLists>> searchListsByName(String name) {
    return _listsDao.findByListsName(name);
  }

  Future<void> updateList(NewLists list) async {
    await _listsDao.updateList(list);
    await findAll();
  }
}
