import 'package:flutter/material.dart';
import 'package:my_app/database/dao/create_list_dao.dart';
import 'package:my_app/models/new_lists.dart';
import 'package:my_app/screens/created_lists.dart';

class listCreateForm extends StatefulWidget {
  @override
  State<listCreateForm> createState() => _listCreateFormState();
}

class _listCreateFormState extends State<listCreateForm> {
  final TextEditingController _newListController = TextEditingController();
  final ListsDao _listsDao = ListsDao();

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

  void _createNewList(BuildContext context) {
    final String nameList = _newListController.text;
    if (nameList != '') {
      final NewLists newLists = NewLists(0, nameList);
      _listsDao.save(newLists).then((id) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => createdLists(),
          ),
        );
      });

      // remove a tela de criação da pilha
      Navigator.pop(context);
    }
  }
}
