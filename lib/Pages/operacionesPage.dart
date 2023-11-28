import 'package:flutter/material.dart';

class Operaciones extends StatelessWidget {
  const Operaciones({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Operaciones Home"),
      ),
      body:  const Column(
        children: <Widget>[
          Text('Bienvenido Operaciones')
        ],
      ),
    );
  }
}
