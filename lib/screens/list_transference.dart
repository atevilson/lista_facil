import 'package:flutter/material.dart';
import 'package:my_app/models/transference.dart';
import 'package:my_app/screens/transfer_form.dart';

const titleAppBar = 'Itens da lista';

class listTransference extends StatefulWidget {
  final List<Transference> _transferenceList = [];

  @override
  State<StatefulWidget> createState() {
    return createStateTransferList();
  }
}

class createStateTransferList extends State<listTransference> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 21, 92, 24),
        title: const Text(titleAppBar),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: widget._transferenceList.length,
        itemBuilder: (context, index) {
          final newTransferences = widget._transferenceList[index];
          return transferItens(newTransferences);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return transferForm();
          })).then((newTransfer) {
            if (newTransfer != null) {
              widget._transferenceList.add(newTransfer);
              setState(() {});
            }
          });
        },
        backgroundColor: Color.fromARGB(255, 21, 92, 24),
        foregroundColor: Colors.white,
        hoverColor: Colors.lightGreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class transferItens extends StatefulWidget {
  final Transference _addItems;

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
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(widget._addItems.purchaseItem.toString()),
          subtitle: Text(widget._addItems.quantityOfItem.toString()),
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
