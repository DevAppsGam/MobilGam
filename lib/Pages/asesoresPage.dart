import 'package:appgam/Pages/Contacto/contactoVidaPage.dart';
import 'package:appgam/Pages/MenuAsesores/autosPage.dart';
import 'package:appgam/Pages/MenuAsesores/gmmPage.dart';
import 'package:appgam/Pages/MenuAsesores/recursosPage.dart';
import 'package:appgam/Pages/MenuAsesores/siniestrosPage.dart';
import 'package:appgam/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appgam/Pages/MenuAsesores/vidaPage.dart';

class Asesores extends StatelessWidget {
  const Asesores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            // Abrir el menú de navegación
            Scaffold.of(context).openDrawer();
          },
          child: const Text(
            "BIENVENIDO ASESOR",
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'INICIO',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.blueAccent,
                ),
              ),
              onTap: () {
                // Cerrar sesión y volver a cargar main.dart
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const Asesores()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            ListTile(
              title: const Text(
                'CONTACTOS',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.blueGrey,
                ),
              ),
              onTap: () {
                // Cerrar sesión y volver a cargar main.dart
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) =>  const contactoVida()),
                      (Route<dynamic> route) => false,
                );
              },
            ),

            ListTile(
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.deepOrange
                ),
              ),
              onTap: () {
                // Cerrar sesión y volver a cargar main.dart
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),

            // Agrega más ListTile para cada opción del menú
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'MENU',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                children: const [
                  IconWithText(
                    icon: Icons.diversity_1_rounded,
                    title: 'VIDA',
                    color: Colors.green,
                  ),
                  IconWithText(
                    icon: Icons.notification_important_rounded,
                    title: 'SINIESTROS',
                    color: Colors.yellow,
                  ),
                  IconWithText(
                    icon: Icons.car_crash_rounded,
                    title: 'AUTOS',
                    color: Colors.orange,
                  ),
                  IconWithText(
                    icon: Icons.medical_information_rounded,
                    title: 'GMM',
                    color: Colors.blueAccent,
                  ),
                  IconWithText(
                    icon: Icons.content_paste_search,
                    title: 'RECURSOS',
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {
                  const url = 'https://www.example.com';
                  launchUrl(url as Uri);
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
      ),
    );
  }
}

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;

  const IconWithText({super.key, required this.icon, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'VIDA') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Vida()),
          );
        } else if (title == 'SINIESTROS') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Siniestro()),
          );
        } else if (title == 'AUTOS') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Auto()),
          );
        } else if (title == 'GMM') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Gmm()),
          );
        } else if (title == 'RECURSOS') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Recurso()),
          );
        }
      },

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconTheme(
            data: IconThemeData(color: color),
            child: Icon(
              icon,
              size: 64,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}