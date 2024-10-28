import 'package:flutter/material.dart';
import 'package:lista_facil/components/custom_icons.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

class DataEntryText extends StatelessWidget {
  final TextEditingController itemController;
  final String itemLabel;
  final IconData iconAll;

  const DataEntryText(this.itemLabel, this.itemController, this.iconAll,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: TextField(
        controller: itemController,
        cursorColor: UtilColors.colorBlack,
        decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: UtilColors.colorBlack),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: UtilColors.colorBlack),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: UtilColors.colorBlack),
            ),
            labelStyle: const TextStyle(color: UtilColors.colorBlack),
            hintStyle: const TextStyle(color: UtilColors.colorBlack),
            icon:  const Icon(CustomIcons.novoItem),
            labelText: itemLabel),
        keyboardType: TextInputType.text,
        style: const TextStyle(fontSize: 22.0, color: UtilColors.colorBlack),
      ),
    );
  }
}
