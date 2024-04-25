import 'package:flutter/material.dart';
import 'package:my_app/controllers/list_controller.dart';

import 'package:my_app/models/new_lists.dart';
import 'package:my_app/screens/list_form.dart';

class createdLists extends StatelessWidget {
  final ListController controller = ListController();
  final String _title = 'Listas de compras';

  @override
  Widget build(BuildContext context) {
    controller.findAll();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 92, 24),
        foregroundColor: Colors.white,
        title: Text(_title),
      ),
      body: ValueListenableBuilder<List<NewLists>>(
        valueListenable: controller.listaValores,
        builder: (context, snapshot, _) {
          if (snapshot.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Carregando'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final NewLists lists = snapshot[index];
              return _collectionsLists(lists);
            },
            itemCount: snapshot.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => listCreateForm(controller),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 21, 92, 24),
        foregroundColor: Colors.white,
        hoverColor: Colors.lightGreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _collectionsLists extends StatelessWidget {
  final NewLists list;

  _collectionsLists(this.list);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          list.nameList,
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
