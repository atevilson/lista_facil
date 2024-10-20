import 'package:flutter/material.dart';
import 'package:lista_facil/components/dialog_custom.dart';
import 'package:lista_facil/controllers/item_controller.dart';
import 'package:lista_facil/models/new_items.dart';
import 'package:lista_facil/models/new_lists.dart';
import 'package:lista_facil/screens/itens_list/transfer_form.dart';

const titleAppBar = 'Itens da lista';

class ListTransference extends StatefulWidget {
  final NewLists list;
  const ListTransference(this.list, {super.key});
  @override
  State<StatefulWidget> createState() {
    return CreateStateTransferList();
  }
}

class CreateStateTransferList extends State<ListTransference> {
  late ItemController _controller;
  bool ascendingOrder = true;

  @override
  void initState() {
    super.initState();
    _controller = ItemController(widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleAppBar),
        actions: [
          IconButton(
            onPressed: () =>  {
               _controller.shareItems(_controller.quantityItems.value)
            },
            icon: const Icon(Icons.share),
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(
                () {
                  ascendingOrder = result == 'Ordenar A-Z';
                  _controller.sortItems(ascendingOrder);
                },
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Ordenar A-Z',
                child: Text('Ordenar A-Z'),
              ),
              const PopupMenuItem<String>(
                value: 'Ordenar Z-A',
                child: Text('Ordenar Z-A'),
              ),
            ],
          ),
        ],
      ),
      body: ValueListenableBuilder<List<NewItems>>(
        valueListenable: _controller.quantityItems,
        builder: (context, items, _) {
          if (items.isEmpty) {
            return const Center(child: Text('Nenhum item encontrado'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final NewItems item = items[index];
              return DialogCustom(
                keyConfirm: Key(item.id.toString()), 
                onDismissed: () async => await _controller.deleteItem(item),
                confirmTitle: "Confirmar exclusão",
                confirmContent: "Deseja realmente excluir o item ${item.items} ?",
                confirmText: "Ok",
                cancelText: "Cancelar",
                child: TransferItens(item, _controller), 
                );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final savedItem = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return TransferForm(_controller);
          }));
          if (savedItem != null) {
            setState(() {});
          }
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TransferItens extends StatefulWidget {
  final NewItems _addItems;
  final ItemController _controller;

  const TransferItens(this._addItems, this._controller, {super.key});

  @override
  TransferItensState createState() => TransferItensState();
}

class TransferItensState extends State<TransferItens> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadCheckboxState(); // estado inicial
  }

  // carrega o estado do checkbox
  void _loadCheckboxState() async {
    int itemId = widget._addItems.id ?? 0;
    bool state = await widget._controller.loadCheckboxState(itemId);
    setState(() {
      isChecked = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: isChecked ? Colors.black54 : null,
        ),
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(widget._addItems.items.toString()),
          subtitle: Text(widget._addItems.quantity.toString()),
          onChanged: (bool? value) async {
            setState(() {
              isChecked = value ?? false;
            });
            await widget._controller.saveCheckboxState(widget._addItems.id ?? 0, isChecked);
          },
          value: isChecked,
        ),
      ),
    );
  }
}


