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
        '/powerPage': (_) => Power(),
        '/asesoresPage': (_) => const Asesores(),
        '/LoginPage': (_) => const LoginPage(),
        '/promocionesPage': (_) => Promociones(),
        '/gddsPage': (_) => Gdds(),
        '/operacionesPage': (_) => Operaciones(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/Power') {
          return MaterialPageRoute(builder: (_) => Power());
        }
        return null;
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
      Uri.parse("http://192.168.1.122:8888/gam/login.php"),
      body: {
        "nomusuario": username,
        "password": password,
      },
    );
    print('Response: ${response.body}');

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

          switch (userType) {
            case 1: // Tipo de usuario 1
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Asesores()),
                    (Route<dynamic> route) => false,
              );
              break;
            case 2: // Tipo de usuario 2
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Power()),
              );
              break;
            case 3: // Tipo de usuario 3
              Navigator.pushReplacementNamed(context, '/promocionesPage');
              break;
            case 4: // Tipo de usuario 4
              Navigator.pushReplacementNamed(context, '/gddsPage');
              break;
            case 5: // Tipo de usuario 5
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
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    const url =
                        'https://asesoresgam.com.mx/aviso-de-privacidad.php';
                    launchUrl(url as Uri);
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
                    backgroundColor: const Color.fromRGBO(242, 115, 23, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                    login();
                  },
                  child: const Text(
                    'Ingresar',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                errorMessage.isNotEmpty
                    ? Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
                    : const SizedBox(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      SizedBox(height: 50),
                      Text(
                        '© 2019 Grupo Administrativo Mexicano S.A de C.V | Todos los derechos reservados',
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
