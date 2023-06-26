import 'package:appgam/Pages/asesoresPage.dart';
import 'package:appgam/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Vida extends StatelessWidget {
  void _setPortraitOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(1080, 1920),
      //allowFontScaling: true,
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return WillPopScope(
      onWillPop: () async {
        _setPortraitOrientation();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Text(
              "BIENVENIDO ASESOR",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: ScreenUtil().setSp(24),
                //textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  'INICIO',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.blueAccent,
                    fontSize: ScreenUtil().setSp(24),
                    //textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                onTap: () {
                  _setPortraitOrientation(); // Cambiar la orientación de vuelta a vertical
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Asesores(),
                    ),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
              ListTile(
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.deepOrange,
                    fontSize: ScreenUtil().setSp(40),
                   // textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoginPage(),
                    ),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
        body: FractionallySizedBox(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                child: Text(
                  'MIS TRAMITES DE VIDA',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: ScreenUtil().setSp(60),
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                    //textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
