import 'package:appgam/Pages/Contacto/ContactoDetalleVida.dart';
import 'package:appgam/Pages/MenuAsesores/autosPage.dart';
import 'package:appgam/Pages/MenuAsesores/gmmPage.dart';
import 'package:appgam/Pages/MenuAsesores/recursosPage.dart';
import 'package:appgam/Pages/MenuAsesores/siniestrosPage.dart';
import 'package:appgam/Pages/asesoresPage.dart';
import 'package:appgam/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appgam/Pages/MenuAsesores/vidaPage.dart';

class contactoVida extends StatelessWidget {
  final String nombreUsuario;

  const contactoVida({Key? key, required this.nombreUsuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
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
                ),
              ),
              onTap: () {
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
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => contactoVida(nombreUsuario: nombreUsuario)),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            ListTile(
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.deepOrange,
                ),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
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
                'Contacto de VIDA',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center, // Centro el título
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                children: const [
                  IconWithText(
                    icon: Icons.circle,
                    title: 'Patricia Moctezuma',
                    subtitle: 'Gerente de Promoción de Vida',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.circle,
                    title: 'Diana Castro',
                    subtitle: 'Consultor Especializado Vida',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.circle,
                    title: 'Veronica Sanchez',
                    subtitle: 'Consulor Integral',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.circle,
                    title: 'Carolina Hernández',
                    subtitle: 'Gerente de Operación',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.circle,
                    title: 'Manuel Ramírez',
                    subtitle: 'Director de Soporte, Promoción y Ventas',
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
  final String subtitle;

  const IconWithText({
    Key? key,
    required this.icon,
    required this.title,
    this.color,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Patricia Moctezuma') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => contactoDetalle(nombre: 'nombre', rol: 'rol', informacionContacto: 'informacionContacto')),
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
      child: Center(
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
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
