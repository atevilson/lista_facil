
import 'package:flutter/material.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

class PriceVariationScreen extends StatelessWidget {
  final Map<String, List<double>> data;

  const PriceVariationScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final items = data.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Variação de preços", style: TextStyle(
          color: ThemeColor.colorWhite
        ),),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final entry = items[index];
          final nomeItem = "Item ${entry.key.toLowerCase()}";
          final precosMesAMes = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              child: ListTile(
                tileColor: ThemeColor.colorWhite70,
                title: Text(nomeItem, style: TextStyle(
                  color: ThemeColor.colorBlueTema
                ),),
                subtitle: Text(
                  "Preço no último mês: ${precosMesAMes.join(", ")}",
                  style: TextStyle(
                    color: ThemeColor.colorGreenTotal
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
