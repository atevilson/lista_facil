
import 'package:lista_facil/data/repositories/i_list_repository.dart';
import 'package:lista_facil/data/services/local_db/lists_dao.dart';
import 'package:lista_facil/domain/models/lists.dart';

class ListRepository  implements IListRepository {
  final ListsDao _listDao;

  ListRepository(this._listDao);

  @override
  Future<int> deleteLists(Lists list) {
    return _listDao.deleteLists(list);
  }

  @override
  Future<List<Lists>> findAll() {
    return _listDao.findAll();
  }

  @override
  Future<int> save(Lists list) {
    return _listDao.save(list);
  }

  @override
  Future<int> updateList(Lists list) {
    return _listDao.updateList(list);
  }

}