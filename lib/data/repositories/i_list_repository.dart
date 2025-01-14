
import 'package:lista_facil/domain/models/lists.dart';

abstract class IListRepository {
  Future<List<Lists>> findAll();
  Future<int> save(Lists list);
  Future<int> updateList(Lists list);
  Future<int> deleteLists(Lists list);
}