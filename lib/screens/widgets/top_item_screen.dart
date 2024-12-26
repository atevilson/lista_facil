
import 'package:flutter/material.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

class TopItemsScreen extends StatelessWidget {
  final String title;
  final List<MapEntry<String, int>> data;

  const TopItemsScreen({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(
          color: ThemeColor.colorWhite
        ),), 
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final entry = data[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 3.0),
            child: ListTile(
              dense: true,
              tileColor: ThemeColor.colorWhite70,
              title: Text(entry.key, style: TextStyle(
                color: ThemeColor.colorBlueTema
              ),),
              subtitle: Text("Quantidade: ${entry.value}", style: TextStyle(
                color: ThemeColor.colorGreenTotal
              ),),
            ),
          );
        },
      ),
    );
  }
}
