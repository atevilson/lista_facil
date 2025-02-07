
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:lista_facil/data/repositories/i_list_repository.dart';
import 'package:lista_facil/domain/models/items.dart';
import 'package:lista_facil/domain/models/lists.dart';
import 'package:lista_facil/utils/command.dart';
import 'package:lista_facil/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_similarity/string_similarity.dart';


class CreateListViewModel extends ChangeNotifier {
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
    saveList = Command1(_saveList);
    deleteList = Command1(_deleteList);
    updateList = Command1(_updateList);
    loadLists = Command0(_loadLists);
  }

  late Command1<bool, Lists> saveList;
  late Command1<void, Lists> deleteList;
  late Command1<void, Lists> updateList;
  late Command0 loadLists;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ascendingOrder = _prefs.getBool('ascendingOrder') ?? true;
    await _loadLists();
  }

  Future<Result<void>> _loadLists() async {
    try{
      List<Lists> lists = await _listRepository.findAll();
      for(Lists list in lists) {
        list.bookMarked = _prefs.getBool('bookmark_${list.id}') ?? false;
      }
      _sortItemsInternal(lists);

      listaValores.value = lists;
    }catch(e){
      Result.error(Exception(e.toString()));
    }
    return Result.ok(null);
  }

  Future<Result<void>> _deleteList(Lists value) async {
    try{
      await _listRepository.deleteLists(value);
      await _prefs.remove('bookmark_${value.id}');
      await _prefs.remove('total_spent_${value.id}');
      await _loadLists();
    }catch(e){
      Result.error(Exception(e.toString()));
    }
    return Result.ok(null);
  } 

  Future<Result<bool>> _saveList(Lists list) async {
    try{
      if (list.nameList.isNotEmpty) {
      final Lists newLists = Lists(0, list.nameList, list.budget, "");
      await _listRepository.save(newLists);
      await _prefs.setBool('bookmark_${newLists.id}', false);
      await _loadLists();
      return Result.ok(true);
    }
    return Result.ok(false);
    }catch(e){
      Result.error(Exception(e.toString()));
    }
    return Result.ok(false);
  }

  Future<List<Lists>> searchListsByName(String query) async {
    if(query.isEmpty){
      return listaValores.value;
    }else{
    return listaValores.value.where((local) => local.nameList.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  Future<Result<void>> _updateList(Lists list) async {
    try{
      await _listRepository.updateList(list);
      await _prefs.setBool('bookmark_${list.id}', list.bookMarked);
      await _loadLists();
    }catch(e){
      Result.error(Exception(e.toString()));
    }
    return Result.ok(null);
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