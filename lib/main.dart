import 'package:flutter/material.dart';
import 'package:my_app/screens/list_form.dart';
//import 'package:my_app/screens/list_transference.dart';

void main() => runApp(myApplication());

class myApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: listCreateForm(),
    );
  }
}

