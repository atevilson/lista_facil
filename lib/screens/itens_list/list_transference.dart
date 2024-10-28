import 'package:flutter/material.dart';
import 'package:lista_facil/components/dialog_custom.dart';
import 'package:lista_facil/controllers/item_controller.dart';
import 'package:lista_facil/models/new_items.dart';
import 'package:lista_facil/models/new_lists.dart';
import 'package:lista_facil/screens/itens_list/transfer_form.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

const titleAppBar = 'Itens';

class ListTransference extends StatefulWidget {
  final NewLists list;
  const ListTransference(this.list, {super.key});
  @override
  State<StatefulWidget> createState() {
    return CreateStateTransferList();
  }
}

class CreateStateTransferList extends State<ListTransference> {
  late ItemController _controller;
  bool ascendingOrder = true;

  @override
  void initState() {
    super.initState();
    _controller = ItemController(widget.list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$titleAppBar ${widget.list.nameList.toLowerCase()}"),
        actions: [
          IconButton(
            onPressed: () =>  {
               _controller.shareItems(_controller.quantityItems.value)
            },
            icon: const Icon(Icons.share),
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                ascendingOrder = result == 'Ordenar A-Z';
                _controller.sortItems(ascendingOrder);
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Ordenar A-Z',
                child: Text('Ordenar (A-Z)', 
                        style: TextStyle(
                          color: UtilColors.colorBlack, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 12.0)),
              ),
              const PopupMenuItem<String>(
                value: 'Ordenar Z-A',
                child: Text('Ordenar (Z-A)',
                style: TextStyle(
                          color: UtilColors.colorBlack, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 12.0)),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: UtilColors.colorBlueGrey800,
          ),
            child:  Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                   const Icon(
                    Icons.attach_money, 
                    color: UtilColors.colorWhite,
                  ),

                  Text(
                    widget.list.budget != null
                        ? "Orçamento: R\$ ${widget.list.budget}"
                        : "Orçamento: Não definido",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: UtilColors.colorWhite
                    ),
                  ),
                ],
              )),
              ValueListenableBuilder<double>(
                valueListenable: _controller.total,
                builder: (context, total, _) {
                  final budget = widget.list.budget;
                  Color? textColor;
          
                  if (budget != null && total > budget) {
                    textColor = UtilColors.colorRed800;
                  } else {
                    textColor = UtilColors.colorGreenAccent400;
                  }
          
                  return Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: UtilColors.colorBlueGrey800,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.money_off_sharp,
                          color: UtilColors.colorGreenAccent400,
                        ),
                        Text(
                          "Total gasto: R\$ $total",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: ValueListenableBuilder<List<NewItems>>(
              valueListenable: _controller.quantityItems,
              builder: (context, items, _) {
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 320.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning,
                            color: UtilColors.colorBlack45,
                            size: 50,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            'Nenhum item adicionado',
                            style: TextStyle(fontSize: 25.0, 
                            color: UtilColors.colorBlack45),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final NewItems item = items[index];
                    return DialogCustom(
                      keyConfirm: Key(item.id.toString()), 
                      onDismissed: () async => await _controller.deleteItem(item),
                      confirmTitle: "Confirmar exclusão",
                      confirmContent: "Deseja realmente excluir o item ${item.items} ?",
                      confirmText: "Ok",
                      cancelText: "Cancelar",
                      child: TransferItens(item, _controller), 
                      );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final savedItem = await Navigator.push(context,
              MaterialPageRoute(builder: (context) {
            return TransferForm(_controller);
          }));
          if (savedItem != null) {
            setState(() {});
          }
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TransferItens extends StatefulWidget {
  final NewItems _addItems;
  final ItemController _controller;

  const TransferItens(this._addItems, this._controller, {super.key});

  @override
  TransferItensState createState() => TransferItensState();
}

class TransferItensState extends State<TransferItens> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadCheckboxState(); // estado inicial
  }

  // carrega o estado do checkbox
  void _loadCheckboxState() async {
    int itemId = widget._addItems.id ?? 0;
    bool state = await widget._controller.loadCheckboxState(itemId);
    setState(() {
      isChecked = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isChecked ? UtilColors.colorBlack45 : UtilColors.colorBlack,
        ),
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(widget._addItems.items.toString()),
          subtitle: Text(widget._addItems.quantity.toString()),
          onChanged: (bool? value) async {
            setState(() {
              isChecked = value ?? false;
            });
            if(isChecked) {
              final double? price = await showDialog<double>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: UtilColors.colorBlack,
                  title: const Text("Insira o preço do item"),
                  content: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Valor (R\$)",),
                    onSubmitted: (valor) {
                      valor = valor.trim();
                      final formatPrices = RegExp(r'^\d+(\,\d{1,2})?$'); 

                      if(valor.startsWith(",") || valor.startsWith(".") || valor.startsWith("-") || formatPrices.hasMatch(valor) || !(valor.isNotEmpty == true)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                            content: Text('Insira um preço válido!',
                            softWrap: isChecked = false,),
                          ),
                        );
                      }else {
                        Navigator.of(context).pop(double.tryParse(valor));
                        isChecked == true;
                      }
                    },
                  ),
                ),
              );
              if (price != null) {
                await widget._controller
                    .checkAddOrDecrease(widget._addItems.id!, true, price);
              } else {
                await widget._controller
                    .checkAddOrDecrease(widget._addItems.id!, false, 0.0);
              }
            } else {
              await widget._controller.checkAddOrDecrease(
                  widget._addItems.id!, false, widget._addItems.price ?? 0.0);
            }

            await widget._controller.saveCheckboxState(widget._addItems.id ?? 0, isChecked);
          },
          value: isChecked,
        ),
      ),
    );
  }
}


