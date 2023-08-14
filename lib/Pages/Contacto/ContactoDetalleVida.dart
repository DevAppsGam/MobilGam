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
        title: const Text('Detalles del Contacto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nombre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              rol,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              informacionContacto,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
