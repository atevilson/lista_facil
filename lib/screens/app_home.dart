

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/screens/create_list/shopping_lists.dart';
import 'package:my_app/utils_colors/utils_style.dart';

const _titleAppBar = 'Lista Fácil';

class listCollections extends StatelessWidget {
  const listCollections({super.key});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      home: Scaffold(
        appBar: appBarCustom(title: _titleAppBar),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 140.0),
              child: Image.asset('images/carrinho_compras.jpg'),
            ),
            Container(
              color: UtilColors.instance.colorContainer,
              height: 115,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget> [
                  _MenuItemHome("Criar Lista", 
                  Icons.list_alt_outlined, 
                    onClick: () => _pageCreatedLists(context),
                  ),
                  _MenuItemHome(
                  'Confira ofertas',
                  Icons.add_shopping_cart,
                  onClick: () => (),
                ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

void _pageCreatedLists(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => createdLists(),
      ),
    );
  }
}


// Itens cards
class _MenuItemHome extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  const _MenuItemHome(
    this.name,
    this.icon, {
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        child: InkWell(
          onTap: () => onClick(),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: UtilColors.instance.colorWhite.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 4,
                  offset: Offset(0,2)
                )
              ]
            ),
            padding: const EdgeInsets.all(8.0),
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                    color: UtilColors.instance.colorRed,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  icon,
                  color: UtilColors.instance.colorRed,
                  size: 28.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}