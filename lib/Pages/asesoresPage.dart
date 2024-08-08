import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appgam/Pages/Contacto/contactoVidaPage.dart';
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
    const inactivityDuration = Duration(seconds: 600); // 10 minutos de inactividad
    _inactivityTimer = Timer(inactivityDuration, () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
      );
    });
  }

  void _resetInactivityTimer() {
    _inactivityTimer.cancel();
    _startInactivityTimer();
  }

  void showLoadingDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageWidth = screenWidth * 0.3; // Ajusta este valor según sea necesario
    final imageHeight = screenHeight * 0.2; // Ajusta este valor según sea necesario

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/logoApp.png',
                width: imageWidth,
                height: imageHeight,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Color.fromRGBO(250, 161, 103, 2),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double drawerTextSize = MediaQuery.textScalerOf(context).scale(20); // Ajustado según TextScaler
    double appBarTextSize = MediaQuery.textScalerOf(context).scale(16); // Ajustado según TextScaler

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
        title: GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: Text(
            "Bienvenido ${widget.nombreUsuario}",
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: appBarTextSize,
              color: const Color.fromRGBO(246, 246, 246, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            _buildDrawerItem('Inicio', Colors.blueAccent, drawerTextSize, Icons.home, () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => Asesores(nombreUsuario: widget.nombreUsuario)),
                    (Route<dynamic> route) => false,
              );
            }),
            _buildDrawerItem('Contactos', Colors.blueGrey , drawerTextSize, Icons.contact_emergency, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => contactoVida(nombreUsuario: widget.nombreUsuario)),
              );
            }),
            _buildDrawerItem('Cerrar sesión', Colors.deepOrange, drawerTextSize, Icons.exit_to_app_outlined, () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
                    (Route<dynamic> route) => false,
              );
            }),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Menú',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: MediaQuery.textScalerOf(context).scale(36), // Ajustado según TextScaler
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(73, 78, 84, 1),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Wrap(
                        spacing: 10, // Espacio horizontal entre los íconos
                        runSpacing: 10, // Espacio vertical entre las filas de íconos
                        alignment: WrapAlignment.center, // Centrar los íconos horizontalmente
                        children: List.generate(5, (index) {
                          final items = [
                            {
                              'imagePath': 'assets/img/Vida_Blanco.png',
                              'title': 'VIDA',
                              'color': const Color.fromRGBO(67, 198, 80, 1),
                            },
                            {
                              'imagePath': 'assets/img/Siniestros_Blanco.png',
                              'title': 'SINIESTROS',
                              'color': const Color.fromRGBO(249, 224, 128, 1.0),
                            },
                            {
                              'imagePath': 'assets/img/Autos_Blanco.png',
                              'title': 'AUTOS',
                              'color': const Color.fromRGBO(214, 117, 55, 1),
                            },
                            {
                              'imagePath': 'assets/img/GMM_Blanco.png',
                              'title': 'GMM',
                              'color': const Color.fromRGBO(53, 162, 219, 1),
                            },
                            {
                              'imagePath': 'assets/img/Recursos_Blanco.png',
                              'title': 'RECURSOS',
                              'color': const Color.fromRGBO(115, 117, 121, 1),
                            },
                          ];

                          return SizedBox(
                            width: MediaQuery.of(context).size.width / 2 - 20, // Ancho ajustado a la mitad de la pantalla menos el espacio entre íconos
                            height: MediaQuery.of(context).size.width / 2 - 20, // Altura igual al ancho para mantener la proporción cuadrada
                            child: IconWithText(
                              imagePath: items[index]['imagePath'] as String,
                              title: items[index]['title'] as String,
                              color: items[index]['color'] as Color,
                              nombreUsuario: widget.nombreUsuario,
                            ),
                          );
                        }),
                      ),
                      // Agrega la paginación aquí, si es necesario
                      // Por ejemplo:
                      // PaginationWidget(),
                    ],
                  ),
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

  Widget _buildDrawerItem(String title, Color color, double textSize, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Roboto',
          color: color,
          fontSize: textSize,
        ),
      ),
      onTap: onTap,
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

        double baseFontSize = 22; // Define un tamaño de fuente base
        double textScaleFactor = MediaQuery.of(context).textScaleFactor; // Obtiene el factor de escala de texto
        double fontSize = baseFontSize * textScaleFactor; // Ajusta el tamaño de la fuente según el factor de escala

        return GestureDetector(
          onTap: () async {
            showLoadingDialog(context);
            switch (title) {
              case 'VIDA':
                await Future.delayed(const Duration(seconds: 5)); // Simula una operación de carga
                Navigator.of(context).pop(); // Cierra el diálogo de carga
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Vida(nombreUsuario: nombreUsuario)),
                );
                break;
              case 'SINIESTROS':
                await Future.delayed(const Duration(seconds: 2)); // Simula una operación de carga
                Navigator.of(context).pop(); // Cierra el diálogo de carga
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Siniestro(nombreUsuario: nombreUsuario)),
                );
                break;
              case 'AUTOS':
                await Future.delayed(const Duration(seconds: 2)); // Simula una operación de carga
                Navigator.of(context).pop(); // Cierra el diálogo de carga
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Auto(nombreUsuario: nombreUsuario)),
                );
                break;
              case 'GMM':
                await Future.delayed(const Duration(seconds: 2)); // Simula una operación de carga
                Navigator.of(context).pop(); // Cierra el diálogo de carga
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Gmm(nombreUsuario: nombreUsuario)),
                );
                break;
              case 'RECURSOS':
                await Future.delayed(const Duration(seconds: 2)); // Simula una operación de carga
                Navigator.of(context).pop(); // Cierra el diálogo de carga
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Recurso(nombreUsuario: nombreUsuario)),
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
                      width: iconSize * 0.8, // Ajusta el tamaño de la imagen al 80% del tamaño del ícono
                      height: iconSize * 0.8,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FractionallySizedBox(
                widthFactor: 0.6, // Ajusta el tamaño del contenedor al 60% del ancho del contenedor padre
                child: AutoSizeText(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: color ?? Colors.black,
                  ),
                  maxLines: 1,
                  minFontSize: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}