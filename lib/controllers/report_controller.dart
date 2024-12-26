
import 'package:lista_facil/database/dao/create_itens_dao.dart';
import 'package:lista_facil/models/new_items.dart';

class ReportController {

  final ItemsDao _itemsDao = ItemsDao();
  //final ListsDao _listsDao = ListsDao();

  ReportController() {
    //
  }

  // gasto médio mensal com base nos últimos 3 meses
  Future<double> getGastosTrimestraisAlimentacao() async{
    final dateNow = DateTime.now();

    DateTime treeMonthsAgo = DateTime(dateNow.year, dateNow.month - 3, dateNow.day);

    List<NewItems> allItems = await _itemsDao.findAll();

    List<NewItems> itemsThreeMonths = allItems.where((item) {
      if(item.createdAt == null) return false;
      final created = DateTime.tryParse(item.createdAt!);
      if(created == null) return false;
      return created.isAfter(treeMonthsAgo);
    }).toList();

    double totalGasto = 0.0;

    for(var items in itemsThreeMonths) {
      final double price = items.price ?? 0.0;
      final int qtd = items.quantity;
      totalGasto += (price * qtd);
    }

    double media = totalGasto / 3;
    return media;
  }

  // variação de preços entre itens (comparativo em relação a ultima compra)
  Future<Map<String, double>> getVariacaoPrecoUltimaCompra() async{
    List<NewItems> allItems = await _itemsDao.findAll(); 

    final Map<String, List<NewItems>> agrupado = {};

    for (var item in allItems) {
      if(item.createdAt == null) continue;

      final nome = item.items;
      if(!agrupado.containsKey(nome)){
        agrupado[nome] = [];
      }
      agrupado[nome]!.add(item);
    }

    agrupado.forEach((nomeItem, lista) {
      lista.sort((a,b) {
        final dateA = DateTime.tryParse(a.createdAt!);
        final dateB = DateTime.tryParse(b.createdAt!);
        if(dateA == null && dateB == null) return 0;
        return dateA!.compareTo(dateB!);
      });
    });

    final Map<String, double> diferenca = {};

    agrupado.forEach((nomeItem, listaOrdenada) {
      if(listaOrdenada.length < 2){
        diferenca[nomeItem] = 0.0;
        return;
      }

      final penultimo = listaOrdenada[listaOrdenada.length - 2];
      final ultimo = listaOrdenada[listaOrdenada.length - 1];

      final double precoPenultimo = penultimo.price ?? 0.0;
      final double precoUltimo = ultimo.price ?? 0.0;

      double diff = precoUltimo - precoPenultimo;
      diferenca[nomeItem] = diff;
    });

    return diferenca;
  }

  Future<List<MapEntry<String, int>>> getTopItemsMaisComprados() async{
    final dateNow = DateTime.now();
    DateTime threeMonthsAgo = DateTime(dateNow.year, dateNow.month -3, dateNow.day);

    List<NewItems> allItems = await _itemsDao.findAll();

    List<NewItems> itemTresMeses = allItems.where((item) {
      if(item.createdAt == null) return false;
      final created = DateTime.tryParse(item.createdAt!);
      if (created == null) return false;
      return created.isAfter(threeMonthsAgo);
    }).toList();

    Map<String, int> quantidadePorNome = {};

    for(var item in itemTresMeses) {
      final nome = item.items;
      quantidadePorNome[nome] = (quantidadePorNome[nome] ?? 0) + item.quantity;
    }

    List<MapEntry<String, int>> ordenado = quantidadePorNome.entries.toList();
    ordenado.sort((a,b) => b.value.compareTo(a.value));

    if(ordenado.length > 10){
      ordenado = ordenado.sublist(0, 10);
    }
    return ordenado;
  }
}