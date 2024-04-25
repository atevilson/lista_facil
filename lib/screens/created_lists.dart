import 'package:flutter/material.dart';
import 'package:my_app/database/dao/create_list_dao.dart';
import 'package:my_app/models/new_lists.dart';
import 'package:my_app/screens/list_form.dart';

class createdLists extends StatelessWidget {
  final ListsDao _listsDao = ListsDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 92, 24),
        foregroundColor: Colors.white,
        title: const Text('Listas de compras'),
      ),
      body: FutureBuilder<List<NewLists>>(
        initialData: [],
        future: _listsDao.findAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
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
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<NewLists> list = snapshot.data!;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final NewLists lists = list[index];
                  return _collectionsLists(lists);
                },
                itemCount: list.length,
              );
          }
          return const Text('Erro desconhecido');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => listCreateForm(),
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
