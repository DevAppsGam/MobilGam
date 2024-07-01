import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'Pages/asesoresPage.dart';
import 'Pages/operacionesPage.dart';
import 'Pages/gddsPage.dart';
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
              'assets/img/LOGOGAM.png',
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


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await initDeviceInfo();
  runApp(const MyApp());
}

Future<void> initDeviceInfo() async {
  await DeviceInfoPlugin().androidInfo;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GAM LOGIN',
      home: const SplashScreen(),
      routes: {
        '/powerPage': (_) => const Power(),
        '/asesoresPage': (_) => const Asesores(nombreUsuario: ''),
        '/LoginPage': (_) => const LoginPage(),
        '/promocionesPage': (_) => const Promociones(),
        '/gddsPage': (_) => const Gdds(),
        '/operacionesPage': (_) => const Operaciones(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/Power') {
          return MaterialPageRoute(builder: (_) => const Power());
        }
        return null;
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
    await Future.delayed(const Duration(seconds: 5));
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
                'assets/img/GAM_TV.png',
                width: 200,
                height: 200,
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
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerUser = TextEditingController();
  final TextEditingController controllerPass = TextEditingController();
  String errorMessage = '';
  bool obscurePassword = true;
  bool isLoading = false;

  Future<void> login() async {
    final username = controllerUser.text;
    final password = controllerPass.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = 'Por favor, complete todos los campos.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    showLoadingDialog(context);  // Mostrar el diálogo de carga

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

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey("error")) {
            Navigator.of(context).pop();  // Cerrar el diálogo de carga
            showErrorDialog(context, responseData["error"]);
          } else {
            final int userType = responseData['tipo'];
            final String nombreUsuario = responseData['nomusuario'];

            Navigator.of(context).pop();  // Cerrar el diálogo de carga antes de la navegación

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
          Navigator.of(context).pop();  // Cerrar el diálogo de carga
          showErrorDialog(context, 'Usuario o contraseña incorrecta');
        }
      } else {
        Navigator.of(context).pop();  // Cerrar el diálogo de carga
        showErrorDialog(context, 'Error de conexión');
      }
    } catch (e) {
      Navigator.of(context).pop();  // Cerrar el diálogo de carga
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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.2)),
      child: Scaffold(
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
              SizedBox(height: screenHeight * 0.25),
              Image.asset(
                'assets/img/IntraGAM.png',
                width: screenWidth * 0.3,
                height: screenHeight * 0.1,
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Bienvenido',
                  style: TextStyle(
                    fontSize: MediaQuery.textScalerOf(context).scale(28),
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(73, 78, 84, 1),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
                  //textScaler: MediaQuery.textScalerOf(context),
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.textScalerOf(context).scale(25),
                  ),
                  controller: controllerUser,
                  autofocus: true,
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
              SizedBox(height: screenHeight * 0.02),
              Container(
                height: screenHeight * 0.07,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
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
                child: Center(
                  child: TextField(
                    //textScaler: MediaQuery.textScalerOf(context),
                    style:  TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: MediaQuery.textScalerOf(context).scale(25),
                    ),
                    controller: controllerPass,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      icon: const Icon(
                        Icons.vpn_key,
                        color: Colors.black,
                      ),
                      hintText: 'CONTRASEÑA',
                      fillColor: Colors.transparent,
                      filled: true,
                      suffixIcon: GestureDetector(
                        onTap: togglePasswordVisibility,
                        child: Icon(
                          obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              GestureDetector(
                onTap: () {
                  const url = 'https://asesoresgam.com.mx/aviso-de-privacidad.php';
                  launchUrl(Uri.parse(url));
                },
                child: Text(
                  'Aviso de privacidad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.textScalerOf(context).scale(20),
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(31, 123, 206, 1),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(245, 137, 63, 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: isLoading ? null : () {
                  login();
                },
                child: Text(
                  'Ingresar',
                  textScaler: MediaQuery.textScalerOf(context),
                  style: TextStyle(
                    fontSize: MediaQuery.textScalerOf(context).scale(24),
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                '© 2019 Grupo Administrativo Mexicano S.A de C.V | Todos los derechos reservados',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.textScalerOf(context).scale(12),
                  color: const Color.fromRGBO(42, 37, 37, 1.0),
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
