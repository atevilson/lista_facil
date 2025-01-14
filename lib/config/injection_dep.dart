

import 'package:get_it/get_it.dart';
import 'package:lista_facil/data/repositories/i_items_repository.dart';
import 'package:lista_facil/data/repositories/i_list_repository.dart';
import 'package:lista_facil/data/repositories/items_repository.dart';
import 'package:lista_facil/data/repositories/list_repository.dart';
import 'package:lista_facil/data/services/local_db/items_dao.dart';
import 'package:lista_facil/data/services/local_db/lists_dao.dart';
import 'package:lista_facil/domain/models/lists.dart';
import 'package:lista_facil/ui/create_items/view_model/create_items_view_model.dart';
import 'package:lista_facil/ui/create_lists/view_model/create_list_view_model.dart';



final getIt = GetIt.instance;

var defaultList = Lists(0, '', 0.0, null);

void injectionDep() {
  getIt.registerLazySingleton<ItemsDao>(() => ItemsDao());
  getIt.registerLazySingleton<ListsDao>(() => ListsDao());

  getIt.registerLazySingleton<IItemsRepository>(
    () => ItemsRepository(getIt<ItemsDao>()),
  );
  getIt.registerLazySingleton<IListRepository>(
    () => ListRepository(getIt<ListsDao>()),
  );

  getIt.registerFactoryParam<CreateItemsViewModel, Lists, void>(
    (lists, _) => CreateItemsViewModel(
      iItemsRepository: getIt<IItemsRepository>(),
      lists: defaultList,
    ),
  );
  getIt.registerFactory<CreateListViewModel>(
    () => CreateListViewModel(
      listRepository: getIt<IListRepository>(),
    ),
  );
}
