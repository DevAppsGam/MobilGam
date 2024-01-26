import 'package:appgam/Pages/Contacto/ContactoDetalleVida.dart';
import 'package:appgam/Pages/asesoresPage.dart';
import 'package:appgam/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class contactoVida extends StatelessWidget {
  final String nombreUsuario;

  const contactoVida({super.key, required this.nombreUsuario});

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
              fontSize: 17,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
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
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: .65,
                padding: const EdgeInsets.all(16),
                children: const [
                  IconWithText(
                    icon: Icons.woman_2_outlined,
                    title: 'Patricia Moctezuma',
                    subtitle: 'Gerente de Promoción de Vida',
                    color: Colors.blueGrey,
                    rutaDeLaFoto: 'fotosPerfil/Patricia M.png',
                  ),
                  IconWithText(
                    icon: Icons.woman_2_outlined,
                    title: 'Diana Castro',
                    subtitle: 'Consultor Especializado Vida',
                    color: Colors.blueGrey,
                    rutaDeLaFoto: 'fotosPerfil/Diana C.png',
                  ),
                  IconWithText(
                    icon: Icons.woman_2_outlined,
                    title: 'Veronica Sanchez',
                    subtitle: 'Consultor Integral',
                    color: Colors.blueGrey,
                    rutaDeLaFoto: 'fotosPerfil/Veronica S.png',
                  ),
                  IconWithText(
                    icon: Icons.woman_2_outlined,
                    title: 'Carolina Hernández',
                    subtitle: 'Gerente de operación y servicio',
                    color: Colors.blueGrey,
                    rutaDeLaFoto: 'fotosPerfil/Carolina H.png',
                  ),
                  IconWithText(
                    icon: Icons.man_2_outlined,
                    title: 'Manuel Ramírez',
                    subtitle: 'Director de soporte, promoción y ventas',
                    color: Colors.blueGrey,
                    rutaDeLaFoto: 'fotosPerfil/Manuel R.png',
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
  final String rutaDeLaFoto;
  final double iconSize;

  const IconWithText({
    super.key,
    required this.icon,
    required this.title,
    this.color,
    required this.subtitle,
    required this.rutaDeLaFoto,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Patricia Moctezuma') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const contactoDetalle(
                nombre: 'PATRICIA MOCTEZUMA',
                rol: 'GERENTE PROMOCIÓN VIDA',
                TEL: '5529417281',
                ext: '',
                mail: 'promocionvida@asesoresgam.com.mx',
                rutaDeLaFoto: 'fotosPerfil/Patricia M.png',
              ),
            ),
          );
        } else if (title == 'Diana Castro') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const contactoDetalle(
                nombre: 'DIANA CASTRO GARCIA',
                rol: 'CONSULTOR ESPECIALIZADO VIDA',
                TEL: '5530608727',
                ext: '',
                mail: 'vida@asesoresgam.com.mx',
                rutaDeLaFoto: 'fotosPerfil/Diana C.png',
              ),
            ),
          );
        } else if (title == 'Veronica Sanchez') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const contactoDetalle(
                nombre: 'VERONICA SANCHEZ MONTESINOS',
                rol: 'CONSULTOR INTEGRAL',
                TEL: '5532202334',
                ext: '0',
                mail: 'lomasverdes@asesoresgam.com.mx',
                rutaDeLaFoto: 'fotosPerfil/Veronica S.png',
              ),
            ),
          );
        } else if (title == 'Carolina Hernández') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const contactoDetalle(
                nombre: 'CAROLINA HERNÁNDEZ',
                rol: 'GERENTE DE OPERACIÓN',
                TEL: '5532202334',
                ext: '0',
                mail: 'calidad@asesoresgam.com.mx',
                rutaDeLaFoto: 'fotosPerfil/Carolina H.png',
              ),
            ),
          );
        } else if (title == 'Manuel Ramírez') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const contactoDetalle(
                nombre: 'MANUEL RAMÍREZ',
                rol: 'DIRECTOR DE SOPORTE, PROMOCIÓN Y VENTAS',
                TEL: '5527586554',
                ext: '0',
                mail: 'm.ramirez@asesoresgam.com.mx',
                rutaDeLaFoto: 'fotosPerfil/Manuel R.png',
              ),
            ),
          );
        } else {
          // Repite para otros casos
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            AspectRatio(
              aspectRatio: 1, // Mantener una relación de aspecto cuadrada
              child: CachedNetworkImage(
                imageUrl: 'http://www.asesoresgam.com.mx/sistemas1/$rutaDeLaFoto',
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
