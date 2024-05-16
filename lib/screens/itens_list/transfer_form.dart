import 'package:flutter/material.dart';
import 'package:my_app/components/dataEntryNumber.dart';
import 'package:my_app/components/dataEntryText.dart';
import 'package:my_app/controllers/item_controller.dart';
import 'package:my_app/models/new_items.dart';

const titleAppBar = 'Adicionar item';
const dataEntryLabelOne = 'Novo item';
const dataEntryLabelTwo = 'Quantidade';
const titleElevatedButton = 'Adicionar';

class transferForm extends StatefulWidget {
  final ItemController controller;
  transferForm(this.controller, {super.key});

  @override
  State<transferForm> createState() => _transferFormState();
}

class _transferFormState extends State<transferForm> {
  final TextEditingController _items = TextEditingController();

  final TextEditingController _quantity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(titleAppBar),
          backgroundColor: const Color.fromARGB(255, 21, 92, 24),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DataEntryText(
                    dataEntryLabelOne, _items, Icons.add_shopping_cart),
                DataEntryNumber(dataEntryLabelTwo, _quantity,
                    Icons.production_quantity_limits_outlined),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 21, 92, 24),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _createTransfer(context),
                  child: const Text(titleElevatedButton),
                )
              ],
            ),
          ),
        ));
  }

  void _createTransfer(BuildContext context) {
    final String items = _items.text;
    final int? quantity = int.tryParse(_quantity.text);

    if (quantity != null) {
      final NewItems addItem = NewItems(items: items, quantity: quantity);
      widget.controller.saveItem(addItem).then((_) {
        Navigator.pop(context, addItem);
      });
    }
  }
}
