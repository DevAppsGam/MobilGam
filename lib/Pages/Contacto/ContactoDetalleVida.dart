import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class contactoDetalle extends StatelessWidget {
  final String nombre;
  final String rol;
  final String TEL;
  final String mail;
  final String ext;
  final String rutaDeLaFoto;

  const contactoDetalle({
    Key? key,
    required this.nombre,
    required this.rol,
    required this.TEL,
    required this.mail,
    required this.ext,
    required this.rutaDeLaFoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles del Contacto',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
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
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Información del contacto VIDA',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.blue,
                        child: Image.network(
                          'http://www.asesoresgam.com.mx/sistemas1/$rutaDeLaFoto',
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              );
                            }
                          },
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            return const Icon(Icons.error);
                          },
                          width: 140,
                          height: 140,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombre,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rol,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
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
                        style: const TextStyle(fontSize: 16, color: Colors.blue, fontFamily: 'Roboto'),
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
                        style: const TextStyle(fontSize: 16, color: Colors.blue, fontFamily: 'Roboto'),
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
