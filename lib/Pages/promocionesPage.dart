import 'package:flutter/material.dart';

class Promociones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Promociones Home"),
      ),
      body: const Column(
        children: <Widget>[
          Text('Bienvenido Promociones')
        ],
      ),
    );
  }
}
