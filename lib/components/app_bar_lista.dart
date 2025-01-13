
import 'package:flutter/material.dart';
import 'package:lista_facil/components/custom_icons.dart';
import 'package:lista_facil/controllers/list_controller.dart';
import 'package:lista_facil/screens/widgets/report_screen.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

class AppBarCustom extends StatelessWidget {
  final bool isSearchActive;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final String title;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String hintText; 
  final Widget? child;
  final Color? color;
  final ListController controller;

  const AppBarCustom({super.key, 
    required this.isSearchActive,
    required this.onBack,
    required this.onSearch,
    required this.title,
    this.searchController,
    this.onSearchChanged,
    required this.hintText,
    this.child,
    this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: ThemeColor.colorBlueAccent.withValues(alpha: 0.9),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 4)
          )
        ]
      ),
      height: 118,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back),
              color: ThemeColor.colorWhite,
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 350),
                child: isSearchActive ? TextField(
                        key: const ValueKey(1),
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: const TextStyle(color: ThemeColor.colorWhite60),
                          filled: true,
                          fillColor: ThemeColor.colorTransparent,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                                color: ThemeColor.colorWhite60, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(
                                color: ThemeColor.colorWhite, width: 1.5),
                          ),
                        ),
                        style: const TextStyle(color: ThemeColor.colorWhite),
                        onChanged: onSearchChanged,
                      )
                    : Text(
                        title,
                        key: const ValueKey(2),
                        style: const TextStyle(
                          color: ThemeColor.colorWhite,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isSearchActive ? Icons.close : Icons.search,
                    color: isSearchActive
                        ? ThemeColor.colorWhite
                        : ThemeColor.colorWhite60,
                  ),
                  onPressed: onSearch,
                ),
                PopupMenuButton<int>(
                      position: PopupMenuPosition.over,
                      color: ThemeColor.colorBlueScafold,
                      icon: Icon(
                        Icons.more_vert,
                        color: ThemeColor.colorWhite,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            controller.sortItems(!controller.isAscending);
                            break;
                          case 2:
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen()));
                            break;
                          default:
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Ordenar",
                                style: TextStyle(
                                  color: ThemeColor.colorBlueTema
                                ),),
                                Icon(CustomIcons.alphabetic, size: 28, color: ThemeColor.colorBlueTema),
                              ],
                            )),
                        PopupMenuItem(
                            value: 2,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Relatórios",
                                  style: TextStyle(
                                      color: ThemeColor.colorBlueTema),
                                ),
                                Icon(
                                  Icons.report,
                                  size: 28,
                                  color: ThemeColor.colorBlueTema,
                                ),
                              ],
                            ))
                      ],
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}