import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lista_facil/components/app_bar_itens.dart';
import 'package:lista_facil/controllers/item_controller.dart';
import 'package:lista_facil/controllers/list_controller.dart';
import 'package:lista_facil/models/new_items.dart';
import 'package:lista_facil/models/new_lists.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

const titleAppBar = 'Itens';

class CreatedItens extends StatefulWidget {
  final NewLists list;
  final ListController listController;
  const CreatedItens(this.list, {super.key, required this.listController});

  @override
  State<CreatedItens> createState() => _CreatedItensState();
}

class _CreatedItensState extends State<CreatedItens> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false; 
  late ItemController _controller;
  List<NewItems> _filteredItems = [];
  
  // Variáveis para controle do formulário
  bool _showCreateForm = false;
  bool _isEditing = false;
  bool _isDelete = false;
  NewItems? _itemEdit;
  String _searchQuery = "";

  // Controladores dos campos do formulário de itens
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemQuantityController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = ItemController(widget.list, widget.listController);
    _controller.init();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _itemNameController.dispose();
    _itemQuantityController.dispose();
    _itemPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
  
    return Scaffold(
      backgroundColor: ThemeColor.colorBlueScafold,
      body: Column(
        children: [
          AppBarItens(
            title: "$titleAppBar ${widget.list.nameList.toLowerCase()}",
            isSearchActive: _isSearchActive,
            searchController: _searchController,
            onSearch: _togleSearch,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;             
              });
              _searchList(query);
            },
            onBack: () => Navigator.of(context).pop(),
            hintText: "Buscar item",
            color: ThemeColor.colorWhite,
            budget: widget.list.budget,
            totalNotifier: _controller.total, 
            controller: _controller,
          ),
          Expanded(
  child: _filteredItems.isEmpty
      ? ValueListenableBuilder<List<NewItems>>(
          valueListenable: _controller.quantityItems,
          builder: (context, items, _) {
            bool showNoItems = _isSearchActive
                ? _filteredItems.isEmpty && _searchQuery.isNotEmpty
                : items.isEmpty;

            if (showNoItems) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      _isSearchActive ? Icons.search_off : Icons.warning,
                      color: ThemeColor.colorBlue,
                      size: 50.0,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      _isSearchActive
                          ? 'Nenhum item encontrado'
                          : 'Nenhum item adicionado',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: ThemeColor.colorBlue,
                      ),
                    ),
                  ],
                ),
              );
            }

            // lista de itens filtrados se houver itens
            List<NewItems> listToShow = _isSearchActive && _filteredItems.isNotEmpty ? _filteredItems : items;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              itemCount: listToShow.length,
              itemBuilder: (context, index) {
                final NewItems item = listToShow[index];
                return _CollectionItems(
                  item: item,
                  onEdit: () => _showEditForm(item),
                  onDelete: () => _showDeleteConfirmation(item),
                  controller: _controller,
                );
              },
            );
          },
        )
      : ListView.builder(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 8.0),
          itemCount: _filteredItems.length,
          itemBuilder: (context, index) {
            final NewItems item = _filteredItems[index];
            return _CollectionItems(
              item: item,
              onEdit: () => _showEditForm(item),
              onDelete: () => _showDeleteConfirmation(item),
              controller: _controller,
            );
          },
        ),
),
          if (_showCreateForm)
            Expanded(
              child: Container(
                color: ThemeColor.colorWhite,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _isDelete
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 150),
                            Text(
                              "Deseja excluir o item \"${_itemEdit?.items}\" ?",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: ThemeColor.colorBlueTema,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _deleteItem(),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    backgroundColor: ThemeColor.colorBlueTema, 
                                    minimumSize: const Size(140, 50)
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: ThemeColor.colorWhite,
                                  ),
                                ),
                                const SizedBox(width: 40),
                                ElevatedButton(
                                  onPressed: () => setState(() {
                                    _showCreateForm = false;
                                    _isDelete = false; 
                                  }),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    backgroundColor: ThemeColor.colorWhite,
                                    minimumSize: const Size(140, 50),
                                    side: const BorderSide(color: ThemeColor.colorBlue, width: 2)
                                  ), 
                                  child: const Icon(Icons.close, color: ThemeColor.colorBlue)
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              _isEditing ? "Editar item" : "Novo item",
                              style: TextStyle(
                                letterSpacing: 3.0,
                                fontWeight: FontWeight.w800,
                                color: ThemeColor.colorBlueTema,
                                fontSize: 18,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: screenHeight * 0.015),
                              width: screenWidth * 0.88,
                              height: screenHeight * 0.002,
                              decoration: BoxDecoration(
                                color: ThemeColor.colorBlueTema,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: _itemNameController,
                              cursorColor: ThemeColor.colorBlue,
                              decoration: InputDecoration(
                                labelText: "Nome do Item",
                                labelStyle: TextStyle(
                                  color: ThemeColor.blueShade700,
                                  fontWeight: FontWeight.w500,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: ThemeColor.blueShade700, width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: ThemeColor.blueShade200, width: 1.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: ThemeColor.blueShade700,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextField(
                              controller: _itemQuantityController,
                              cursorColor: ThemeColor.colorBlue,
                              decoration: InputDecoration(
                                labelText: "Quantidade",
                                labelStyle: TextStyle(
                                  color: ThemeColor.blueShade700,
                                  fontWeight: FontWeight.w500,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: ThemeColor.blueShade700, width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: ThemeColor.blueShade200, width: 1.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: ThemeColor.blueShade700,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextField(
                              controller: _itemPriceController,
                              cursorColor: ThemeColor.colorBlue,
                              decoration: InputDecoration(
                                labelText: "Preço (opcional)",
                                labelStyle: TextStyle(
                                  color: ThemeColor.blueShade700,
                                  fontWeight: FontWeight.w500,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: ThemeColor.blueShade700, width: 1.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  borderSide: BorderSide(color: ThemeColor.blueShade200, width: 1.5),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: ThemeColor.blueShade700,
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isEditing ? () => _saveEditItem(context) : () => _createNewItem(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ThemeColor.colorBlueTema,
                                ),
                                child: Text(
                                  _isEditing ? "Salvar" : "Criar novo item",
                                  style: const TextStyle(fontSize: 18.0, color: ThemeColor.colorWhite),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _showCreateForm = !_showCreateForm; 
                                    _clearFields();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  backgroundColor: ThemeColor.colorBlueTema,
                                ),
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: ThemeColor.colorWhite),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          SingleChildScrollView(
            child: Container(
              height: _isEditing || _showCreateForm ? 20 : 150,
              color: ThemeColor.colorWhite,
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: !_showCreateForm
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showCreateForm = !_showCreateForm; 
                              _clearFields();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            backgroundColor: ThemeColor.colorBlueTema,
                          ),
                          child: const Text(
                            "Criar novo item",
                            style: TextStyle(fontSize: 18.0, color: ThemeColor.colorWhite),
                          ),
                        )
                      : null
                ),
              ),
            )
          ),
        ],
      ),
    );
  }

  void _togleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _filteredItems.clear();
      }
    });
  }

  void _searchList(String query) {
    if(query.isEmpty){
      setState(() {
        _filteredItems.clear();
      });
    }
    _controller.searchItemByName(query).then((filteredItems) {
      setState(() {
        _filteredItems = filteredItems;
      });
    });
  }

  void _showEditForm(NewItems item) {
    setState(() {
      _isEditing = true;
      _itemEdit = item;
      _itemNameController.text = item.items;
      _itemQuantityController.text = item.quantity.toString();
      _itemPriceController.text = item.price?.toStringAsFixed(2) ?? "";
      _showCreateForm = true;
    });
  }

  void _showDeleteConfirmation(NewItems item) {
    setState(() {
      _isDelete = true;
      _itemEdit = item;
      _showCreateForm = true;
    });
  }

  Future<void> _deleteItem() async {
    if (_isDelete && _itemEdit != null && _itemEdit!.id != null) {
      await _controller.deleteItem(_itemEdit!);
      setState(() {
        _clearFormState();
      });
    }
  }

  Future<void> _createNewItem(BuildContext context) async {
    final String itemName = _itemNameController.text.trim();
    final int? quantity = int.tryParse(_itemQuantityController.text.trim());
    final double? price = double.tryParse(_itemPriceController.text.trim());

    if (itemName.isNotEmpty && quantity != null){
      NewItems? existingItem = widget.listController.getLayoffItemByName(itemName);
      if (existingItem != null) {

      bool? userChoice = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: ThemeColor.colorBlueTema,
          title: Center(child: const Text("Atenção", style: TextStyle(fontSize: 30.0))),
          content: Text(
              "O item \"$itemName\" já possui \"${existingItem.quantity}\" unidades na dispensa.",
              style: TextStyle(fontWeight: FontWeight.w400)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),  
              child: Text("Confirmar", style: TextStyle(color: ThemeColor.colorBlueTema)),
            ),
            SizedBox(width: 10,),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),  
              child: Text("Editar", style: TextStyle(color: ThemeColor.colorBlueTema)),
            ),
          ],
        ),
      );
      if(userChoice == true){
        return;
      }
    }

    final newItem = NewItems(
      items: itemName,
      quantity: quantity,
      price: price ?? 0.0,
      listId: widget.list.id,
    );
    await _controller.saveItem(newItem);
    setState(() {
      _clearFormState();
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ThemeColor.colorRed800,
        content: const Text(
          "Por favor, preencha todos os campos corretamente.",
          style: TextStyle(color: ThemeColor.colorWhite, fontSize: 14.0),
        ),
      ),
    );
  }
}

  Future<void> _saveEditItem(BuildContext context) async {
    if (_itemNameController.text.isNotEmpty &&
        int.tryParse(_itemQuantityController.text) != null) {
      final int newQuantity = int.parse(_itemQuantityController.text);
      final double newPrice = double.tryParse(_itemPriceController.text.trim()) ?? 0.0;

      final updateItem = NewItems(
        id: _itemEdit?.id,
        items: _itemNameController.text,
        quantity: newQuantity,
        price: newPrice,
        listId: widget.list.id,
        isChecked: _itemEdit?.isChecked ?? false,
      );
      await _controller.updateItem(updateItem);
      setState(() {
        _clearFormState();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ThemeColor.colorRed800,
          content: const Text(
            'Por favor, preencha todos os campos corretamente.',
            style: TextStyle(color: ThemeColor.colorWhite, fontSize: 14.0),
          ),
        ),
      );
    }
  }

  void _clearFormState() {
    _showCreateForm = false;
    _isEditing = false;
    _isDelete = false;
    _itemEdit = null;
    _clearFields();
  }

  void _clearFields() {
    _itemNameController.clear();
    _itemQuantityController.clear();
    _itemPriceController.clear();
  }

}


