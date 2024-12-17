import 'package:flutter/material.dart';
import 'package:lista_facil/database/dao/create_itens_dao.dart';
import 'package:lista_facil/models/new_items.dart';
import 'package:lista_facil/models/new_lists.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemController extends ChangeNotifier {
  final NewLists newLists;
  final ItemsDao _itemDao = ItemsDao();
  final ValueNotifier<List<NewItems>> quantityItems = ValueNotifier<List<NewItems>>([]);
  final List<NewItems> _layoffList = [];
  List<NewItems> get layoffList => _layoffList; // lista da dispensa
  bool _ascendingOrder = true; // ordenação default
  bool get isAscending => _ascendingOrder;
  final ValueNotifier<double> total = ValueNotifier<double>(0.0);

  late SharedPreferences _prefs;

  ItemController(this.newLists) {
    //
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ascendingOrder = _prefs.getBool('ascendingOrder') ?? true;
    _loadListItems();
    _loadTotalSpent();
  }

  Future<void> _loadListItems() async {
    List<NewItems> items = await _itemDao.findByListId(newLists.id);
    _sortItemsInternal(items);

    for (NewItems item in items) {
    item.isChecked = _prefs.getBool("checkbox_${item.id}") ?? false;
  }   
    quantityItems.value = items;
    notifyListeners();
  }

  Future<void> _saveTotal() async {
  await _prefs.setDouble('total_spent_${newLists.id}', total.value);
}

Future<void> _loadTotalSpent() async{
  total.value = _prefs.getDouble('total_spent_${newLists.id}') ?? 0.0;
  notifyListeners();
}

  Future<void> findItens() async {
    await _loadListItems();
  }

  Future<bool> saveItem(NewItems value) async {
    final NewItems newItens = NewItems(
        listId: newLists.id, items: value.items, quantity: value.quantity, price: value.price);
    await _itemDao.save(newItens);
    await _loadListItems();
    return true;
  }

  Future<bool> deleteItem(NewItems value) async {
    if(value.id != null && await loadCheckboxState(value.id!)) { // valida se o item está marcado antes de deletar
      total.value -= (value.price! * value.quantity);
      total.value = double.parse(total.value.toStringAsFixed(2));

      await _saveTotal();
      notifyListeners();
    }

    await _itemDao.delete(value);
    await _loadListItems();

    return true;
  }

  void sortItems(bool ascending) async {
    _ascendingOrder = ascending;
    await _prefs.setBool('ascendingOrder', ascending);

    List<NewItems> items = List<NewItems>.from(quantityItems.value);
    _sortItemsInternal(items);
    quantityItems.value = items;
    notifyListeners();
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

  Future<void> priceCheckerAndUpdater(int itemId, bool isChecked, double price) async {
    NewItems? item = quantityItems.value.firstWhere((element) => element.id == itemId);

    if (isChecked) {
      total.value += (price * item.quantity);
      item.isChecked = true;
      item.price = price; // Atualiza o preço se necessário
    } else {
      total.value -= (item.price! * item.quantity);
      item.isChecked = false;
    }

    total.value = double.parse(total.value.toStringAsFixed(2));
    notifyListeners();

    await _prefs.setBool("checkbox_$itemId", isChecked);
    await _saveTotal();
    await _itemDao.updateItem(item);
    await _loadListItems();
  }

  Future<bool> loadCheckboxState(int itemId) async {
    return _prefs.getBool('checkbox_$itemId') ?? false;
  }

  Future<void> saveCheckboxState(int itemId, bool value) async {
    await _prefs.setBool('checkbox_$itemId', value);
  }

  void shareItems(List<NewItems> items) {
  String message = "${newLists.nameList}\n";
  for (NewItems item in items) {
    message += "${item.items} - ${item.quantity}\n";
    }
    Share.share(message);
  }

  Future<List<NewItems>> searchItemByName(String query) async {
    if(query.isEmpty){
      return quantityItems.value;
    }else {
       return quantityItems.value
        .where((local) => local.items.toLowerCase().contains(query.toLowerCase()))
        .toList();
    }

  }

  Future<void> updateItem(NewItems updatedItem) async {
     NewItems? oldItem = quantityItems.value.firstWhere((item) => item.id == updatedItem.id);

    if (oldItem.id != null) {
      if (oldItem.isChecked) {
        double oldTotal = (oldItem.price ?? 0.0) * oldItem.quantity; // subtrai o valor antigo do total
        double newTotal = (updatedItem.price ?? 0.0) * updatedItem.quantity; // add o novo valor ao total
        total.value = total.value - oldTotal + newTotal;
        total.value = double.parse(total.value.toStringAsFixed(2));
        await _saveTotal();
      }
    }

    await _itemDao.updateItem(updatedItem);
    await _loadListItems();
  }
}


