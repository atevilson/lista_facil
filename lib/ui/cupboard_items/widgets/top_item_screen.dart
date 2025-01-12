
import 'package:flutter/material.dart';
import 'package:lista_facil/ui/core/themes/colors.dart';

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
              tileColor: ThemeColor.colorWhite,
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