class _CollectionItems extends StatelessWidget {
  final NewItems item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ItemController controller;

  const _CollectionItems({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(item.id.toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(),
            backgroundColor: ThemeColor.colorWhite,
            foregroundColor: ThemeColor.colorBlueTema,
            icon: Icons.edit,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(),
            backgroundColor: ThemeColor.colorWhite,
            foregroundColor: ThemeColor.colorBlueTema,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Card(
        elevation: 5,
        child: ListTile(
          tileColor: item.isChecked ? ThemeColor.colorBlueTema : ThemeColor.colorBlueItemNaoSel,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                fillColor: WidgetStatePropertyAll(
                  item.isChecked ? ThemeColor.colorWhite : ThemeColor.colorBlueScafold,
                ),
                value: item.isChecked, // Nunca será null
                onChanged: (bool? value) async {
                  bool isChecked = value ?? false;

                  if (isChecked) {
                    if (item.price! > 0.0) {
                      await controller.priceCheckerAndUpdater(item.id!, true, item.price!);
                    } else {
                      String valor = "";
                      final double? price = await showDialog<double>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: ThemeColor.colorBlueTema,
                          title: Text(
                            "Insira o preço do ${item.items}",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: ThemeColor.colorWhite,
                            ),
                          ),
                          content: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: "Valor (R\$)"),
                            onChanged: (input) {
                              valor = input.trim().replaceAll(",", ".");
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: ThemeColor.colorBlue,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                final formatPrices = RegExp(r'^\d+(\.\d{0,2})?$');

                                if (formatPrices.hasMatch(valor) && valor.isNotEmpty) {
                                  Navigator.of(context).pop(double.tryParse(valor));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: ThemeColor.colorRed800,
                                      content: const Text(
                                        'Insira um preço válido!',
                                        style: TextStyle(color: ThemeColor.colorWhite),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                  color: ThemeColor.colorBlueTema,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (price != null) {
                        await controller.priceCheckerAndUpdater(item.id!, true, price);
                      } else {
                        await controller.priceCheckerAndUpdater(item.id!, false, 0.0);
                      }
                    }
                  } else {
                    await controller.priceCheckerAndUpdater(
                      item.id!,
                      false,
                      item.price!,
                    );
                  }
                },
                activeColor: ThemeColor.colorWhite,
                checkColor: ThemeColor.colorBlueTema,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.items,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: ThemeColor.colorWhite,
                    ),
                  ),
                  Text(
                    "Quantidade: ${item.quantity}",
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: ThemeColor.colorWhite,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Text(
            'R\$ ${item.price!.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 15.0,
              color: ThemeColor.colorWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
