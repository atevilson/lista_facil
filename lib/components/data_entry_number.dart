import 'package:flutter/material.dart';
import 'package:my_app/utils_colors/utils_style.dart';

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
            icon: Icon(iconAll),
            iconColor: UtilColors.instance.colorRed,
            labelText: itemLabel,
            labelStyle:  TextStyle(color: UtilColors.instance.colorGray, fontSize: 16.0)),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
