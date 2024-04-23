import 'package:flutter/material.dart';
import 'package:my_app/models/new_lists.dart';

class listCreateForm extends StatefulWidget {
  listCreateForm({super.key});

  @override
  State<listCreateForm> createState() => _listCreateFormState();
}

class _listCreateFormState extends State<listCreateForm> {
  final TextEditingController _newListController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar lista'),
        backgroundColor: const Color.fromARGB(255, 21, 92, 24),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _newListController,
                decoration: InputDecoration(
                  labelText: 'Nova lista',
                ),
                style: TextStyle(fontSize: 24.0),
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
                    final String nameList = _newListController.text;
                    final NewLists newLists = NewLists(nameList);
                    Navigator.pop(context, newLists);
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
}
