
// test/fakes/fake_items_repository.dart
import 'package:lista_facil/data/repositories/i_items_repository.dart';
import 'package:lista_facil/domain/models/items.dart';

class FakeItemsRepository implements IItemsRepository {
  final List<Items> _items = [];

  @override
  Future<int> saveItem(Items item) async {
    _items.add(item);
    return 1;
  }

  @override
  Future<int> deleteItem(Items item) async {
    _items.removeWhere((i) => i.id == item.id);
    return 1;
  }

  @override
  Future<List<Items>> getAllItems() async {
    return _items;
  }

  @override
  Future<List<Items>> getItemsByListId(int listId) async {
    return _items.where((i) => i.listId == listId).toList();
  }

  @override
  Future<int> updateItem(Items item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
    return 1;
  }
}
