import 'package:flutter/material.dart';

class contactoDetalle extends StatelessWidget {
  final String nombre;
  final String rol;
  final String informacionContacto;

  contactoDetalle({
    required this.nombre,
    required this.rol,
    required this.informacionContacto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Contacto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nombre,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              rol,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              informacionContacto,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
