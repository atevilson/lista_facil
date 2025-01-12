
import 'package:lista_facil/domain/models/items.dart';

abstract class IItemsRepository {
  Future<int> saveItem(Items item);
  Future<int> deleteItem(Items item);
  Future<List<Items>> getAllItems();
  Future<List<Items>> getItemsByListId(int listId);
  Future<int> updateItem(Items item);
}