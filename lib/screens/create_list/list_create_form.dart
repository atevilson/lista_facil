import 'package:flutter/material.dart';
import 'package:lista_facil/screens/create_list/created_lists.dart';

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
  final TextEditingController _budgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _newListController,
                      decoration: const InputDecoration(
                        labelText: 'Nova lista',
                      ),
                      style: const TextStyle(fontSize: 24.0),
                    ),
                    const SizedBox(height: 8.0,),
                    TextField(
                      controller: _budgetController,
                      decoration: const InputDecoration(
                        labelText: "Orçamento R\$",
                      ),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: 180.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
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
    final double? budget = double.tryParse(_budgetController.text);
    if (nameList.isNotEmpty && budget != null) {
      await widget.controller.saveList(nameList, budget);
      // remove a tela de criação da pilha
      if (!context.mounted) return;
      await Navigator.of(context)
          .pushReplacement(
        MaterialPageRoute(
          builder: (context) => const CreatedLists(),
        ),
      );
    }
  }
}
