
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

  // varicação de preços entre itens (comparativo mês a mês)
  Future<Map<String, List<double>>> getVariacaoPrecoItemMesAMes() async{
    List<NewItems> allItems = await _itemsDao.findAll(); 

    final Map<String, Map<String, List<double>>> agrupado = {};

    for (var items in allItems) {
      if(items.createdAt == null) continue;
      final createdDate = DateTime.tryParse(items.createdAt!);
      if(createdDate == null) continue;

      final nome = items.items;
      final mesAno = "${createdDate.year.toString().padLeft(4, '0')}-${createdDate.month.toString().padLeft(2, '0')}";
      if(!agrupado.containsKey(nome)){
        agrupado[nome] = {};
      }
      if(!agrupado[nome]!.containsKey(mesAno)){
        agrupado[nome]![mesAno] = [];
      }
      agrupado[nome]![mesAno]!.add(items.price ?? 0.0);
    }

    final Map<String, List<double>> resultado = {};

    agrupado.forEach((nomeItem, mapMeses) {
      final chavesOrdenada = mapMeses.keys.toList()..sort((a, b) => a.compareTo(b));

      List<double> precoPorMes = [];
      for(var mes in chavesOrdenada) {
        List<double> listaPrecos = mapMeses[mes]!;
        if(listaPrecos.isEmpty) continue;
        double media = listaPrecos.reduce((a,b) => a +  b) / listaPrecos.length;
        precoPorMes.add(media);
      }
      resultado[nomeItem] = precoPorMes;
    });

    return resultado;
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