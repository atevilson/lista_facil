import 'package:flutter/material.dart';

class createdLists extends StatelessWidget {
  const createdLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listas de compras'),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text(
                'Lista 1',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      child: Icon(Icons.add),
      ),
    );
  }
}
