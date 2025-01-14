
import 'package:flutter/material.dart';
import 'package:lista_facil/ui/core/themes/icons.dart';
import 'package:lista_facil/ui/create_items/view_model/create_items_view_model.dart';
import 'package:lista_facil/ui/core/themes/colors.dart';

class AppBarItens extends StatelessWidget {
  final bool isSearchActive;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final String title;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String hintText;
  final Widget? child;
  final Color? color;
  final double? budget;
  final ValueNotifier<double>? totalNotifier;
  final CreateItemsViewModel controller; 

  const AppBarItens({
    super.key,
    required this.isSearchActive,
    required this.onBack,
    required this.onSearch,
    required this.title,
    this.searchController,
    this.onSearchChanged,
    required this.hintText,
    this.child,
    this.color,
    this.budget,
    this.totalNotifier,
    required this.controller 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? ThemeColor.colorWhite,
        boxShadow: [
          BoxShadow(
            color: ThemeColor.colorBlueGradient.withValues(alpha: 0.9),
            spreadRadius: 3,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  color: ThemeColor.colorBlueTema,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: isSearchActive
                        ? TextField(
                            key: const ValueKey(1),
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: hintText,
                              hintStyle:
                                 TextStyle(color: ThemeColor.colorBlueItemNaoSel),
                              filled: true,
                              fillColor: ThemeColor.colorWhite70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: ThemeColor.colorBlueTema, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                    color: ThemeColor.colorBlueTema, width: 1.5),
                              ),
                            ),
                            style: TextStyle(color: ThemeColor.colorBlueTema),
                            onChanged: onSearchChanged,
                          )
                        : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                              title,
                              key: const ValueKey(2),
                              style: TextStyle(
                                color: ThemeColor.colorBlueTema,
                                fontSize: 24,
                                fontWeight: FontWeight.w400
                              ),
                              textAlign: TextAlign.start,
                            ),
                        ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onSearch,
                      icon: Icon(
                        isSearchActive ? Icons.close : Icons.search,
                        color: isSearchActive
                            ? ThemeColor.colorBlueItemNaoSel
                            : ThemeColor.colorBlueTema,
                      ),
                    ),
                    PopupMenuButton<int>(
                      position: PopupMenuPosition.over,
                      color: ThemeColor.colorBlueTema,
                      icon: Icon(
                        Icons.more_vert,
                        color: ThemeColor.colorBlueTema,
                      ),
                      onSelected: (value) {
                        switch (value) {
                          case 1:
                            controller.sortItems(!controller.isAscending);
                            break;
                          case 2:
                            controller.shareItems(
                                      controller.quantityItems.value);
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
                                  color: ThemeColor.colorWhite
                                ),),
                                Icon(CustomIcons.alphabetic, size: 28),
                                    
                              ],
                            )),
                        PopupMenuItem(
                            value: 2,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Compartilhar",
                                  style: TextStyle(
                                      color: ThemeColor.colorWhite),
                                ),
                                SizedBox(width: 20,),
                                Icon(
                                  Icons.share,
                                  size: 28,
                                ),
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Seu conteúdo adicional
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: const BoxDecoration(
                    color: ThemeColor.colorWhite,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        budget != null ? "Orçamento " : "Orçamento não definido",
                        style: TextStyle(
                          fontSize: 19.0,
                          color: ThemeColor.colorBlueTema,
                        ),
                      ),
                      Text(
                        budget != null ? "R\$ $budget" : "",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: ThemeColor.colorBlueTema,
                        ),
                      ),
                    ],
                  ),
                ),
                if (totalNotifier != null)
                  ValueListenableBuilder<double>(
                    valueListenable: totalNotifier!,
                    builder: (context, total, _) {
                      Color? colorTotalGasto;

                      if (budget != null && total > budget!) {
                        colorTotalGasto = ThemeColor.colorRed800;
                      } else {
                        colorTotalGasto = ThemeColor.colorGreenTotal;
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        decoration: const BoxDecoration(
                          color: ThemeColor.colorWhite,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Total gasto",
                                style: TextStyle(
                                  fontSize: 19.0,
                                  color: ThemeColor.colorGreenTotal,
                                ),
                              ),
                            ),
                            Text(
                              "R\$ $total",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: colorTotalGasto,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
