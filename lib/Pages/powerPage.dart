import 'package:flutter/material.dart';

class Power extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN Power"),
      ),
      body: Column( // Eliminé la palabra clave 'const' aquí
        children: <Widget>[
          Text('Bienvenido ADMIN'), // Eliminé la palabra clave 'const' aquí
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
