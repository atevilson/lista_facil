import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lista_facil/ui/create_items/view_model/create_items_view_model.dart';
import 'package:lista_facil/ui/create_lists/widgets/app_bar_lista.dart';
import 'package:lista_facil/domain/models/lists.dart';
import 'package:lista_facil/ui/create_lists/view_model/create_list_view_model.dart';

import 'package:lista_facil/ui/create_items/widgets/create_itens_screen.dart';
import 'package:lista_facil/ui/core/themes/colors.dart';
import 'package:lista_facil/ui/cupboard_items/widgets/cupboard_items_screen.dart';

class CreatedListsScreen extends StatefulWidget {
  const CreatedListsScreen({super.key, required this.viewModelList, required this.viewModel});

  final CreateListViewModel viewModelList;
  final CreateItemsViewModel viewModel;

  @override
  State<CreatedListsScreen> createState() => _CreatedListsScreenState();
}

class _CreatedListsScreenState extends State<CreatedListsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _newListController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  late final AnimationController _animationController;
  bool _showCreateForm = false; // visibilidade do formulário de criar lista
  bool _isSearchActive = false; // visibilidade da lupa
  List<Lists> _filteredLists = [];
  bool _isEditing = false;
  bool _isDelete = false;
  Lists? _listEdit;

  @override
  void initState() {
    super.initState();
    widget.viewModelList.init();
    widget.viewModelList.findAll();
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
    backgroundColor: ThemeColor.colorBlueScafold,
    body: Column(
      children: [
        AppBarCustom(
          isSearchActive: _isSearchActive, 
          onBack: () => Navigator.of(context).pop(), 
          onSearch: _togleSearch, 
          title: "Lista de compras",
          searchController: _searchController,
          onSearchChanged: _searchList,
          hintText: "Buscar lista",
          color: ThemeColor.colorBlueTema, 
          controller: widget.viewModelList,
          ),
          Expanded(
            child: _filteredLists.isEmpty
                ? ValueListenableBuilder<List<Lists>>(
                    valueListenable: widget.viewModelList.listaValores,
                    builder: (context, snapshot, _) {
                      if (snapshot.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning,
                                color: ThemeColor.colorBlue,
                                size: 50.0,
                              ),
                              Text(
                                'Nenhuma lista disponível',
                                style: TextStyle(fontSize: 20.0,
                                color: ThemeColor.colorBlue),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 8.0),
                        itemBuilder: (context, index) {
                          final Lists lists = snapshot[index];
                          return _CollectionsLists(
                            list: lists,
                            onDelete: () => _showDeleteConfirmation(lists),
                            onEdit: () => _showEditForm(lists),
                            viewModel: widget.viewModel,
                            viewModelList: widget.viewModelList,
                          );
                        },
                        itemCount: snapshot.length,
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 8.0),
                    itemCount: _filteredLists.length,
                    itemBuilder: (context, index) {
                      final Lists lists = _filteredLists[index];
                      return _CollectionsLists(
                        list: lists,
                        onDelete: () => _deleteList(),
                        onEdit: () => _showEditForm(lists),
                        viewModel: widget.viewModel,
                        viewModelList: widget.viewModelList,
                      );
                    },
                  ),
          ),
          if (_showCreateForm)
            Container(
              color: ThemeColor.colorWhite,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _isDelete ? SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text("Deseja excluir a lista \"${_listEdit?.nameList}\" ?",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: ThemeColor.colorBlueTema,
                      fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ElevatedButton(
                                  onPressed: () => _deleteList(),
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                      ),
                                      padding: EdgeInsets.all(16),
                                      backgroundColor:
                                          ThemeColor.colorBlueTema, minimumSize: Size(140, 0)),
                                  child: Icon(
                                    Icons.check,
                                    color: ThemeColor.colorWhite,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: ElevatedButton(onPressed: () => setState(() {
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
                                child: Icon(Icons.close, color: ThemeColor.colorBlueTema,)),
                              )
                      ],
                    ),
                  ], 
                ),
              ) :
              SingleChildScrollView(
                child: Column(
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
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: ThemeColor.colorWhite),
                              ),
                            ),
                          ),
                        ],
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
        _filteredLists = [];
      }
    });
  }

  void _searchList(String query) {
    widget.viewModelList.searchListsByName(query).then((filterLists) {
      setState(() {
        _filteredLists = filterLists;
      });
    });
  }

  void _showEditForm(Lists list) {
    setState(() {
      _isEditing = true;
      _listEdit = list;
      _newListController.text = list.nameList;
      _budgetController.text = list.budget?.toString() ?? "";
      _showCreateForm = true;
    });
  }

  void _deleteList() async {
    if(_isDelete && _listEdit != null) {
      await widget.viewModelList.deleteList(_listEdit!);
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

  void _showDeleteConfirmation(Lists lists) {
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
    await widget.viewModelList.saveList(nameList, budget);
    setState(() {
      _showCreateForm = false;
      _newListController.clear();
      _budgetController.clear();
    });

    if (!context.mounted) return;

    bool? addLayoff = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColor.colorBlueTema,
        title: const Text("Deseja adicionar itens da dispensa?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Não", 
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: ThemeColor.colorBlueTema,
            ),),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Sim",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: ThemeColor.colorBlueTema,
            ),),
          ),
        ],
      ),
    );

    if (addLayoff == true) {
      if (!context.mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          /* pantry items screen é tela onde o usuário adiciona os itens de dispensa */
          builder: (context) => CupboardItemsScreen(viewModelList: widget.viewModelList,),
        ),
      );
    }
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
      final updateList = Lists(
        _listEdit!.id,
        _newListController.text,
        newBudget,
        ""
      );
      await widget.viewModelList.updateList(updateList);
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
  final Lists list;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final CreateListViewModel viewModelList;
  final CreateItemsViewModel viewModel;

  const _CollectionsLists({required this.list, required this.onEdit, required this.onDelete, 
  required this.viewModelList, required this.viewModel});

  @override
  State<_CollectionsLists> createState() => _CollectionsListsState();
}

class _CollectionsListsState extends State<_CollectionsLists> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Slidable(
          key: Key(widget.list.id.toString()),
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) => widget.onEdit(),
                backgroundColor: ThemeColor.colorBlueTema,
                icon: Icons.edit,           
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) => widget.onDelete(),
                backgroundColor: ThemeColor.colorBlueTema,
                icon: Icons.delete,
                 
              ),
            ],
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              //borderRadius: BorderRadius.circular(30)
            ),
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              title: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CreateItemsScreen(list: widget.list, viewModel: widget.viewModel, viewModelList: widget.viewModelList,);
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
                    onTap: () async {
                      setState(() {
                        widget.list.bookMarked = !widget.list.bookMarked;
                      });
                      await widget.viewModelList.setListMarked(widget.list.id, widget.list.bookMarked);
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
        ),
      ),
    );
  }
}