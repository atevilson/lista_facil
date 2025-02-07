
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lista_facil/domain/models/lists.dart';
import 'package:lista_facil/ui/create_lists/view_model/create_list_view_model.dart';
import 'package:lista_facil/ui/create_lists/widgets/create_lists_screen.dart';
import 'package:lista_facil/ui/core/themes/colors.dart';
import 'package:lista_facil/ui/cupboard_items/widgets/cupboard_items_screen.dart';

final viewModelList = GetIt.I<CreateListViewModel>();

class AppHome extends StatefulWidget {
  const AppHome({super.key});
  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final TextEditingController _newListController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _handlerTapDownOrTapCancel(){
    if(_isExpanded){
      _toggleExpand();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _newListController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.12),
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'images/logo.png',
                            height: screenHeight * 0.4, // 30% de altura da tela
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'Crie agora\nmesmo a\nsua primeira\nlista fácil',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: 1.0,
                              leadingDistribution:
                                  TextLeadingDistribution.proportional,
                              wordSpacing: 1.0,
                              color: Colors.white,
                              fontSize:
                                  screenWidth * 0.1, // 10% de largura da telaa
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: TextField(
                        keyboardType: TextInputType.none,
                        textInputAction: TextInputAction.done,
                        onTap: () {
                          _pageCreatedLists(context);
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white54),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          hintText: 'Buscar lista',
                          hintStyle: const TextStyle(color: Colors.white54),
                          suffixIcon:
                              const Icon(Icons.search, color: Colors.white54),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
              if (_isExpanded)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _handlerTapDownOrTapCancel,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2.5, 
                        sigmaY: 2.5,
                      ),
                      child: Container(
                        color: ThemeColor.colorBlueTema.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),

              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    double maxHeight = screenHeight * 0.4;
                    double minHeight = screenHeight * 0.1;

                    double height = minHeight +
                        (maxHeight - minHeight) * _animationController.value;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                            onVerticalDragUpdate: (details) {
                                    if (details.delta.dy < 0 && !_isExpanded) {
                                      _toggleExpand();
                                    } else if (details.delta.dy > 0 &&
                                      _isExpanded) {
                                    _toggleExpand();
                                    }
                                  },
                            onTap: _isExpanded ? _handlerTapDownOrTapCancel : _toggleExpand,
                      child: Container( // container expande ao clicar
                        height: height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/base_bottom.png'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!_isExpanded)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              bottom: screenHeight * 0.015),
                                          width: screenWidth * 0.15,
                                          height: screenHeight * 0.008,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0377FD),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        Text(
                                          'Nova lista',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF0377FD),
                                            fontSize: screenWidth * 0.045,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              if (_isExpanded)
                                Expanded(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.1,
                                            vertical: screenHeight * 0.05),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onVerticalDragUpdate: (details) {
                                                if (details.delta.dy > 0 &&
                                                    _isExpanded) {
                                                  _toggleExpand();
                                                }
                                              },
                                              onVerticalDragEnd: (details) {
                                                if (_isExpanded) {
                                                  _toggleExpand();
                                                }
                                              },
                                              onTap: () {
                                                _toggleExpand(); 
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom:
                                                            screenHeight * 0.015),
                                                    width: screenWidth * 0.15,
                                                    height: screenHeight * 0.008,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color(0xFF0377FD),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Nova lista',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      color:
                                                          const Color(0xFF0377FD),
                                                      fontSize:
                                                          screenWidth * 0.045,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: screenHeight * 0.03),
                                            TextField(
                                              controller: _newListController,
                                              cursorColor: ThemeColor.colorBlueTema,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                  vertical: 12.0,
                                                  horizontal: 12.0
                                                ),
                                                labelText: 'Nome da lista',
                                                labelStyle: TextStyle(
                                                  fontSize: 17.0,
                                                  color: ThemeColor.colorBlueTema,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25.0),
                                                  borderSide: BorderSide(
                                                      color: ThemeColor.colorBlueItemNaoSel,
                                                      width: 1.5),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25.0),
                                                  borderSide: BorderSide(
                                                      color: ThemeColor.colorBlueGradient,
                                                      width: 1.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25.0),
                                                ),
                                              ),
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.04,
                                                color: ThemeColor.colorBlueAccent,
                                              ),
                                            ),
                                            SizedBox(height: screenHeight * 0.01),
                                            TextField(
                                              controller: _budgetController,
                                              cursorColor: ThemeColor.colorBlueTema,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                  vertical: 12.0,
                                                  horizontal: 12.0
                                                ),
                                                labelText: 'Orçamento - R\$',
                                                labelStyle: TextStyle(
                                                  color: ThemeColor.colorBlueTema,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 17.0
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25.0),
                                                  borderSide: BorderSide(
                                                      color: ThemeColor.colorBlueItemNaoSel,
                                                      width: 1.5),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25.0),
                                                  borderSide: BorderSide(
                                                      color: ThemeColor.colorBlueGradient,
                                                      width: 1.0),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25.0),
                                                ),
                                              ),
                                              keyboardType: TextInputType.number,
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.04,
                                                color: ThemeColor.colorBlueAccent,
                                              ),
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.9,
                                              height: screenHeight * 0.08,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                  vertical: 12.0,
                                                ),
                                                child: ElevatedButton(
                                                  onPressed: () =>
                                                      _createNewList(context),
                                                  style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                    ),
                                                    backgroundColor:
                                                        const Color(0xFF0377FD),
                                                  ),
                                                  child: Text(
                                                    'Criar nova lista',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: screenWidth * 0.05,
                                                      //fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createNewList(BuildContext context) async {
  final String nameList = _newListController.text;
  final double? budget = double.tryParse(_budgetController.text);
  final newList = Lists(0, nameList, budget, "");
  if (nameList.isNotEmpty && budget != null) {
    await viewModelList.saveList.execute(newList);
    setState(() {
     _toggleExpand();
      _newListController.clear();
      _budgetController.clear();
    });

    if (!context.mounted) return;

    bool? addLayoff = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ThemeColor.colorBlueScafold,
        title: Text("Deseja adicionar itens da dispensa?",
        style: TextStyle(
          color: ThemeColor.colorBlueTema
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(ThemeColor.colorBlueItemNaoSel)
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Não", 
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: ThemeColor.colorWhite60,
            ),),
          ),
          SizedBox(width: 10),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(ThemeColor.colorBlueTema)
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Sim",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ThemeColor.colorWhite,
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
          /* redireciona para tela onde o usuário adiciona os itens de dispensa */
          builder: (context) => CupboardItemsScreen(viewModelList: viewModelList,),
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

  void _pageCreatedLists(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreatedListsScreen(viewModelList: viewModelList)
      ),
    );
  }
}
