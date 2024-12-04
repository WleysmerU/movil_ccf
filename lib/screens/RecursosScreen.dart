import 'package:flutter/material.dart';

class RecursosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recursos Educativos')),
      body: Center(
        child: Text(
          'Aquí se mostrarán recursos educativos, como documentos, guías, y videos.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
