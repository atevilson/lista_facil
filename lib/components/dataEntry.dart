


import 'package:flutter/material.dart';

class DataEntry extends StatelessWidget {
  final TextEditingController itemController;
  final String itemLabel;
  final IconData iconAll;

DataEntry(this.itemLabel, this.itemController, this.iconAll);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(9.0),
      child: TextField(
        controller: itemController,
        decoration: InputDecoration(
            icon: Icon(iconAll),
            iconColor: Colors.green,
            labelText: itemLabel,
            labelStyle: TextStyle(color: Colors.grey, fontSize: 16.0)),
        keyboardType: TextInputType.text,
      ),
    );
  }
}