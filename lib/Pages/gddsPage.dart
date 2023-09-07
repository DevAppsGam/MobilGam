import 'package:flutter/material.dart';

class Gdds extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gdds Home"),
      ),
      body: Column(
        children: const <Widget>[
          Text('Bienvenido Gdds')
        ],
      ),
    );
  }
}
