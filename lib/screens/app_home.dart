
import 'package:flutter/material.dart';
import 'package:lista_facil/components/custom_icons.dart';
import 'package:lista_facil/components/menu_item.dart';
import 'package:lista_facil/controllers/list_controller.dart';
import 'package:lista_facil/screens/create_list/list_create_form.dart';
import 'package:lista_facil/screens/create_list/created_lists.dart';

const _titleAppBar = 'Lista Fácil';
final ListController controller = ListController();

class ListCollections extends StatelessWidget {
  const ListCollections({super.key});

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_titleAppBar),
              Icon(Icons.shopping_cart, size: 28.0,)
            ],
          ),
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                      Colors.transparent, BlendMode.hardLight),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(300.0),
                    child: Image.asset(
                      'images/carrinho_compras.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                MenuItem(
                  "Criar Lista",
                  CustomIcons.criarLista,
                  onClick: () => _createLists(context),
                ),
                MenuItem(
                  'Listas criadas',
                  Icons.view_list_sharp,
                  onClick: () => _pageCreatedLists(context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

void _pageCreatedLists(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreatedLists(),
      ),
    );
  }
}

void _createLists(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ListCreateForm(controller);
        },
      ),
    );
  }