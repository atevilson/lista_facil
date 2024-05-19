import 'package:flutter/material.dart';
import 'package:my_app/components/data_entry_number.dart';
import 'package:my_app/components/data_entry_text.dart';
import 'package:my_app/controllers/item_controller.dart';
import 'package:my_app/models/new_items.dart';
import 'package:my_app/utils_colors/utils_style.dart';

const _title = 'Adicionar item';
const dataEntryLabelOne = 'NOVO ITEM';
const dataEntryLabelTwo = 'QUANTIDADE';
const titleElevatedButton = 'ADICIONAR ITEM';

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
        appBar: appBarCustom(title: _title),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UtilColors.instance.colorRed,
                      foregroundColor: UtilColors.instance.colorWhite,
                    ),
                    onPressed: () => _createTransfer(context),
                    child: const Text(titleElevatedButton),
                  ),
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
