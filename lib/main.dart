import 'package:flutter/material.dart';
import 'package:lista_facil/config/injection_dep.dart';
import 'package:lista_facil/ui/core/ui/splash_screen.dart';
import 'package:lista_facil/ui/core/themes/colors.dart';

void main() {
  injectionDep();
  runApp(const MyApplication());
}

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: ThemeColor.colorWhite)
        ),
        scaffoldBackgroundColor: const Color.fromRGBO(3, 119, 253, 1),
        canvasColor: ThemeColor.colorWhite12,
        floatingActionButtonTheme:  const FloatingActionButtonThemeData(
          iconSize: 32.0,
          backgroundColor: ThemeColor.colorWhite70, 
          foregroundColor: ThemeColor.colorBlack),
        // elevatedButtonTheme: const ElevatedButtonThemeData(
        //   style: ButtonStyle(minimumSize: WidgetStatePropertyAll(Size(200, 200)),
        //     backgroundColor: WidgetStatePropertyAll(
        //       Color(0xFF0377FD),
        //     ),
        //     foregroundColor: WidgetStatePropertyAll(
        //       UtilColors.colorWhite70,
        //     ),
        //   ),
        // ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0377FD),
          foregroundColor: ThemeColor.colorWhite70,
          titleTextStyle: TextStyle(
            color: ThemeColor.colorGray,
            fontSize: 24.0,
          ),
        ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(color: Colors.blue, width: 1.0),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
        ),
        listTileTheme: ListTileThemeData(
                  shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
            textColor: ThemeColor.colorWhite,
            tileColor: ThemeColor.colorWhite,
            selectedTileColor: ThemeColor.colorBlack),
            //selectedTileColor: Colors.blue),
        checkboxTheme: CheckboxThemeData(
          splashRadius: 2.0,
          //fillColor: WidgetStatePropertyAll(ThemeColor.colorGreyCheckBox),
          //checkColor: const WidgetStatePropertyAll(ThemeColor.colorWhite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0)
          ),
          side: WidgetStateBorderSide.resolveWith((Set<WidgetState> states) {
            if(states.contains(WidgetState.selected)) {
              return BorderSide(
                color: ThemeColor.colorTransparent,
                width: 2.0
              );
            }
            return BorderSide(
              color: ThemeColor.colorBlueTema
            );
          })
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeColor.colorWhite),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeColor.colorWhite),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color:ThemeColor.colorWhite),
          ),
          labelStyle: TextStyle(color: ThemeColor.colorWhite),
          hintStyle: TextStyle(color: ThemeColor.colorWhite)
          
        ),
        hoverColor: ThemeColor.colorWhite,
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: ThemeColor.colorWhite,
            selectionColor: ThemeColor.colorWhite,
            selectionHandleColor: ThemeColor.colorWhite,
          ),
        useMaterial3: false,
        dialogTheme: DialogTheme(
          titleTextStyle: const TextStyle(
            color: ThemeColor.colorWhite,
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
              foregroundColor: WidgetStatePropertyAll(ThemeColor.colorBlack),
              backgroundColor: WidgetStatePropertyAll(ThemeColor.colorWhite),
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
            color: ThemeColor.colorGray
          ),
      ),
    );
  }
}
