import 'package:flutter/material.dart';
import 'package:my_app/database/dao/create_itens_dao.dart';
import 'package:my_app/models/new_items.dart';
import 'package:my_app/models/new_lists.dart';

class ItemController {
  final NewLists newLists;
  final ItemsDao _listsDao = ItemsDao();
  final ValueNotifier<List<NewItems>> quantityItems =
      ValueNotifier<List<NewItems>>([]);
  ItemController(this.newLists);
  Future<List<NewItems>> findItens() async {
    quantityItems.value = [];
    return await _listsDao.findByListId(this.newLists.id);
  }

  Future<bool> saveItem(NewItems value) async {
    final NewItems newItens = NewItems(
        listId: newLists.id, items: value.items, quantity: value.quantity);
    await _listsDao.save(newItens);
    await findItens();
    return true;
  }
}
