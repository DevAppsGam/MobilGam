import 'package:flutter/material.dart';

class Gdds extends StatelessWidget {
  const Gdds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gdds Home"),
      ),
      body:  const Column(
        children: <Widget>[
          Text('Bienvenido Gdds')
        ],
      ),
    );
  }
}
