import 'package:flutter/material.dart';
import 'package:my_app/database/dao/create_itens_dao.dart';
import 'package:my_app/models/new_items.dart';


class ItemController {
  final ItemsDao _listsDao = ItemsDao();
  final ValueNotifier<List<NewItems>> quantityItems =
      ValueNotifier<List<NewItems>>([]);

  Future<List<NewItems>> findAll() async {
    quantityItems.value = [];
    return await _listsDao.findAll();
  }

  Future<bool> saveList(String value) async {
    if (value.isNotEmpty) {
      final NewItems newItens = NewItems(0, value, 0);
      await _listsDao.save(newItens);
      await findAll();
      return true;
    }
    return false;
  }
}
