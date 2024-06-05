import 'package:flutter/material.dart';
import 'package:lista_facil/screens/app_home.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

void main() {
  runApp(const MyApplication());
}

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme:  InputDecorationTheme(
          labelStyle: TextStyle(color: UtilColors.instance.colorRed),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: UtilColors.instance.colorRed, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: UtilColors.instance.colorGray, width: 1.0),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
     home: const ListCollections(),
    );
  }
}
