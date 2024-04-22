import 'package:flutter/material.dart';

class listCreateForm extends StatelessWidget {
  const listCreateForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar lista'),
          backgroundColor: const Color.fromARGB(255, 21, 92, 24),
          foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Nova lista',
                ),
                style: TextStyle(fontSize: 24.0),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 21, 92, 24),
                  foregroundColor: Colors.white,
                  ),
              onPressed: () => {
                
              }, child: Text('Criar'),),
          ],
        ),
      ),
    );
  }
}
