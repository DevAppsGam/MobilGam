import 'package:appgam/Pages/Contacto/ContactoDetalleVida.dart';
import 'package:appgam/Pages/asesoresPage.dart';
import 'package:appgam/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            "Bienvenido $nombreUsuario",
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'Inicio',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.blueAccent,
                  fontSize: 24,
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
                'Contactos',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.blueGrey,
                  fontSize: 24,
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
                  fontFamily: 'Roboto',
                  color: Colors.deepOrange,
                  fontSize: 24,
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
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Contacto de VIDA',
                style: TextStyle(
                  fontFamily: 'Roboto',
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
                    icon: Icons.woman_2_outlined,
                    title: 'Patricia Moctezuma',
                    subtitle: 'Gerente de Promoción de Vida',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.woman_2_outlined,
                    title: 'Diana Castro',
                    subtitle: 'Consultor Especializado Vida',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.woman_2_outlined,
                    title: 'Veronica Sanchez',
                    subtitle: 'Consulor Integral',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.woman_2_outlined,
                    title: 'Carolina Hernández',
                    subtitle: 'Gerente de Operación',
                    color: Colors.blueGrey,
                  ),
                  IconWithText(
                    icon: Icons.man_2_outlined,
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
            MaterialPageRoute(builder: (context) => contactoDetalle(nombre: 'PATRICIA MOCTEZUMA', rol: 'GERNTE PROMOCIÓN VIDA', TEL: '5529417281', ext: '', mail: 'promocionvida@asesoresgam.com.mx',)),
          );
        } else if (title == 'Diana Castro') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => contactoDetalle(nombre: 'DIANA CASTRO GARCIA', rol: 'CONSULTOR ESPECIALIZADO VIDA', TEL: '5536430812', ext: '127', mail: 'vida@asesoresgam.com.mx',)),
          );
        } else if (title == 'Veronica Sanchez') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => contactoDetalle(nombre: 'VERONICA SANCHEZ MONTESINOS', rol: 'CONSULTOR INTEGRAL', TEL: '5585996060',ext:'0', mail: 'lomasverdes@asesoresgam.com.mx',)),
          );
        } else if (title == 'Carolina Hernández') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => contactoDetalle(nombre: 'CAROLINA HERNANDEZ MORA', rol: 'GERENTE DE OPERACIÓN Y SERVICIO', TEL: '5521768838', ext: '106', mail: 'calidad@asesoresgam.com.mx',)),
          );
        } else if (title == 'Manuel Ramírez') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => contactoDetalle(nombre: 'MANUEL RAMIREZ', rol: 'DIRECTOR DE SOPORTE, PROMOCIÓN Y VENTAS', TEL: '', ext: '', mail: 'm.ramirez@asesoresgam.com.mx',)),
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
                fontFamily: 'Roboto',
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
                  fontFamily: 'Roboto',
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