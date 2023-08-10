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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/back.jpg'), // Reemplaza con la ruta correcta de la imagen
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      // Agrega aquí la imagen del contacto
                      radius: 40,
                      backgroundColor: Colors.blue,
                      // backgroundImage: AssetImage('ruta_de_la_imagen'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nombre,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            rol,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(), // Línea horizontal

                // Información de contacto (teléfono)
                ListTile(
                  leading: const Icon(Icons.phone),
                  title: Text(
                    informacionContacto,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Divider(), // Línea horizontal

                // Información de contacto (correo)
                const ListTile(
                  leading: Icon(Icons.email),
                  title: Text(
                    'correo@example.com', // Cambia esto con el correo real
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
