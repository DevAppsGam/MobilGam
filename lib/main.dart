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
        '/promocionesPage': (_) =>  const Promociones(),
        '/gddsPage': (_) =>  const Gdds(),
        '/operacionesPage': (_) =>  const Operaciones(),
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
    await Future.delayed(const Duration(seconds: 10));
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
          setState(() {
            errorMessage = responseData["error"];
          });
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
              setState(() {
                errorMessage = 'Tipo de usuario desconocido';
              });
          }
        }
      } else {
        setState(() {
          errorMessage = 'Usuario o contraseña incorrecta';
        });
      }
    } else {
      setState(() {
        errorMessage = 'Error de conexión';
      });
    }
  }

  void togglePasswordVisibility() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
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
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 200),
            Image.asset(
              'assets/img/IntraGAM.png',
              width: 75.0,
              height: 65.0,
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(73, 78, 84, 1),
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(height: 50),
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
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
                style: const TextStyle(fontFamily: 'Roboto', fontSize: 20),
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
              child: TextField(
                style: const TextStyle(fontFamily: 'Roboto', fontSize: 20),
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
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () {
                const url = 'https://asesoresgam.com.mx/aviso-de-privacidad.php';
                launchUrl(Uri.parse(url));
              },
              child: const Text(
                'Aviso de privacidad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(31, 123, 206, 1),
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            const SizedBox(height: 50),
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
              child: const Text(
                'Ingresar',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 50),
            const Text(
              '© 2019 Grupo Administrativo Mexicano S.A de C.V | Todos los derechos reservados',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(246, 246, 246, 1),
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
