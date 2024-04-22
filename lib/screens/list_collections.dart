import 'package:flutter/material.dart';
import 'package:my_app/screens/created_lists.dart';

const _titleAppBar = 'Minhas listas';

class listCollections extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 21, 92, 24),
          foregroundColor: Colors.white,
          title: const Text(_titleAppBar),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Image.asset('images/carrinho_compras.jpg'),
            ),
            Material(
              color: const Color.fromARGB(255, 90, 176, 23),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => createdLists()));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            )
          ],
        ),
      ),
    );
  }
}
