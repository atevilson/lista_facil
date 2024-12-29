import 'package:flutter/material.dart';
import 'package:lista_facil/controllers/list_controller.dart';
import 'package:lista_facil/screens/create_list/create_list.dart';
class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> with SingleTickerProviderStateMixin {

  late final AnimationController _animationController;
  final TextEditingController _newListController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final ListController _listController = ListController();
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _listController.init();
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
                        color: ThemeColor.colorBlueTema.withOpacity(0.3),
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

                    return Container( // Esse container expande ao clicar
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
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onVerticalDragUpdate: (details) {
                                if (details.delta.dy < 0 && !_isExpanded) {
                                  _toggleExpand();
                                } else if (details.delta.dy > 0 &&
                                    _isExpanded) {
                                  _toggleExpand();
                                }
                              },
                              onTap: _toggleExpand,
                              child: Column(
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
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF0377FD),
                                            fontSize: screenWidth * 0.045,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
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
                                                    fontWeight: FontWeight.w500,
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
                                            cursorColor: Colors.blue,
                                            decoration: InputDecoration(
                                              labelText: 'Nome da Lista',
                                              labelStyle: TextStyle(
                                                color: Colors.blue.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                    color: Colors.blue.shade700,
                                                    width: 1.5),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                    color: Colors.blue.shade200,
                                                    width: 1.5),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                            ),
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.05,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.01),
                                          TextField(
                                            controller: _budgetController,
                                            cursorColor: Colors.blue,
                                            decoration: InputDecoration(
                                              labelText: 'Orçamento',
                                              labelStyle: TextStyle(
                                                color: Colors.blue.shade700,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                    color: Colors.blue.shade700,
                                                    width: 1.5),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(
                                                    color: Colors.blue.shade200,
                                                    width: 1.5),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.05,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.01),
                                          SizedBox(
                                            width: screenWidth * 0.9,
                                            height: screenHeight * 0.08,
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
                                                  fontSize: screenWidth * 0.05,
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white,
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
    if (nameList.isNotEmpty && budget != null) {
      await _listController.saveList(nameList, budget);
      if (!context.mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CreatedLists(),
        ),
      );
    }
    setState(() {
      _budgetController.clear();
      _newListController.clear();
      _isExpanded = false;
      _animationController.reverse().timeout(Duration(microseconds: 1));
    });
    if (!context.mounted) return;
      FocusScope.of(context).unfocus();
  }

  void _pageCreatedLists(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreatedLists(),
      ),
    );
  }
}
