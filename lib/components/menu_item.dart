
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
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset.zero,
                )
              ]
            ),
            padding: const EdgeInsets.all(3.0),
            width: (screenFlex * 0.33),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: Colors.white70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      icon,
                      size: 28.0,
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