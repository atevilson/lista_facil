import 'package:flutter/material.dart';

class UtilColors {
  static final UtilColors _utilColorsStyle = UtilColors._internal();
  UtilColors._internal();
  static UtilColors get instance {
    return _utilColorsStyle;
  }
  final Color colorWhite = Colors.white;
  final Color colorBlack = Colors.black;
  final Color colorError = const Color.fromARGB(255, 255, 0, 25);
  final Color colorRed =  Colors.red;
  final Color colorContainer = const Color.fromARGB(255, 224, 5, 5);
  final Color textFocus = Colors.transparent;
  final Color colorGray = Colors.grey;


  }

  AppBar appBarCustom(
      {Widget? leading,
      required String title,
      Widget? child,
      bool automaticallyImplyLeading = true,
      Widget? actionSuffixIcon,
      PreferredSizeWidget? bottomApp,
      bool centerTitle = false,
      Widget? actionLeadingIcon,
      double? heigth,
      double? fontSize,
}) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: UtilColors.instance.colorRed,
      foregroundColor: UtilColors.instance.colorWhite,

      centerTitle: centerTitle,
      elevation: 0,
      leading: leading,
      toolbarHeight: heigth,
      bottom: bottomApp,
      title: title != ""
          ? Text(
              title.toUpperCase(),
              maxLines: 3,
              style: textStyleAppbar(fontSize: fontSize ?? 22, 
              color: UtilColors.instance.colorWhite),
            )
          : child ?? const SizedBox.shrink(),
    );
  }

  TextStyle textStyleCustom(
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return TextStyle(
      color: color ?? Colors.white,
      fontWeight: fontWeight,
      fontSize: fontSize ?? 24,
    );
  }

  TextStyle textStyleAppbar(
      {Color? color,
      double fontSize = 15,
      FontWeight fontWeight = FontWeight.w600}) {
    return TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

