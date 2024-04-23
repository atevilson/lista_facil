import 'package:flutter/material.dart';
import 'package:my_app/screens/list_form.dart';

class createdLists extends StatelessWidget {
  const createdLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 92, 24),
        foregroundColor: Colors.white,
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
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => listCreateForm(),
                ),
              )
              .then(
                (newLists) => debugPrint(newLists.toString()),
              );
        },
        backgroundColor: Color.fromARGB(255, 21, 92, 24),
        foregroundColor: Colors.white,
        hoverColor: Colors.lightGreen,
        child: Icon(Icons.add),
      ),
    );
  }
}
