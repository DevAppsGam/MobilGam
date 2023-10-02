import 'package:flutter/material.dart';


class DetalleVida extends StatelessWidget {
  final Map<String, String> datosVida;

  DetalleVida({required this.datosVida});

  @override
  Widget build(BuildContext context) {
    // Aquí puedes construir la página de detalles utilizando los datos proporcionados.
    // Por ejemplo, puedes mostrar los datos en un ListView o cualquier otro widget que desees.
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Póliza'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Folio GAM: ${datosVida['id']}'),
            Text('Nombre del Contratante: ${datosVida['contratante']}'),
            // Agrega más widgets para mostrar otros detalles aquí
          ],
        ),
      ),
    );
  }
}
