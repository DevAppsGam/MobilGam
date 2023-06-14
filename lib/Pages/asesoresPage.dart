import 'package:flutter/material.dart';

class Asesores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asesores Home"),
      ),
      body: const Column(
        children: <Widget>[
          Text('Bienvenido Asesor')
        ],
      ),
    );
  }
}
