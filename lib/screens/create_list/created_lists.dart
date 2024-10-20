import 'package:flutter/material.dart';
import 'package:lista_facil/components/dialog_custom.dart';
import 'package:lista_facil/controllers/list_controller.dart';
import 'package:lista_facil/models/new_lists.dart';
import 'package:lista_facil/screens/create_list/list_create_form.dart';
import 'package:lista_facil/screens/itens_list/list_transference.dart';

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
      appBar: AppBar(
        title: Text(_title),
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
              return DialogCustom(
                keyConfirm: Key(lists.id.toString()),
                onDismissed: () async => await _controller.deleteItem(lists),
                confirmTitle: "Confirmar exclusão",
                confirmContent: "Deseja realmente excluir a lista ${lists.nameList} ?",
                confirmText: "Ok",
                cancelText: "Cancelar",
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
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CollectionsLists extends StatelessWidget {
  final NewLists list;

  const _CollectionsLists(this.list);

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
            style: const TextStyle(fontSize: 22.0),
          ),
        ),
      ),
    );
  }
}
