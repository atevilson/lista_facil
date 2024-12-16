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

  Future<List<NewLists>> searchListsByName(String query) async {
    if(query.isEmpty){
      return listaValores.value;
    }else{
    return listaValores.value.where((local) => local.nameList.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  Future<void> updateList(NewLists list) async {
    await _listsDao.updateList(list);
    await _prefs.setBool('bookmark_${list.id}', list.bookMarked);
    await findAll();
  }

  Future<void> setListMarked(int listId, bool isListMarked) async {
    await _prefs.setBool('bookmark_$listId', isListMarked);
    int index = listaValores.value.indexWhere((list) => list.id == listId);
    if(index != -1){
      listaValores.value[index].bookMarked = isListMarked;
    }
  }

  Future<bool> getBookMarked(int listId) async {
    return _prefs.getBool('bookmark_$listId') ?? false;
  }

  void sortItems(bool ascending) async {
    _ascendingOrder = ascending;
    await _prefs.setBool('ascendingOrder', ascending);

    List<NewLists> lists = List<NewLists>.from(listaValores.value);
    _sortItemsInternal(lists);
    listaValores.value = lists;
    notifyListeners();
  }

  void _sortItemsInternal(List<NewLists> items) {
    items.sort((a, b) {
      String firstCharA = a.nameList.isNotEmpty ? a.nameList[0].toLowerCase() : '';
      String firstCharB = b.nameList.isNotEmpty ? b.nameList[0].toLowerCase() : '';

      int comparison = firstCharA.compareTo(firstCharB);
      return _ascendingOrder ? comparison : -comparison;
      },
    );
  }
}
