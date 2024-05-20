import 'package:flutter/material.dart';
import 'package:my_app/screens/app_home.dart';
import 'package:my_app/utils_colors/utils_style.dart';

void main() {
  runApp(const myApplication());
}

class myApplication extends StatelessWidget {
  const myApplication({super.key});

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
     home: listCollections(),
    );
  }
}
