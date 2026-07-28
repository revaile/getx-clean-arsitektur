import 'package:flutter/material.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Todos belum dibuat. Tab ini sudah siap untuk endpoint /todos.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
