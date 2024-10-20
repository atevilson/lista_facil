
import 'package:flutter/material.dart';

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

    double screenFlex = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 15, 35),
      child: Material(
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 9,
                  offset: Offset.fromDirection(5)
                )
              ]
            ),
            padding: const EdgeInsets.all(3.0),
            width: (screenFlex * 0.43),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.elliptical(13, 13),
                topLeft: Radius.elliptical(13, 13),
              ),
              child: Container(
                color: Colors.black,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.white70
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      icon,
                      size: 32.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}