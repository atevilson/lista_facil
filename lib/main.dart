import 'package:flutter/material.dart';
import 'package:my_app/screens/app_home.dart';

void main() {
  runApp(myApplication());
}

class myApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: listCollections(),
    );
  }
}
