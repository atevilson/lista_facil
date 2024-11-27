import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lista_facil/controllers/list_controller.dart';

import 'package:lista_facil/models/new_lists.dart';
import 'package:lista_facil/screens/itens_list/list_transference.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

class CreatedLists extends StatefulWidget {
  const CreatedLists({super.key});

  @override
  State<CreatedLists> createState() => _CreatedListsState();
}

class _CreatedListsState extends State<CreatedLists> with SingleTickerProviderStateMixin {
  final ListController _controller = ListController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _newListController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  late final AnimationController _animationController;
  bool _showCreateForm = false; // Controle de visibilidade do formulário de criar lista
  bool _isSearchActive = false; // Controle de visibilidade da lupa
  List<NewLists> _filteredLists = [];
  bool _isEditing = false;
  bool _isDelete = false;
  NewLists? _listEdit;

  @override
  void initState() {
    super.initState();
    _controller.findAll();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _newListController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    backgroundColor: Color(0xFFe5f1ff),
    body: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ThemeColor.colorBlueTema,
            boxShadow: [
              BoxShadow(
                color: ThemeColor.colorBlueAccent.withOpacity(0.9),
                spreadRadius: 3,
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          height: 118,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 18.0),
            child: Row(
              children: [
                // Botão de voltar
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: ThemeColor.colorWhite),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _isSearchActive
                        ? TextField(
                            key: const ValueKey(1),
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar lista',
                              hintStyle: const TextStyle(color: ThemeColor.colorWhite60),
                              filled: true,
                              fillColor: ThemeColor.colorBlueTema,
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
                            onChanged: (query) {
                              _searchList(query);
                            },
                          )
                        : Text(
                            "Listas de compras",
                            key: const ValueKey(2),
                            style: const TextStyle(
                              color: ThemeColor.colorWhite,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
                // Botão de busca
                _isSearchActive ? IconButton(
                  icon: const Icon(Icons.close, color: ThemeColor.colorWhite),
                  onPressed: _togleSearch,
                ) : IconButton(
                                icon: const Icon(Icons.search, color: ThemeColor.colorWhite60),
                                onPressed: _togleSearch,
                              ),
              ],
            ),
          ),
        ),
          Expanded(
            child: _filteredLists.isEmpty
                ? ValueListenableBuilder<List<NewLists>>(
                    valueListenable: _controller.listaValores,
                    builder: (context, snapshot, _) {
                      if (snapshot.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning,
                                color: ThemeColor.colorBlack45,
                                size: 50.0,
                              ),
                              Text(
                                'Nenhuma lista disponível',
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        itemBuilder: (context, index) {
                          final NewLists lists = snapshot[index];
                          return _CollectionsLists(
                            lists,
                            onDelete: () => _showDeleteConfirmation(lists),
                            onEdit: () => _showEditForm(lists),
                          );
                        },
                        itemCount: snapshot.length,
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    itemCount: _filteredLists.length,
                    itemBuilder: (context, index) {
                      final NewLists lists = _filteredLists[index];
                      return _CollectionsLists(
                        lists,
                        onDelete: () => _deleteItem(),
                        onEdit: () => _showEditForm(lists),
                      );
                    },
                  ),
          ),

          if (_showCreateForm)
            Visibility(
              child: Flexible(
                child: Container(
                  color: ThemeColor.colorWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _isDelete ? Column(
                    children: [
                            const SizedBox(height: 150),
                      Text("Deseja excluir a lista \"${_listEdit?.nameList}\" ?",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: ThemeColor.colorBlueTema,
                        fontSize: 20
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                                ElevatedButton(
                                  onPressed: () => _deleteItem(),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                      ),
                                      padding: EdgeInsets.all(16),
                                      backgroundColor:
                                          ThemeColor.colorBlueTema, minimumSize: Size(140, 50)),
                                  child: Icon(
                                    Icons.check,
                                    color: ThemeColor.colorWhite,
                                  ),
                                ),
                                const SizedBox(width: 40),
                                ElevatedButton(onPressed: () => setState(() {
                                  _showCreateForm = false;
                                  _isDelete = false; 
                                }),style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)
                                  ),
                                  padding: EdgeInsets.all(16),
                                  backgroundColor: ThemeColor.colorWhite,
                                  minimumSize: Size(140, 50),
                                  side: BorderSide(color: ThemeColor.colorBlue, width: 2)
                                ), 
                                child: Icon(Icons.close, color: ThemeColor.colorBlueTema,))
                        ],
                      ),
                    ], 
                  ) :
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        _isEditing ? "Editar lista" : "Nova lista",
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
                      const SizedBox(height: 20,),
                      TextField(
                        controller: _newListController,
                        cursorColor: ThemeColor.colorBlue,
                        decoration: InputDecoration(
                          labelText: "Nome da Lista",
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
                        controller: _budgetController,
                        cursorColor: ThemeColor.colorBlue,
                        decoration: InputDecoration(
                          labelText: "Orçamento",
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
                          onPressed: _isEditing ? () => _saveEditList(context) : () => _createNewList(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeColor.colorBlueTema,
                          ),
                          child: Text(
                            _isEditing ? "Salvar" : "Criar nova lista",
                            style: TextStyle(fontSize: 18.0, color: ThemeColor.colorWhite),
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
                      _newListController.clear();
                      _budgetController.clear();
                      _isEditing = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    backgroundColor: ThemeColor.colorBlueTema,
                  ),
                  child: Text(
                    "Cancelar",
                    style: const TextStyle(fontSize: 18.0, color: ThemeColor.colorWhite),
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
              color: ThemeColor.colorWhite,
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: !_showCreateForm ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showCreateForm = !_showCreateForm; 
                        _newListController.clear();
                        _budgetController.clear();
                        _isEditing = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      backgroundColor: ThemeColor.colorBlueTema,
                    ),
                    child: Text(
                      "Criar nova lista",
                      style: const TextStyle(fontSize: 18.0, color: ThemeColor.colorWhite),
                    ),
                  ) : null
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
      if(!_isSearchActive) {
        _searchController.clear();
      }
    });
  }

  void _searchList(String query) {
    _controller.searchListsByName(query).then((filterLists) {
      setState(() {
        _filteredLists = filterLists;
      });
    });
  }

  void _showEditForm(NewLists list) {
    setState(() {
      _isEditing = true;
      _listEdit = list;
      _newListController.text = list.nameList;
      _budgetController.text = list.budget?.toString() ?? "";
      _showCreateForm = true;
    });
  }

  void _deleteItem() async {
    if(_isDelete && _listEdit != null) {
      await _controller.deleteItem(_listEdit!);
    setState(() {
      _showCreateForm = false;
      _isEditing = false;
      _isDelete = false;
      _listEdit = null;
      _newListController.clear();
      _budgetController.clear();
    });
    }
  }

  void _showDeleteConfirmation(NewLists lists) {
    setState(() {
      _isDelete = true;
      _listEdit = lists;
      _showCreateForm = true;
    });
  }

  Future<void> _createNewList(BuildContext context) async {
    final String nameList = _newListController.text;
    final double? budget = double.tryParse(_budgetController.text);
    if (nameList.isNotEmpty && budget != null) {
      await _controller.saveList(nameList, budget);
      setState(() {
        _showCreateForm = false;
        _newListController.clear();
        _budgetController.clear();
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

  Future<void> _saveEditList(BuildContext context) async {
    if (_newListController.text.isNotEmpty &&
        double.tryParse(_budgetController.text) != null) {
      final double newBudget = double.parse(_budgetController.text);
      final updateList = NewLists(
        _listEdit!.id,
        _newListController.text,
        newBudget,
      );
      await _controller.updateList(updateList);
      setState(() {
        _showCreateForm = false;
        _isEditing = false;
        _listEdit = null;
        _newListController.clear();
        _budgetController.clear();
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

}

class _CollectionsLists extends StatefulWidget {
  final NewLists list;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CollectionsLists(this.list, {required this.onEdit, required this.onDelete});

  @override
  State<_CollectionsLists> createState() => _CollectionsListsState();
}

class _CollectionsListsState extends State<_CollectionsLists> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(widget.list.id.toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {
              widget.onEdit();
            },
            backgroundColor: ThemeColor.colorBlue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {
              widget.onDelete();
            },
            backgroundColor: ThemeColor.colorBlue,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: Card(
        elevation: 5,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
          title: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ListTransference(widget.list);
              }));
            },
            child: Text(
              widget.list.nameList,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: ThemeColor.colorBlue,
              ),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'R\$ ${widget.list.budget?.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 15.0,
                  color: ThemeColor.colorBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.list.bookMarked = !widget.list.bookMarked;
                  });
                },
                child: Icon(
                  widget.list.bookMarked ? Icons.bookmark : Icons.bookmark_border,
                  color: widget.list.bookMarked ? ThemeColor.colorAmber : ThemeColor.colorBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}