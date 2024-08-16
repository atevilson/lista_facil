
import 'package:flutter/material.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

class MenuItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  const MenuItem(
    this.name,
    this.icon, {super.key, 
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: UtilColors.instance.colorWhite.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 4,
                  offset: const Offset(0,2)
                )
              ]
            ),
            padding: const EdgeInsets.all(8.0),
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    color: UtilColors.instance.colorRed,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  icon,
                  color: UtilColors.instance.colorRed,
                  size: 28.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}