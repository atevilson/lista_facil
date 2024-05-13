import 'package:flutter/material.dart';
import 'package:my_app/screens/create_list/shopping_lists.dart';

const _titleAppBar = 'Lista Fácil';

class listCollections extends StatelessWidget {
  const listCollections({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 21, 92, 24),
          foregroundColor: Colors.white,
          title: const Text(_titleAppBar),
          titleSpacing: 8.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('images/carrinho_compras.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: const Color.fromARGB(255, 90, 176, 23),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => createdLists()));
                  },
                  child: const SizedBox(
                    height: 100,
                    width: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
