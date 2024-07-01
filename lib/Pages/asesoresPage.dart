import 'dart:async';
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
import 'package:flutter/services.dart';

class Asesores extends StatefulWidget {
  final String nombreUsuario;

  const Asesores({super.key, required this.nombreUsuario});

  @override
  _AsesoresState createState() => _AsesoresState();
}

class _AsesoresState extends State<Asesores> {
  late Timer _inactivityTimer;

  @override
  void initState() {
    super.initState();
    _startInactivityTimer();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    _inactivityTimer.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  void _startInactivityTimer() {
    const inactivityDuration = Duration(seconds: 300); // 5 minutos de inactividad
    _inactivityTimer = Timer(inactivityDuration, () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
            (Route<dynamic> route) => false,
      );
    });
  }

  void _resetInactivityTimer() {
    _inactivityTimer.cancel();
    _startInactivityTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
        title: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Text(
            "Bienvenido ${widget.nombreUsuario}",
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 17,
              color: Color.fromRGBO(246, 246, 246, 1),
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
                  MaterialPageRoute(builder: (BuildContext context) => Asesores(nombreUsuario: widget.nombreUsuario)),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => contactoVida(nombreUsuario: widget.nombreUsuario)),
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
      body: GestureDetector(
        onTap: _resetInactivityTimer,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/back.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Menú',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(73, 78, 84, 1),
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  children: [
                    IconWithText(
                      imagePath: 'assets/img/Vida_Blanco.png',
                      title: 'VIDA',
                      color: const Color.fromRGBO(67, 198, 80, 1),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                    IconWithText(
                      imagePath: 'assets/img/Siniestros_Blanco.png',
                      title: 'SINIESTROS',
                      color: const Color.fromRGBO(249, 224, 128, 1.0),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                    IconWithText(
                      imagePath: 'assets/img/Autos_Blanco.png',
                      title: 'AUTOS',
                      color: const Color.fromRGBO(214, 117, 55, 1),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                    IconWithText(
                      imagePath: 'assets/img/GMM_Blanco.png',
                      title: 'GMM',
                      color: const Color.fromRGBO(53, 162, 219, 1),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                    IconWithText(
                      imagePath: 'assets/img/Recursos_Blanco.png',
                      title: 'RECURSOS',
                      color: const Color.fromRGBO(115, 117, 121, 1),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                    IconWithText(
                      imagePath: 'assets/img/Estadisticas_Blanco.png',
                      title: 'ESTADISTICAS',
                      color: const Color.fromRGBO(65, 178, 182, 1),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () async {
                    const url = 'https://www.example.com';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
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
      ),
    );
  }
}

class IconWithText extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color? color;
  final String nombreUsuario;

  const IconWithText({
    super.key,
    required this.imagePath,
    required this.title,
    this.color,
    required this.nombreUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
      double iconSize = constraints.maxWidth * 0.6; // Ajusta el tamaño del ícono al 60% del ancho del contenedor
      double fontSize = constraints.maxWidth * 0.1; // Ajusta el tamaño del texto al 10% del ancho del contenedor
      return GestureDetector(
          onTap: () {
        switch (title) {
          case 'VIDA':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Vida(nombreUsuario: nombreUsuario)),
            );
            break;
          case 'SINIESTROS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Siniestro(nombreUsuario: nombreUsuario)),
            );
            break;
          case 'AUTOS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Auto(nombreUsuario: nombreUsuario)),
            );
            break;
          case 'GMM':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Gmm(nombreUsuario: nombreUsuario)),
            );
            break;
          case 'RECURSOS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Recurso(nombreUsuario: nombreUsuario)),
            );
            break;
          case 'ESTADISTICAS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Graficas(nombreUsuario: nombreUsuario)),
            );
            break;
        }
      },
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    FractionallySizedBox(
    widthFactor: 0.6, // Ajusta el tamaño del contenedor al 60% del ancho del contenedor padre
    child: Container(
    height: iconSize, // La altura será la misma que el tamaño del ícono
    decoration: BoxDecoration(
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(20),
    color: color ?? const Color.fromRGBO(33, 0, 0, 1),
    ),
    child: Center(
    child: Image.asset(
    imagePath,
    width: iconSize * 0.8, // Ajusta el tamaño de la imagen al 80% del tamaño del
      height: iconSize * 0.8,
    ),
    ),
    ),
    ),
      const SizedBox(height: 8),
      FractionallySizedBox(
        widthFactor: 0.6, // Ajusta el tamaño del contenedor al 60% del ancho del contenedor padre
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black,
          ),
        ),
      ),
    ],
    ),
      );
        },
    );
  }
}
