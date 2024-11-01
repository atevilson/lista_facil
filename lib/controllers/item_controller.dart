import 'package:flutter/material.dart';
import 'package:lista_facil/database/dao/create_itens_dao.dart';
import 'package:lista_facil/models/new_items.dart';
import 'package:lista_facil/models/new_lists.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemController extends ChangeNotifier {
  final NewLists newLists;
  final ItemsDao _listsDao = ItemsDao();
  final ValueNotifier<List<NewItems>> quantityItems = ValueNotifier<List<NewItems>>([]);
  bool _ascendingOrder = true; // ordenação default
  final ValueNotifier<double> total = ValueNotifier<double>(0.0);

  ItemController(this.newLists) {
    _loadListItems();
    _loadTotalSpent();
  }

  Future<void> _loadListItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ascendingOrder = prefs.getBool('ascendingOrder') ?? true;

    List<NewItems> items = await _listsDao.findByListId(newLists.id);
    _sortItemsInternal(items);

    for (NewItems item in items) {
    item.isChecked = await loadCheckboxState(item.id!);
  }
    
    quantityItems.value = items;
  }

  Future<void> _saveTotal() async {
  SharedPreferences prefs =await SharedPreferences.getInstance();
  await prefs.setDouble('total_spent_${newLists.id}', total.value); 
}

Future<void> _loadTotalSpent() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  total.value = prefs.getDouble('total_spent_${newLists.id}') ?? 0.0;
  notifyListeners();
}

  Future<void> findItens() async {
    await _loadListItems();
  }

  Future<bool> saveItem(NewItems value) async {
    final NewItems newItens = NewItems(
        listId: newLists.id, items: value.items, quantity: value.quantity, price: value.price);
    await _listsDao.save(newItens);
    await _loadListItems();
    return true;
  }

  Future<bool> deleteItem(NewItems value) async {
    if(value.id != null && await loadCheckboxState(value.id!)) { // valida se o item está marcado antes de deletar
      total.value -= value.price! * value.quantity;
      total.value = double.parse(total.value.toStringAsFixed(2));

      await _saveTotal();

      notifyListeners();
    }

    await _listsDao.delete(value);

    await _loadListItems();

    return true;
  }

  void sortItems(bool ascending) async {
    _ascendingOrder = ascending;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ascendingOrder', ascending);

    List<NewItems> items = List<NewItems>.from(quantityItems.value);
    _sortItemsInternal(items);
    quantityItems.value = items;
  }

  void _sortItemsInternal(List<NewItems> items) {
    items.sort((a, b) {
      String firstCharA = a.items.isNotEmpty ? a.items[0].toLowerCase() : '';
      String firstCharB = b.items.isNotEmpty ? b.items[0].toLowerCase() : '';

      int comparison = firstCharA.compareTo(firstCharB);
      return _ascendingOrder ? comparison : -comparison;
      },
    );
  }

  Future<void> checkAddOrDecrease(int itemId, bool isChecked, double price) async {
    NewItems item =
        quantityItems.value.firstWhere((element) => element.id == itemId);
    
    if(isChecked) {
        total.value += price * item.quantity;
        // (total.value += double.parse((price * item.quantity).toStringAsFixed(2)));
        total.value = double.parse(total.value.toStringAsFixed(2));
        item.price = price; 
        item.isChecked = true;
        await _listsDao.update(item);
    }else {
      if(item.isChecked!) {
        total.value -= item.price! * item.quantity;
        total.value = double.parse(total.value.toStringAsFixed(2));
      }
      item.isChecked = false;
    }

    total.notifyListeners();

    await saveCheckboxState(itemId, isChecked);

    await _saveTotal();  

    await _loadListItems();
  }

  Future<bool> loadCheckboxState(int itemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('checkbox_$itemId') ?? false;
  }

  Future<void> saveCheckboxState(int itemId, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checkbox_$itemId', value);
  }

  void shareItems(List<NewItems> items) {
  String message = "${newLists.nameList}\n";
  for (NewItems item in items) {
    message += "${item.items} - ${item.quantity}\n";
    }
    Share.share(message);
  }
}


