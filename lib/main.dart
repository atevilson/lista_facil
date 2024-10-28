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
      home: const ListCollections(),
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: UtilColors.colorWhite)
        ),
        scaffoldBackgroundColor: UtilColors.colorWhite60,
        canvasColor: UtilColors.colorWhite12,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: UtilColors.colorBlueGrey800, foregroundColor: UtilColors.colorWhite),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              UtilColors.colorBlack45,
            ),
            foregroundColor: WidgetStatePropertyAll(
              UtilColors.colorWhite70,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: UtilColors.colorBlack,
          foregroundColor: UtilColors.colorWhite70,
          titleTextStyle: TextStyle(
            color: UtilColors.colorGray,
            fontSize: 24.0,
          ),
        ),
        listTileTheme: ListTileThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            textColor: UtilColors.colorWhite,
            //tileColor: Colors.black,
            selectedTileColor: UtilColors.colorBlack),
            //selectedTileColor: Colors.blue),
        checkboxTheme: CheckboxThemeData(
          splashRadius: 2.0,
          fillColor: const WidgetStatePropertyAll(UtilColors.colorBlack),
          checkColor: const WidgetStatePropertyAll(UtilColors.colorWhite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0)
          )
        ),
        inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: UtilColors.colorWhite),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: UtilColors.colorWhite),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color:UtilColors.colorWhite),
          ),
          labelStyle: TextStyle(color: UtilColors.colorWhite),
          hintStyle: TextStyle(color: UtilColors.colorWhite)
          
        ),
        hoverColor: UtilColors.colorWhite,
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: UtilColors.colorWhite,
            selectionColor: UtilColors.colorWhite,
            selectionHandleColor: UtilColors.colorWhite,
          ),
        useMaterial3: true,
        dialogTheme: DialogTheme(
          titleTextStyle: const TextStyle(
            color: UtilColors.colorWhite,
            fontSize: 26,
          ),
          contentTextStyle: const TextStyle(
              color: Colors.white70,
              fontSize: 20.0,
            ),
            backgroundColor: Colors.black, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: const WidgetStatePropertyAll(UtilColors.colorWhite),
              backgroundColor: WidgetStatePropertyAll(Colors.grey[600]),
              textStyle: const WidgetStatePropertyAll(
                TextStyle(fontSize: 19.0,
                fontWeight: FontWeight.w700)
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              )
            )
          ),
          popupMenuTheme: const PopupMenuThemeData(
            color: UtilColors.colorGray
          ),
          iconTheme: const IconThemeData(
            color: Colors.white70
          )
      ),
    );
  }
}
