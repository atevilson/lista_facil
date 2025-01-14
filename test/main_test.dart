
import 'package:lista_facil/domain/models/items.dart';
import 'package:lista_facil/domain/models/lists.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fake_items_repository.dart';
import 'package:lista_facil/ui/create_items/view_model/create_items_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });
  test("Deve salvar item usando o FakeItemsRepository", () async{ // teste de salvar um item
      final fakeList = Lists(1, "Lista teste", 100.0, null);
      final fakeRepo = FakeItemsRepository();

      final viewModel = CreateItemsViewModel(lists: fakeList, iItemsRepository: fakeRepo);

      await viewModel.init();

      await viewModel.saveItem(Items(items: "Arroz", quantity: 2, listId: 1));

      final items = await fakeRepo.getAllItems();
      expect(items.length, 1);
      expect(items.first.items, "Arroz");
    },
  );
  test("Deve deletar item usando o FakeItemsRepository", () async{ // teste de exclusão do item 
    final fakeList = Lists(1, "Lista teste", 100.0, null);
    final fakeRepo = FakeItemsRepository();

    final viewModel = CreateItemsViewModel(lists: fakeList, iItemsRepository: fakeRepo);
    await viewModel.init();

    await viewModel.saveItem(Items(items: "Arroz", quantity: 2, listId: 1));

    await viewModel.deleteItem(Items(items: "Arroz", quantity: 2, listId: 1));

    final items = await fakeRepo.getAllItems();
    expect(items.length, 0, reason: "Após deletar o item a lista deve ficar vazia");
    },
  );
  test("Deve editar item usando o FakeItemsRepository", () async{ // teste de edição do item
    final fakeList = Lists(1, "Lista teste", 100.0, null);
    final fakeRepo = FakeItemsRepository();

    final viewModel = CreateItemsViewModel(lists: fakeList, iItemsRepository: fakeRepo);
    await viewModel.init();

    await viewModel.saveItem(Items(items: "Arroz", quantity: 2, listId: 1));

    var items = await fakeRepo.getAllItems();
    expect(items.length, 1);

    final oldItem = items.first;
    expect(oldItem.items, "Arroz");
    expect(oldItem.quantity, 2);

    final updateItem = Items(items: "Arroz integral", quantity: 5, listId: 1);
    await viewModel.updateItem(updateItem);
    items  = await fakeRepo.getAllItems();
    expect(items.length, 1, reason: "Continua apenas um item salvo");
    final updated = items.first;
    expect(updated.items, "Arroz integral");
    expect(updated.quantity, 5);
    },
  );
  test("Deve salvar o item em listas diferentes e retornar apenas o item da lista correspondente", () async{
    // teste q verifica se (getItemsByListId) retorna apenas os itens de lista específica
    final fakeList1 = Lists(1, "Lista teste1", 100.0, null);
    final fakeList2 = Lists(2, "Lista teste2", 100.0, null);
    final fakeRepo = FakeItemsRepository();

    final viewModel1 = CreateItemsViewModel(lists: fakeList1, iItemsRepository: fakeRepo);
    final viewModel2 = CreateItemsViewModel(lists: fakeList2, iItemsRepository: fakeRepo);
    await viewModel1.init();
    await viewModel2.init();

    await viewModel1.saveItem(Items(items: "Arroz", quantity: 2, listId: 1));
    await viewModel2.saveItem(Items(items: "Feijao", quantity: 5, listId: 2));

    final itemsLista1 = await fakeRepo.getItemsByListId(1);
    expect(itemsLista1.length, 1, reason: "Deve ter apenas um item na lista 1");
    expect(itemsLista1.first.items, "Arroz");

    final itemsLista2 = await fakeRepo.getItemsByListId(2);
    expect(itemsLista2.length, 1, reason: "Deve ter apenas um item na lista 2");
    expect(itemsLista2.first.items, "Feijao");
  });
}
