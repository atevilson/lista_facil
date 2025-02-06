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
        scaffoldBackgroundColor: ThemeColor.colorBlueTema,
        checkboxTheme: CheckboxThemeData(
          splashRadius: 2.0,
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
        useMaterial3: false,
        dialogTheme: DialogTheme(
          titleTextStyle: const TextStyle(
            color: ThemeColor.colorWhite,
            fontSize: 26,
          ),
            backgroundColor: ThemeColor.colorBlueTema,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
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
          inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeColor.colorWhite70),
            borderRadius: BorderRadius.circular(25)
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeColor.colorWhite),
            borderRadius: BorderRadius.circular(25)
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
      ),
    );
  }
}
