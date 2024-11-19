import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'Pages/asesoresPage.dart';
import 'Pages/gddsPage.dart';
import 'Pages/operacionesPage.dart';
import 'Pages/powerPage.dart';
import 'Pages/promocionesPage.dart';

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}

void showLoadingDialog(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  final imageWidth = screenWidth * 0.2;
  final imageHeight = screenHeight * 0.1;

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
            const SizedBox(height: 10),
            const CircularProgressIndicator(
              color: Color.fromRGBO(250, 161, 103, 2),
            ),
          ],
        ),
      );
    },
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerUser = TextEditingController();
  final TextEditingController controllerPass = TextEditingController();
  bool obscurePassword = true;
  bool isLoading = false;

  Future<void> login() async {
    final username = controllerUser.text;
    final password = controllerPass.text;

    if (username.isEmpty || password.isEmpty) {
      showErrorDialog(context, 'Por favor, ingrese el usuario y la contraseña.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    showLoadingDialog(context);

    try {
      final response = await http.post(
        Uri.parse("https://www.asesoresgam.com.mx/sistemas1/gam/login.php"),
        body: {
          "nomusuario": username,
          "password": password,
        },
      );

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop(); // Close loading dialog

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey("error")) {
            showErrorDialog(context, responseData["error"]);
          } else {
            final int userType = responseData['tipo'];
            final String nombreUsuario = responseData['nomusuario'];

            switch (userType) {
              case 1:
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Asesores(nombreUsuario: nombreUsuario)),
                      (Route<dynamic> route) => false,
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Power()),
                );
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/promocionesPage');
                break;
              case 4:
                Navigator.pushReplacementNamed(context, '/gddsPage');
                break;
              case 5:
                Navigator.pushReplacementNamed(context, '/operacionesPage');
                break;
              default:
                showErrorDialog(context, 'Tipo de usuario desconocido');
            }
          }
        } else {
          showErrorDialog(context, 'Usuario o contraseña incorrecta');
        }
      } else {
        showErrorDialog(context, 'Error de conexión');
      }
    } catch (e) {
      showErrorDialog(context, 'Error de conexión');
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          children: <Widget>[
            SizedBox(height: screenHeight * 0.20),
            Image.asset(
              'assets/img/IntraGAM.png',
              width: screenWidth * 0.3,
              height: screenHeight * 0.1,
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: screenHeight * 0.03,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            _buildInputField(
              controller: controllerUser,
              hintText: 'USUARIO',
              icon: Icons.person,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildInputField(
              controller: controllerPass,
              hintText: 'CONTRASEÑA',
              icon: Icons.lock,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: togglePasswordVisibility,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            GestureDetector(
              onTap: () {
                const url = 'https://asesoresgam.com.mx/aviso-de-privacidad.php';
                launchUrl(Uri.parse(url));
              },
              child: const Text(
                'Aviso de privacidad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Ingresar',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            const Text(
              '© 2019 Grupo Administrativo Mexicano S.A de C.V | Todos los derechos reservados',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación GAM',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
      routes: {
        // Aquí puedes agregar otras rutas si es necesario
        '/promocionesPage': (context) => const Promociones(),
        '/gddsPage': (context) => const Gdds(),
        '/operacionesPage': (context) => const Operaciones(),
      },
    );
  }
}

void main() {
  runApp(const MyApp());
}
