import 'package:flutter/material.dart';

class CursosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cursos Educativos')),
      body: Center(
        child: Text(
          'Aquí se mostrarán los cursos educativos relacionados al agro.',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
