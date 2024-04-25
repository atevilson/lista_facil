import 'package:flutter/material.dart';
import 'package:my_app/screens/list_collections.dart';

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
