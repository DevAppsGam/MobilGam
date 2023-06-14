import 'package:flutter/material.dart';

class Power extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN Power"),
      ),
      body: const Column(
        children: <Widget>[
          Text('Bienvenido ADMIN'),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/Loginpage');
            },
            child: const Text('Ingresar'),
          ),
        ],
      ),
    );
  }
}
