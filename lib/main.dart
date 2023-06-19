import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Pages/asesoresPage.dart';
import 'Pages/operacionesPage.dart';
import 'Pages/gddsPage.dart';
import 'Pages/powerPage.dart';
import 'Pages/promocionesPage.dart';

void main() => runApp(const LoginApp());

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GAM LOGIN',
      home: const LoginPage(),
      routes: {
        '/PowerPage': (_) => Power(),
        '/asesoresPage': (_) => Asesores(),
        '/LoginPage': (_) => LoginPage(),
        '/promocionesPage': (_) => Promociones(),
        '/gddsPage': (_) => Gdds(),
        '/operacionesPage': (_) => Operaciones(),
      },
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

  @override
  void dispose() {
    controllerUser.dispose();
    controllerPass.dispose();
    super.dispose();
  }

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
            Navigator.pushReplacementNamed(context, '/PowerPage');
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/img/LOGOGAM.png",
                    width: 170,
                    height: 170,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color.fromRGBO(246, 239, 111, 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controllerUser,
                          decoration: const InputDecoration(
                            hintText: 'USUARIO',
                            prefixIcon: Icon(
                              Icons.person_2_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color.fromRGBO(246, 239, 111, 2),
                          boxShadow: const [
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
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: Colors.black,
                            ),
                            hintText: 'CONTRASEÑA',
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: Text(
                            'RECUPERAR MI CONTRASEÑA',
                            style: TextStyle(
                              color: const Color.fromRGBO(140, 169, 209, 2),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF0270CE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          login();
                        },
                        child: const Text('Ingresar'),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mensaje,
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.red,
                        ),
                      ),
                    ],
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
