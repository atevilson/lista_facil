import 'package:flutter/material.dart';
import 'package:my_app/controllers/item_controller.dart';
import 'package:my_app/models/new_items.dart';
import 'package:my_app/models/new_lists.dart';
import 'package:my_app/screens/itens_list/transfer_form.dart';
import 'package:my_app/utils_colors/utils_style.dart';

const titleAppBar = 'Itens da lista';

class listTransference extends StatefulWidget {
  final NewLists list;
  listTransference(this.list);
  @override
  State<StatefulWidget> createState() {
    return createStateTransferList();
  }
}

class createStateTransferList extends State<listTransference> {
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
        backgroundColor: UtilColors.instance.colorRed,
        foregroundColor: UtilColors.instance.colorWhite,
        title: Text(titleAppBar.toUpperCase()),
        titleTextStyle: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: UtilColors.instance.colorWhite),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.share),
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                ascendingOrder = result == 'Ordenar A-Z';
                _controller.sortItems(ascendingOrder);
              });
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
              return Dismissible(
                key: Key(item.id.toString()),
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
                          "Excluir o item ?",
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
                onDismissed: (direction) {
                  _controller.deleteItem(item).then((_) {
                    setState(() {});
                  });
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: transferItens(item),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final savedItem = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return transferForm(_controller);
          }));
          if (savedItem != null) {
            setState(() {});
          }
        },
        shape: const CircleBorder(),
        backgroundColor: UtilColors.instance.colorRed,
        foregroundColor: UtilColors.instance.colorWhite,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class transferItens extends StatefulWidget {
  final NewItems _addItems;

  const transferItens(this._addItems, {Key? key}) : super(key: key);

  @override
  _transferItensState createState() => _transferItensState();
}

class _transferItensState extends State<transferItens> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: isChecked ? Colors.black12 : Colors.grey[200],
          border: Border.all(color: Colors.black26),
        ),
        child: CheckboxListTile(
          activeColor: UtilColors.instance.colorRed,
          checkColor: Colors.white,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(widget._addItems.items.toString()),
          subtitle: Text(widget._addItems.quantity.toString()),
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
          value: isChecked,
        ),
      ),
    );
  }
}
