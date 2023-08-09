import 'package:appgam/Pages/asesoresPage.dart';
import 'package:appgam/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appgam/Pages/MenuAsesores/vidaPage.dart'; // Importar la página Vida

class ContactoVida extends StatelessWidget {
  const ContactoVida({Key? key}) : super(key: key);

  void _launchURL() async {
    const url = 'https://www.example.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const ContactoVida()),
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
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                children: const [
                  IconWithText(
                    icon: Icons.diversity_1_rounded,
                    title: 'Patricia Moctezuma',
                    subtitle: 'Gerente de Promoción de Vida',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.notification_important_rounded,
                    title: 'Diana Castro',
                    subtitle: 'Consultor Especializado Vida',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.car_crash_rounded,
                    title: 'Veronica Sanchez',
                    subtitle: 'Consulor Integral',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.medical_information_rounded,
                    title: 'Carolina Hernández',
                    subtitle: 'Gerente de Operación',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.content_paste_search,
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
                  _launchURL(); // Llamar a la función _launchURL para abrir el sitio web
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
        if (title == 'VIDA') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Vida()),
          );
        } else if (title == 'SINIESTROS') {
          // Resto de código para otras opciones del menú
        }
        // Resto de condiciones para las demás opciones del menú
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
