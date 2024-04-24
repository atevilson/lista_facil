import 'package:flutter/material.dart';
import 'package:my_app/database/list_database.dart';
import 'package:my_app/models/new_lists.dart';
import 'package:my_app/screens/list_form.dart';

class createdLists extends StatelessWidget {
  //final List<NewLists> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 92, 24),
        foregroundColor: Colors.white,
        title: Text('Listas de compras'),
      ),
      body: FutureBuilder<List<NewLists>>(
        initialData: List.empty(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [CircularProgressIndicator(), Text('Carregando')],
                ),
              );
            case ConnectionState.done:
              final List<NewLists> list = snapshot.data ?? [];
              return ListView.builder(
                itemBuilder: (context, index) {
                  final NewLists lists = list[index];
                  return _collectionsLists(lists);
                },
                itemCount: list.length,
              );
            case ConnectionState.active:
              break;
          }
          return Text('Erro desconhecido');
        },
        future: findAll(),
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

class _collectionsLists extends StatelessWidget {
  final NewLists list;

  _collectionsLists(this.list);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          list.nameList,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
