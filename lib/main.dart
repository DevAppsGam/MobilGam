import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Pages/asesoresPage.dart';
import 'Pages/operacionesPage.dart';
import 'Pages/gddsPage.dart';
import 'Pages/powerPage.dart';
import 'Pages/promocionesPage.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GAM LOGIN',
      home: const SplashScreen(),
      routes: {
        '/PowerPage': (_) => Power(),
        '/asesoresPage': (_) => Asesores(),
        '/LoginPage': (_) => const LoginPage(),
        '/promocionesPage': (_) => Promociones(),
        '/gddsPage': (_) => Gdds(),
        '/operacionesPage': (_) => Operaciones(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadSplashScreen();
  }

  Future<void> _loadSplashScreen() async {
    await Future.delayed(const Duration(seconds: 7));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                //LOGO PANTALLA CARGA
                'assets/img/LOGOGAM.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: Color.fromRGBO(250, 161, 103, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerUser = TextEditingController();
  final TextEditingController controllerPass = TextEditingController();
  String mensaje = '';

  Future<void> login() async {
    final response = await http.post(
      Uri.parse("http://192.168.1.98/gam/login.php"),
      body: {
        "username": controllerUser.text,
        "password": controllerPass.text,
      },
    );

    final Map<String, dynamic> datauser =
    jsonDecode(response.body) as Map<String, dynamic>;
    if (datauser.isEmpty) {
      setState(() {
        mensaje = "USUARIO O CONTRASEÑA INCORRECTA";
      });
    } else {
      final String userType = datauser['tipo'];
      switch (userType) {
        case 'admin':
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/Power');
          }
          break;
        case 'promocion':
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/promocionesPage');
          }
          break;
        case 'gdd':
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/gddsPage');
          }
          break;
        case 'operacion':
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/operacionesPage');
          }
          break;
        case 'agente':
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/asesoresPage');
          }
          break;
        default:
          if (mounted) {
            setState(() {
              mensaje = "TIPO DE USUARIO DESCONOCIDO";
            });
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/img/back.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 100),
                Image.asset(
                  'assets/img/IntraGAM.png',
                  width: 170.0,
                  height: 250.0,
                ),
                //MENSAJE BIENVENIDO
                const SizedBox(height: 20),
                const Text(
                  '!BIENVENIDO!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(73, 78, 84, 1),
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 16,
                    right: 16,
                    bottom: 4,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: controllerUser,
                    decoration: const InputDecoration(
                      hintText: 'USUARIO',
                      icon: Icon(
                        Icons.person_2_rounded,
                        color: Colors.black,
                      ),
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 50,
                  margin: const EdgeInsets.only(top: 32),
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 16,
                    right: 16,
                    bottom: 4,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controllerPass,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.vpn_key,
                        color: Colors.black,
                      ),
                      hintText: 'CONTRASEÑA',
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    const url = 'https://asesoresgam.com.mx/aviso-de-privacidad.php';
                    launch(url); // Abrir el enlace en el navegador del dispositivo
                  },
                  child: const Text(
                    'Aviso de privacidad',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(242, 115, 23, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    login();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Ingresar',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        '© 2019 Grupo Administrativo Mexicano S.A de C.V | Todos los derechos reeservados',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(167, 168, 160, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
