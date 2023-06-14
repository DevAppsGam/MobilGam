import 'dart:convert';

import 'package:appgam/Pages/asesoresPage.dart';
import 'package:appgam/Pages/gddsPage.dart';
import 'package:appgam/Pages/operacionesPage.dart';
import 'package:appgam/Pages/powerPage.dart';
import 'package:appgam/Pages/promocionesPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const LoginApp());

String username='';

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GAM LOGIN',
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/powerPage': (BuildContext context) => Power(),
        '/asesoresPage': (BuildContext context) => Asesores(),
        '/LoginPage': (BuildContext context) => LoginPage(),
        '/promocionesPage': (BuildContext context) => Promociones(),
        '/gddsPage': (BuildContext context) => Gdds(),
        '/operacionesPage': (BuildContext context) => Operaciones(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  String mensaje = '';

  Future<void> login() async {
    final response = await http.post(
      "http://192.168.1.98/gam/login.php" as Uri,
        body: {
          "username": controllerUser.text,
          "password": controllerPass.text,
        },
    );
    var datauser=json.decode(response.body);
    if(datauser.length==0){
      setState(() {
        mensaje="USUARIO O CONTRASEÑA INCORRECTA";
      });
    }else {
      String userType = datauser[0]['tipo'];
      switch (userType) {
        case 'admin':
          Navigator.pushReplacementNamed(context, '/powerPage');
          break;
        case 'promocion':
          Navigator.pushReplacementNamed(context, '/promocionesPage');
          break;
        case 'gdd':
          Navigator.pushReplacementNamed(context, '/gddsPage');
          break;
        case 'operacion':
          Navigator.pushReplacementNamed(context, '/operacionesPage');
          break;
        case 'agente':
          Navigator.pushReplacementNamed(context, '/asesoresPage');
          break;
        default:
        // Si no coincide con ningún tipo de usuario conocido, se muestra un mensaje de error
          setState(() {
            mensaje = "TIPO DE USUARIO DESCONOCIDO";
          });
      }
      setState(() {
        username=datauser[0]['username'];
      });
    }
    return datauser;
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
          child: Column(
            children: <Widget>[
              Container(
                width: 170.0,
                height: 170.0,
              ),
              Container(
                padding: const EdgeInsets.only(top: 200.0), // Ajusta el valor del top para mover la imagen hacia abajo
                width: 170.0,
                height: 225.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: AssetImage("assets/img/LOGOGAM.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
              ),
              Container(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top:93),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      padding: const EdgeInsets.only(
                        top: 4,
                        left: 16,
                        right: 16,
                        bottom: 4,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color.fromRGBO(246, 239, 111, 2),
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
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      height: 50,
                      margin: const EdgeInsets.only(
                        top: 32
                      ),
                      padding: const EdgeInsets.only(
                        top: 4,
                        left: 16,
                        right: 16,
                        bottom: 4
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color.fromRGBO(246, 239, 111, 2),
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
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: EdgeInsets.only(
                            top: 6,
                            right: 32,
                          ),
                        child: Text(
                          'RECUPERAR MI CONTRASEÑA',
                          style: TextStyle(
                            color: Color.fromRGBO(140, 169, 209, 2),
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
                       Navigator.pop(context);
                      },
                      child: const Text('Ingresar'),
                    ),
                    Text(
                      mensaje,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.red
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}