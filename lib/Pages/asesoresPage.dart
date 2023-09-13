import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appgam/Pages/Contacto/contactoVidaPage.dart';
import 'package:appgam/Pages/Graficas/graficasPage.dart';
import 'package:appgam/Pages/MenuAsesores/autosPage.dart';
import 'package:appgam/Pages/MenuAsesores/gmmPage.dart';
import 'package:appgam/Pages/MenuAsesores/recursosPage.dart';
import 'package:appgam/Pages/MenuAsesores/siniestrosPage.dart';
import 'package:appgam/Pages/MenuAsesores/vidaPage.dart';
import 'package:appgam/main.dart';

class Asesores extends StatelessWidget {
  final String nombreUsuario;
  const Asesores({Key? key, required this.nombreUsuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            // Abrir el menú de navegación
            Scaffold.of(context).openDrawer();
          },
          child: Text(
            "BIENVENIDO $nombreUsuario",
            style: const TextStyle(
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
                  fontSize: 22,
                ),
              ),
              onTap: () {
                // Cerrar sesión y volver a cargar AsesoresPage
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => Asesores(nombreUsuario: nombreUsuario)),
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
                  fontSize: 22,
                ),
              ),
              onTap: () {
                // Cargar la página de contactoVida
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => contactoVida(nombreUsuario: nombreUsuario)),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.deepOrange,
                  fontSize: 22,
                ),
              ),
              onTap: () {
                // Cerrar sesión y volver a cargar LoginPage
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
            const SizedBox(height: 60),
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
                children: [
                  IconWithText(
                    icon: Icons.diversity_1_rounded,
                    title: 'VIDA',
                    color: Colors.green,
                    nombreUsuario: nombreUsuario,
                  ),
                  IconWithText(
                    icon: Icons.notification_important_rounded,
                    title: 'SINIESTROS',
                    color: Colors.yellow, nombreUsuario: nombreUsuario,
                  ),
                  IconWithText(
                    icon: Icons.car_crash_rounded,
                    title: 'AUTOS',
                    color: Colors.orange, nombreUsuario: nombreUsuario,
                  ),
                   IconWithText(
                    icon: Icons.medical_information_rounded,
                    title: 'GMM',
                    color: Colors.blueAccent, nombreUsuario: nombreUsuario,
                  ),
                   IconWithText(
                    icon: Icons.content_paste_search,
                    title: 'RECURSOS',
                    color: Colors.blueGrey, nombreUsuario: nombreUsuario,
                  ),
                   IconWithText(
                    icon: Icons.graphic_eq_outlined,
                    title: 'ESTADISTICAS',
                    color: Colors.redAccent, nombreUsuario: nombreUsuario,
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
  final String nombreUsuario;

  const IconWithText({Key? key, required this.icon, required this.title, this.color, required this.nombreUsuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'VIDA':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Vida(nombreUsuario: nombreUsuario,)),
            );
            break;
          case 'SINIESTROS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Siniestro()),
            );
            break;
          case 'AUTOS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Auto()),
            );
            break;
          case 'GMM':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Gmm()),
            );
            break;
          case 'RECURSOS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Recurso()),
            );
            break;
          case 'ESTADISTICAS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const graficas()),
            );
            break;
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
