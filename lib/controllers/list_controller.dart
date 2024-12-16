import 'package:flutter/material.dart';
import 'package:lista_facil/database/dao/create_list_dao.dart';
import 'package:lista_facil/models/new_lists.dart';

class ListController extends ChangeNotifier {
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
    List<NewLists> lists = await _listsDao.findAll();
    for(NewLists list in lists) {
      list.bookMarked = _prefs.getBool('bookmark_${list.id}') ?? false;
    }
    listaValores.value = lists;
  }

  Future<void> deleteList(NewLists value) async {
    await _listsDao.deleteLists(value);
    await _prefs.remove('bookmark_${value.id}');
    await findAll();
  }

  Future<bool> saveList(String value, double budget) async {
    if (value.isNotEmpty) {
      final NewLists newLists = NewLists(0, value, budget);
      await _listsDao.save(newLists);
      await _prefs.setBool('bookmark_${newLists.id}', false);
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
