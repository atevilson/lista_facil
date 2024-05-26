import 'package:flutter/material.dart';
import 'package:my_app/screens/create_list/shopping_lists.dart';
import 'package:my_app/utils_colors/utils_style.dart';

import '../../controllers/list_controller.dart';

const _title = "Criar lista";

class ListCreateForm extends StatefulWidget {
  final ListController controller;
  const ListCreateForm(this.controller, {super.key});
  @override
  State<ListCreateForm> createState() => _ListCreateFormState();
}

class _ListCreateFormState extends State<ListCreateForm> {
  final TextEditingController _newListController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCustom(title: _title),
      body: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: TextField(
                  controller: _newListController,
                  decoration: const InputDecoration(
                    labelText: 'NOVA LISTA',
                  ),
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: 180.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UtilColors.instance.colorRed,
                    foregroundColor: UtilColors.instance.colorWhite,
                  ),
                  onPressed: () {
                    _createNewList(context);
                  },
                  child: const Text('CRIAR LISTA'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createNewList(BuildContext context) async {
    final String nameList = _newListController.text;
    if (nameList.isNotEmpty) {
      await widget.controller.saveList(nameList);
      // remove a tela de criação da pilha
      if (!context.mounted) return;
      await Navigator.of(context)
          .pushReplacement(
        MaterialPageRoute(
          builder: (context) => CreatedLists(),
        ),
      );
    }
  }
}
