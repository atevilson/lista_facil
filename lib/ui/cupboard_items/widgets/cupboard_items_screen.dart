
// add_layoff_items.dart

import 'package:flutter/material.dart';
import 'package:lista_facil/domain/models/items.dart';
import 'package:lista_facil/ui/core/themes/colors.dart';
import 'package:lista_facil/ui/create_lists/view_model/create_list_view_model.dart';

class CupboardItemsScreen extends StatefulWidget {

  const CupboardItemsScreen({super.key, required this.viewModelList});

  final CreateListViewModel viewModelList;

  @override
  State<CupboardItemsScreen> createState() => _CupboardItemsScreenState();
}

class _CupboardItemsScreenState extends State<CupboardItemsScreen> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final List<Items> _layoffItems = [];



  @override
  void dispose() {
    _itemNameController.dispose();
    _itemQuantityController.dispose();
    super.dispose();
  }

  void _addItem() {
    final String name = _itemNameController.text.trim();
    final int? quantity = int.tryParse(_itemQuantityController.text.trim());

    if (name.isNotEmpty && quantity != null && quantity > 0) {
      setState(() {
        _layoffItems.add(Items(items: name, quantity: quantity, listId: 0));
      });
      _itemNameController.clear();
      _itemQuantityController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ThemeColor.colorBlueTema,
          content: const Text(
            "Por favor, preencha todos os campos corretamente.",
            style: TextStyle(color: ThemeColor.colorWhite),
          ),
        ),
      );
    }
  }

  void _saveLayoffItems() {
    if (_layoffItems.isNotEmpty) {
      widget.viewModelList.addLayoffItems(_layoffItems);
    }
    Navigator.of(context).pop(); // Retorna para a tela anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.colorBlueScafold,
      appBar: AppBar(
        title: const Text("Itens da dispensa",
        style: TextStyle(
          color: ThemeColor.colorWhite
        ),),
        backgroundColor: ThemeColor.colorBlueTema,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              cursorColor: ThemeColor.colorBlue,
              style: TextStyle(
                color: ThemeColor.colorBlueTema
              ),
              controller: _itemNameController,
              decoration: InputDecoration(   
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: ThemeColor.colorBlueTema
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: ThemeColor.colorBlueTema
                  )
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(45.0)
                ),            
                labelStyle: TextStyle(
                  color: ThemeColor.colorBlueTema
                ),
                labelText: "Nome do item",
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10),
            TextField(
              cursorColor: ThemeColor.colorBlue,
              style: TextStyle(
                color: ThemeColor.colorBlueTema
              ),
              controller: _itemQuantityController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: ThemeColor.colorBlueTema
                  )
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: ThemeColor.colorBlueTema
                  )
                ),
                labelStyle: TextStyle(
                  color: ThemeColor.colorBlueTema
                ),
                labelText: "Quantidade",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0)
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.colorBlueTema,
                  ),
                  child: const Text("Adicionar", style: TextStyle(
                    color: ThemeColor.colorWhite
                  ),),
                ),
                SizedBox(width: 25,),
                ElevatedButton(
                  onPressed: _saveLayoffItems,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColor.colorBlueTema,
                  ),
                  child: const Text("Finalizar", style: TextStyle(
                    color: ThemeColor.colorWhite
                  ),),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _layoffItems.isEmpty
                  ? const Center(
                      child: Text(
                        "Nenhum item adicionado.",
                        style: TextStyle(fontSize: 16.0, color: ThemeColor.colorBlue),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _layoffItems.length,
                      itemBuilder: (context, index) {
                        final item = _layoffItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
                            tileColor: ThemeColor.colorBlueItemNaoSel,
                            title: Text(item.items, style: TextStyle(color: ThemeColor.colorWhite, fontWeight: FontWeight.w500),),
                            subtitle: Text("Quantidade: ${item.quantity}", style: TextStyle(
                              color: ThemeColor.colorWhite, 
                              fontWeight: FontWeight.w500),),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: ThemeColor.colorWhite),
                              onPressed: () {
                                setState(() {
                                  _layoffItems.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
