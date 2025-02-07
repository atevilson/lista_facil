import 'package:diacritic/diacritic.dart';
import 'package:lista_facil/data/services/local_db/items_dao.dart';
import 'package:lista_facil/domain/models/items.dart';
import 'package:string_similarity/string_similarity.dart';

class ReportViewModel {
  final ItemsDao _itemsDao = ItemsDao();

  ReportViewModel();

  Future<double> getGastosTrimestraisAlimentacao() async {
    final dateNow = DateTime.now();
    final threeMonthsAgo = DateTime(dateNow.year, dateNow.month - 3, dateNow.day);

    List<Items> allItems = await _itemsDao.findAll();

    final itemsThreeMonths = allItems.where((item) {
      if (item.createdAt == null) return false;
      final created = DateTime.tryParse(item.createdAt!);
      if (created == null) return false;
      return created.isAfter(threeMonthsAgo);
    }).toList();

    double totalGasto = 0.0;

    for (var item in itemsThreeMonths) {
      final double price = item.price ?? 0.0;
      final int qtd = item.quantity;
      totalGasto += (price * qtd);
    }

    final double media = totalGasto / 3;
    return media;
  }

  Future<Map<String, double>> getVariacaoPrecoUltimaCompra() async {
    final List<Items> allItems = await _itemsDao.findAll();

    final Map<String, List<Items>> agrupado = {};

    for (var item in allItems) {
      if (item.createdAt == null) continue;

      final nomeOriginal = item.items; 
      final nomeNormalizado = _normalize(nomeOriginal); 

      String? chaveEncontrada;
      double bestScore = 0.0;

      for (var chaveExistente in agrupado.keys) {
        final double score = nomeNormalizado.similarityTo(_normalize(chaveExistente));
        if (score > bestScore) {
          bestScore = score;
          chaveEncontrada = chaveExistente;
        }
      }

      if (chaveEncontrada == null || bestScore < 0.5) {
        agrupado[nomeOriginal] = [];
        agrupado[nomeOriginal]!.add(item);
      } else {
        agrupado[chaveEncontrada]!.add(item);
      }
    }

    agrupado.forEach((nomeItem, lista) {
      lista.sort((a, b) {
        final dateA = DateTime.tryParse(a.createdAt!);
        final dateB = DateTime.tryParse(b.createdAt!);
        if (dateA == null && dateB == null) return 0;
        return dateA!.compareTo(dateB!);
      });
    });

    final Map<String, double> diferenca = {};

    agrupado.forEach((nomeItem, listaOrdenada) {
      if (listaOrdenada.length < 2) {
        diferenca[nomeItem] = 0.0;
      } else {
        final penultimo = listaOrdenada[listaOrdenada.length - 2];
        final ultimo = listaOrdenada[listaOrdenada.length - 1];

        final double precoPenultimo = penultimo.price ?? 0.0;
        final double precoUltimo = ultimo.price ?? 0.0;

        final double diff = precoUltimo - precoPenultimo;
        diferenca[nomeItem] = diff;
      }
    });

    return diferenca;
  }

  Future<List<MapEntry<String, int>>> getTopItemsMaisComprados() async {
    final dateNow = DateTime.now();
    final threeMonthsAgo = DateTime(dateNow.year, dateNow.month - 3, dateNow.day);

    final List<Items> allItems = await _itemsDao.findAll();

    final itemTresMeses = allItems.where((item) {
      if (item.createdAt == null) return false;
      final created = DateTime.tryParse(item.createdAt!);
      if (created == null) return false;
      return created.isAfter(threeMonthsAgo);
    }).toList();

    final Map<String, int> quantidadePorNome = {};

    for (var item in itemTresMeses) {
      final nome = item.items;
      quantidadePorNome[nome] = (quantidadePorNome[nome] ?? 0) + item.quantity;
    }

    List<MapEntry<String, int>> ordenado = quantidadePorNome.entries.toList();
    ordenado.sort((a, b) => b.value.compareTo(a.value));

    if (ordenado.length > 10) {
      ordenado = ordenado.sublist(0, 10);
    }
    return ordenado;
  }

  String _normalize(String text) { // método de normalização remove acentos e deixa texto em minúsculo
    return removeDiacritics(text).toLowerCase();
  }
}
