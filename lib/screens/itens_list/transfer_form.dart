import 'package:flutter/material.dart';
import 'package:lista_facil/components/data_entry_number.dart';
import 'package:lista_facil/components/data_entry_text.dart';
import 'package:lista_facil/controllers/item_controller.dart';
import 'package:lista_facil/models/new_items.dart';

const _title = 'Adicionar item';
const dataEntryLabelOne = 'NOVO ITEM';
const dataEntryLabelTwo = 'QUANTIDADE';
const titleElevatedButton = 'ADICIONAR ITEM';

class TransferForm extends StatefulWidget {
  final ItemController controller;
  const TransferForm(this.controller, {super.key});

  @override
  State<TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  
  final TextEditingController _items = TextEditingController();
  final TextEditingController _quantity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: DataEntryText(
                      dataEntryLabelOne, _items, 
                      Icons.add_shopping_cart),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: DataEntryNumber(dataEntryLabelTwo, _quantity,
                      Icons.add_shopping_cart),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: () => _createItens(),
                    child: const Text(titleElevatedButton),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createItens() async {
    final String items = _items.text;
    final int? quantity = int.tryParse(_quantity.text);

    if (items.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('O campo item esta vazio!'))
        );
        return;
    }

    if (quantity != null) {
      final NewItems addItem = NewItems(items: items, quantity: quantity);
      await widget.controller.saveItem(addItem);
        if (mounted) {
          Navigator.pop(context, addItem);
        }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insira um número válido!'),
        ),
      );
    }
  }
}
