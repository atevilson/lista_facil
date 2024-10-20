import 'package:flutter/material.dart';
import 'package:lista_facil/screens/app_home.dart';

void main() {
  runApp(const MyApplication());
}

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ListCollections(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white60,
        canvasColor: Colors.white12,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black45, foregroundColor: Colors.white70),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Colors.black45,
            ),
            foregroundColor: WidgetStatePropertyAll(
              Colors.white70,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white70,
          titleTextStyle: TextStyle(
            color: Colors.grey,
            fontSize: 24.0,
          ),
        ),
        listTileTheme: ListTileThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12.0,
              ),
            ),
            textColor: Colors.white70,
            tileColor: Colors.black),
        checkboxTheme: const CheckboxThemeData(
          fillColor: WidgetStatePropertyAll(Colors.black),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black45),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black45),
          ),
          labelStyle: TextStyle(color: Colors.black),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.black,
          selectionHandleColor: Colors.black,
        ),
        useMaterial3: true,
        dialogTheme: DialogTheme(
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
          contentTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 24.0,
            ),
            backgroundColor: Colors.white54, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white70
          )
      ),
    );
  }
}
