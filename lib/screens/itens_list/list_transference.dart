import 'package:flutter/material.dart';
import 'package:my_app/controllers/item_controller.dart';
import 'package:my_app/models/new_items.dart';
import 'package:my_app/models/new_lists.dart';
import 'package:my_app/screens/itens_list/transfer_form.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = ItemController(widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 21, 92, 24),
        title: const Text(titleAppBar),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<NewItems>>(
        initialData: [],
        future: _controller.findItens(),
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
                  ],
                ),
              );
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<NewItems> items = snapshot.data ?? [];
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final NewItems item = items[index];
                  return transferItens(item);
                },
              );
          }
          if (snapshot.hasError) {
            return const Text("Internal Server Error");
          }
          return const Text("Lista vazia");
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
        backgroundColor: const Color.fromARGB(255, 21, 92, 24),
        foregroundColor: Colors.white,
        hoverColor: Colors.lightGreen,
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
          activeColor: Colors.green[900],
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
