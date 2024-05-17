
import 'package:flutter/material.dart';
import 'package:my_app/database/list_database.dart';
import 'package:my_app/screens/create_list/shopping_lists.dart';

const _titleAppBar = 'Lista Fácil';

class listCollections extends StatelessWidget {
  const listCollections({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: const Text(_titleAppBar, style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w500
          ),),
          titleSpacing: 8.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 140.0),
              child: Image.asset('images/carrinho_compras.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.red,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => createdLists()));
                        listarListas();
                        listarItens();
                        
                  },
                  child:  SizedBox(
                    height: 100,
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Criar lista',
                          style: TextStyle(color: Colors.white, fontSize: 19.0),
                        ),
                        Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 29.0,
                        )
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
  }
}
