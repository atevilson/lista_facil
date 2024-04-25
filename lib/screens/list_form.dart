import 'package:flutter/material.dart';

import '../controllers/list_controller.dart';

class listCreateForm extends StatefulWidget {
  final ListController controller;
  const listCreateForm(this.controller);
  @override
  State<listCreateForm> createState() => _listCreateFormState();
}

class _listCreateFormState extends State<listCreateForm> {
  final TextEditingController _newListController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar lista'),
        backgroundColor: const Color.fromARGB(255, 21, 92, 24),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _newListController,
                decoration: const InputDecoration(
                  labelText: 'Nova lista',
                ),
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: 180.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 21, 92, 24),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _createNewList(context);
                  },
                  child: const Text('Criar'),
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
      Navigator.pop(context);
    }
  }
}
