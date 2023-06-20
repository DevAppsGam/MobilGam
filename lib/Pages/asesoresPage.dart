import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Asesores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BIENVENIDO ASESOR",
          style: TextStyle(
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'MENU',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                children: const [
                  IconWithText(
                    icon: Icons.diversity_1_rounded,
                    title: 'VIDA',
                    color: Colors.green,
                  ),
                  IconWithText(
                    icon: Icons.notification_important_rounded,
                    title: 'SINIESTROS',
                    color: Colors.yellow,
                  ),
                  IconWithText(
                    icon: Icons.car_crash_rounded,
                    title: 'AUTOS',
                    color: Colors.orange,
                  ),
                  IconWithText(
                    icon: Icons.medical_information_rounded,
                    title: 'GMM',
                    color: Colors.blueAccent,
                  ),
                  IconWithText(
                    icon: Icons.content_paste_search,
                    title: 'RECURSOS',
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {
                  const url = 'https://www.example.com';
                  launchUrl(url as Uri);
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
    );
  }
}

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? color;

  const IconWithText({required this.icon, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la página correspondiente al icono seleccionado
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconTheme(
            data: IconThemeData(color: color),
            child: Icon(
              icon,
              size: 64,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
