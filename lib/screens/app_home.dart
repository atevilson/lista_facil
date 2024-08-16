
import 'package:flutter/material.dart';
import 'package:lista_facil/components/menu_item.dart';
import 'package:lista_facil/controllers/list_controller.dart';
import 'package:lista_facil/screens/create_list/list_create_form.dart';
import 'package:lista_facil/screens/create_list/shopping_lists.dart';
import 'package:lista_facil/utils_colors/utils_style.dart';

const _titleAppBar = 'Lista Fácil';
final ListController controller = ListController();

class ListCollections extends StatelessWidget {
  const ListCollections({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: appBarCustom(title: _titleAppBar),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Image.asset('images/carrinho_compras.jpg'),
              )
              ),
            Container(
              color: UtilColors.instance.colorContainer,
              height: 115,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget> [
                  MenuItem("Criar Lista", 
                  Icons.note_add, 
                    onClick: () => _createLists(context),
                  ),
                  MenuItem(
                  'Listas criadas',
                  Icons.list_alt_outlined,
                  onClick: () => _pageCreatedLists(context),
                ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
//listCreateForm

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

// Itens cards
