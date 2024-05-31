import 'package:flutter/material.dart';
import 'package:my_app/controllers/list_controller.dart';
import 'package:my_app/models/new_lists.dart';
import 'package:my_app/screens/create_list/list_create_form.dart';
import 'package:my_app/screens/itens_list/list_transference.dart';
import 'package:my_app/utils_colors/utils_style.dart';

class CreatedLists extends StatefulWidget {
  const CreatedLists({super.key});

  @override
  State<CreatedLists> createState() => _CreatedListsState();
}

class _CreatedListsState extends State<CreatedLists> {
  final ListController _controller = ListController();

  final String _title = 'Listas de compras';

  @override
  void initState() {
    super.initState();
    _controller.findAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom(
        title: _title,
      ),
      body: ValueListenableBuilder<List<NewLists>>(
        valueListenable: _controller.listaValores,
        builder: (context, snapshot, _) {
          if (snapshot.isEmpty) {
            return const Center(
              child: Text('Nenhuma lista disponível'),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final NewLists lists = snapshot[index];
              return Dismissible(
                key: Key(lists.id.toString()),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Confirmar exclusão",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: UtilColors.instance.colorRed),
                        ),
                        content: Text(
                          "Excluir a lista?",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: UtilColors.instance.colorRed),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              "OK",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) async {
                  await _controller.deleteItem(lists);
                  _controller.findAll(); 
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: _CollectionsLists(lists),
              );
            },
            itemCount: snapshot.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ListCreateForm(_controller),
            ),
          );
          _controller.findAll(); 
        },
        shape: const CircleBorder(),
        backgroundColor: UtilColors.instance.colorRed,
        foregroundColor: UtilColors.instance.colorWhite,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CollectionsLists extends StatelessWidget {
  final NewLists list;

  _CollectionsLists(this.list);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ListTransference(list);
            }));
          },
          child: Text(
            list.nameList,
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}
