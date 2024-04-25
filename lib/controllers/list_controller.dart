import 'package:flutter/material.dart';
import 'package:my_app/database/dao/create_list_dao.dart';
import 'package:my_app/models/new_lists.dart';

class ListController {
  final ListsDao _listsDao = ListsDao();
  final ValueNotifier<List<NewLists>> listaValores =
      ValueNotifier<List<NewLists>>([]);

  Future<void> findAll() async {
    listaValores.value = [];
    listaValores.value = await _listsDao.findAll();
  }

  Future<bool> saveList(String value) async {
    if (value.isNotEmpty) {
      final NewLists newLists = NewLists(0, value);
      await _listsDao.save(newLists);
      await findAll();
      return true;
    }
    return false;
  }
}
