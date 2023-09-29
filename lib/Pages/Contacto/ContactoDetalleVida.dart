import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class contactoDetalle extends StatelessWidget {
  final String nombre;
  final String rol;
  final String TEL;
  final String mail;
  final String ext;

  contactoDetalle({
    required this.nombre,
    required this.rol,
    required this.TEL,
    required this.mail,
    required this.ext,
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
                image: AssetImage('assets/img/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'CONTACTO VIDA',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue,
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
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: GestureDetector(
                      onTap: () {
                        String phoneNumberWithExtension = '$TEL,${ext.isEmpty ? '' : 'ext=$ext'}';
                        launch("tel:$phoneNumberWithExtension");
                      },
                      child: Text(
                        TEL,
                        style: const TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: GestureDetector(
                      onTap: () {
                        launch("mailto:$mail");
                      },
                      child: Text(
                        mail,
                        style: const TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: () {
                const url = 'https://www.example.com';
                launch(url);
              },
              icon: const Icon(
                Icons.message_rounded,
                size: 42,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
