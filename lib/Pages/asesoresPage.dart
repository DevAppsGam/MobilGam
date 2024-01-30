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
    // Inicia el temporizador de inactividad al cargar la pantalla
    _startInactivityTimer();
  }

  @override
  void dispose() {
    // Cancela el temporizador al salir de la pantalla
    _inactivityTimer.cancel();
    super.dispose();
  }

  void _startInactivityTimer() {
    const inactivityDuration = Duration(seconds: 1200); // 30 segundos de inactividad
    _inactivityTimer = Timer(inactivityDuration, () {
      // Maneja la inactividad (por ejemplo, cierra la sesión)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
            (Route<dynamic> route) => false,
      );
    });
  }

  void _resetInactivityTimer() {
    // Reinicia el temporizador al detectar actividad
    _inactivityTimer.cancel();
    _startInactivityTimer();
  }

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
                // Acción al hacer clic en "Inicio"
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
                // Acción al hacer clic en "Contactos"
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
                // Acción al hacer clic en "Cerrar sesión"
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            // Puedes agregar más elementos ListTile según tus necesidades
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
                      icon: Icons.diversity_1_rounded,
                      title: 'VIDA',
                      color: const Color.fromRGBO(67, 198, 80, 1),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                    IconWithText(
                      icon: Icons.notification_important_rounded,
                      title: 'SINIESTROS',
                      color: const Color.fromRGBO(249, 224, 128, 1.0),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                    IconWithText(
                      icon: Icons.car_crash_rounded,
                      title: 'AUTOS',
                      color: const Color.fromRGBO(214, 117, 55, 1),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                    IconWithText(
                      icon: Icons.medical_information_rounded,
                      title: 'GMM',
                      color: const Color.fromRGBO(53, 162, 219, 1),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                    IconWithText(
                      icon: Icons.content_paste_search,
                      title: 'RECURSOS',
                      color: const Color.fromRGBO(115, 117, 121, 1),
                      nombreUsuario: widget.nombreUsuario,
                    ),
                    IconWithText(
                      icon: Icons.graphic_eq_outlined,
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

  const IconWithText({super.key, required this.icon, required this.title, this.color, required this.nombreUsuario});

  @override
  Widget build(BuildContext context) {
    String imagePath = '';
    switch (title) {
      case 'VIDA':
        imagePath = 'assets/img/Vida_Blanco.png';
        break;
      case 'GMM':
        imagePath = 'assets/img/GMM_Blanco.png';
        break;
      case 'SINIESTROS':
        imagePath = 'assets/img/Siniestros_Blanco.png';
        break;
      case 'AUTOS':
        imagePath = 'assets/img/Autos_Blanco.png';
        break;
      case 'RECURSOS':
        imagePath = 'assets/img/Recursos_Blanco.png';
        break;
      case 'ESTADISTICAS':
        imagePath = 'assets/img/Estadisticas_Blanco.png';
        break;
      default:
        imagePath = 'assets/img/GAM_TV.png';
    }
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
              MaterialPageRoute(builder: (context) => Siniestro(nombreUsuario: nombreUsuario,)),
            );
            break;
          case 'AUTOS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Auto(nombreUsuario: nombreUsuario,)),
            );
            break;
          case 'GMM':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Gmm(nombreUsuario: nombreUsuario,)),
            );
            break;
          case 'RECURSOS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Recurso(nombreUsuario: nombreUsuario,)),
            );
            break;
          case 'ESTADISTICAS':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  Graficas(nombreUsuario: nombreUsuario,)),
            );
            break;
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              color: color ?? Colors.white,
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 64,
                height: 64,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 17.5,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
