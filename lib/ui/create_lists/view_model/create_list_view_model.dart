
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:lista_facil/data/repositories/i_list_repository.dart';
import 'package:lista_facil/domain/models/items.dart';
import 'package:lista_facil/domain/models/lists.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_similarity/string_similarity.dart';


class CreateListViewModel extends ChangeNotifier {
  //final ListsDao _listsDao = ListsDao(); 
  final IListRepository _listRepository;
  final ValueNotifier<List<Lists>> listaValores =
      ValueNotifier<List<Lists>>([]);
  final List<Items> _layoffList = [];

  bool _ascendingOrder = true; // ordenação default
  bool get isAscending => _ascendingOrder;// lista da dispensa

  late SharedPreferences _prefs;

  CreateListViewModel({
    required IListRepository listRepository,
  }) : _listRepository = listRepository {
    //
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ascendingOrder = _prefs.getBool('ascendingOrder') ?? true;
    await findAll();
  }

  Future<void> findAll() async {
    List<Lists> lists = await _listRepository.findAll();
    for(Lists list in lists) {
      list.bookMarked = _prefs.getBool('bookmark_${list.id}') ?? false;
    }
    _sortItemsInternal(lists);

    listaValores.value = lists;
  }

  Future<void> deleteList(Lists value) async {
    await _listRepository.deleteLists(value);
    await _prefs.remove('bookmark_${value.id}');
    await _prefs.remove('total_spent_${value.id}');
    await findAll();
  } 

  Future<bool> saveList(String value, double budget) async {
    if (value.isNotEmpty) {
      final Lists newLists = Lists(0, value, budget, "");
      await _listRepository.save(newLists);
      await _prefs.setBool('bookmark_${newLists.id}', false);
      await findAll();
      return true;
    }
    return false;
  }

  Future<List<Lists>> searchListsByName(String query) async {
    if(query.isEmpty){
      return listaValores.value;
    }else{
    return listaValores.value.where((local) => local.nameList.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  Future<void> updateList(Lists list) async {
    await _listRepository.updateList(list);
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

    List<Lists> lists = List<Lists>.from(listaValores.value);
    _sortItemsInternal(lists);
    listaValores.value = lists;
    notifyListeners();
  }

  void _sortItemsInternal(List<Lists> items) {
    items.sort((a, b) {
      String firstCharA = a.nameList.isNotEmpty ? a.nameList[0].toLowerCase() : '';
      String firstCharB = b.nameList.isNotEmpty ? b.nameList[0].toLowerCase() : '';

      //int comparison = firstCharA.compareTo(firstCharB);
      return _ascendingOrder ? firstCharA.compareTo(firstCharB) : firstCharB.compareTo(firstCharA);
      },
    );
  }

   void addLayoffItem(Items item) { // adiciona um unico item a dispensa
    _layoffList.add(item);
    notifyListeners();
  }

  void addLayoffItems(List<Items> list) {
    // adiciona múltiplos itens a dispensa
    _layoffList.addAll(list);
    notifyListeners();
  }

  String _normalize(String text) {
    return removeDiacritics(text).toLowerCase();
  }

  Items? getLayoffItemByName(String name) {
    // retorna um item com base na lista de dispensa ou null
    // try{
    //   return _layoffList.firstWhere((item) => item.items.toLowerCase() == name.toLowerCase());
    // }catch(e){
    //   return null;
    // }

    if (_layoffList.isEmpty) return null;

    String normalizedInput = _normalize(name);

    double bestScore = 0.0;
    Items? bestMatch;

    for (var item in _layoffList){
      double score = normalizedInput.similarityTo(_normalize(item.items)); // normalização do item antes de comparar
      if (score > bestScore) {
        bestScore = score;
        bestMatch = item;
      }
    }

    if (bestScore > 0.5){ // score min para considerar se na comparação são equivalentes
      return bestMatch;
    }

    return null;
  }
}