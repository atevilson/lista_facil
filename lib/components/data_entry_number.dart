import 'package:flutter/material.dart';
import 'package:lista_facil/components/custom_icons.dart';

class DataEntryNumber extends StatelessWidget {
  final TextEditingController itemController;
  final String itemLabel;
  final IconData iconAll;


  const DataEntryNumber(this.itemLabel, this.itemController, this.iconAll, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: TextField(
        controller: itemController,
        decoration: InputDecoration(
            icon: const Icon(CustomIcons.quantidade), labelText: itemLabel),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
