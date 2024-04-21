import 'package:flutter/material.dart';
import 'package:my_app/components/dataEntry.dart';
import 'package:my_app/models/transference.dart';

const titleAppBar = 'Adicionar item';
const dataEntryLabelOne = 'Adicionar item';
const dataEntryLabelTwo = 'Quantidade';
const titleElevatedButton = 'Adicionar';

class transferForm extends StatelessWidget {
  transferForm({super.key});

  final TextEditingController _purchaseItemController = TextEditingController();
  final TextEditingController _quantityOfItemController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(titleAppBar),
          backgroundColor: const Color.fromARGB(255, 21, 92, 24),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              DataEntry(dataEntryLabelOne, _purchaseItemController,
                  Icons.add_shopping_cart),
              DataEntry(dataEntryLabelTwo, _quantityOfItemController,
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
        ));
  }

  void _createTransfer(BuildContext context) {
    final purchaseItem = _purchaseItemController.text;
    final int? quantityOfItem = int.tryParse(_quantityOfItemController.text);
    if (quantityOfItem != null) {
      final createTransferences = Transference(purchaseItem, quantityOfItem!);
      Navigator.pop(context, createTransferences);
    }
  }
}
