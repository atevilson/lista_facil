import 'package:flutter/material.dart';
import 'package:lista_facil/data/repositories/i_items_repository.dart';
import 'package:lista_facil/domain/models/items.dart';
import 'package:lista_facil/domain/models/lists.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateItemsViewModel extends ChangeNotifier {
  final Lists newLists;
  final IItemsRepository _itemsRepository;
  //final ItemsDao _itemDao = ItemsDao();
  final ValueNotifier<List<Items>> quantityItems = ValueNotifier<List<Items>>([]);
  bool _ascendingOrder = true; // ordenação default
  bool get isAscending => _ascendingOrder;
  final ValueNotifier<double> total = ValueNotifier<double>(0.0);

  late SharedPreferences _prefs;

  CreateItemsViewModel(this.newLists, this._itemsRepository) {
    //
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ascendingOrder = _prefs.getBool('ascendingOrder') ?? true;
    _loadListItems();
    _loadTotalSpent();
  }

  Future<void> _loadListItems() async {
    List<Items> items = await _itemsRepository.getItemsByListId(newLists.id);
    _sortItemsInternal(items);

    for (Items item in items) {
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

  Future<bool> saveItem(Items value) async {
    final Items newItens = Items(
        listId: newLists.id, items: value.items, quantity: value.quantity, price: value.price);
    await _itemsRepository.saveItem(newItens);
    await _loadListItems();
    return true;
  }

  Future<bool> deleteItem(Items value) async {
    if(value.id != null && await loadCheckboxState(value.id!)) { // valida se o item está marcado antes de deletar
      total.value -= (value.price! * value.quantity);
      total.value = double.parse(total.value.toStringAsFixed(2));

      await _saveTotal();
      notifyListeners();
    }

    await _itemsRepository.deleteItem(value);
    await _loadListItems();

    return true;
  }

  void sortItems(bool ascending) async {
    _ascendingOrder = ascending;
    await _prefs.setBool('ascendingOrder', ascending);

    List<Items> items = List<Items>.from(quantityItems.value);
    _sortItemsInternal(items);
    quantityItems.value = items;
    notifyListeners();
  }

  void _sortItemsInternal(List<Items> items) {
    items.sort((a, b) {
      String firstCharA = a.items.isNotEmpty ? a.items[0].toLowerCase() : '';
      String firstCharB = b.items.isNotEmpty ? b.items[0].toLowerCase() : '';

      int comparison = firstCharA.compareTo(firstCharB);
      return _ascendingOrder ? comparison : -comparison;
      },
    );
  }

  Future<void> priceCheckerAndUpdater(int itemId, bool isChecked, double price) async {
    Items? item = quantityItems.value.firstWhere((element) => element.id == itemId);

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
    await _itemsRepository.updateItem(item);
    await _loadListItems();
  }

  Future<bool> loadCheckboxState(int itemId) async {
    return _prefs.getBool('checkbox_$itemId') ?? false;
  }

  Future<void> saveCheckboxState(int itemId, bool value) async {
    await _prefs.setBool('checkbox_$itemId', value);
  }

  void shareItems(List<Items> items) {
  String message = "${newLists.nameList}\n";
  for (Items item in items) {
    message += "${item.items} - ${item.quantity}\n";
    }
    Share.share(message);
  }

  Future<List<Items>> searchItemByName(String query) async {
    if(query.isEmpty){
      return quantityItems.value;
    }else {
       return quantityItems.value
        .where((local) => local.items.toLowerCase().contains(query.toLowerCase()))
        .toList();
    }

  }

  Future<void> updateItem(Items updatedItem) async {
     Items? oldItem = quantityItems.value.firstWhere((item) => item.id == updatedItem.id);

    if (oldItem.id != null) {
      if (oldItem.isChecked) {
        double oldTotal = (oldItem.price ?? 0.0) * oldItem.quantity; // subtrai o valor antigo do total
        double newTotal = (updatedItem.price ?? 0.0) * updatedItem.quantity; // add o novo valor ao total
        total.value = total.value - oldTotal + newTotal;
        total.value = double.parse(total.value.toStringAsFixed(2));
        await _saveTotal();
      }
    }

    await _itemsRepository.updateItem(updatedItem);
    await _loadListItems();
  }
}


