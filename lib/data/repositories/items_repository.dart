
import 'package:lista_facil/data/repositories/i_items_repository.dart';
import 'package:lista_facil/data/services/local_db/items_dao.dart';
import 'package:lista_facil/domain/models/items.dart';

class ItemsRepository implements IItemsRepository {
  final ItemsDao _itensDao;

  ItemsRepository(this._itensDao);

  @override
  Future<int> deleteItem(Items item) async {
    return await _itensDao.delete(item);
  }

  @override
  Future<List<Items>> getAllItems() async {
    return await _itensDao.findAll();
  }

  @override
  Future<List<Items>> getItemsByListId(int listId) async {
    return await _itensDao.findByListId(listId);
  }

  @override
  Future<int> saveItem(Items item) async {
    return await _itensDao.save(item);
  }

  @override
  Future<int> updateItem(Items item) async {
    return await _itensDao.updateItem(item);
  }
}