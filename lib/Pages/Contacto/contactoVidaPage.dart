import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class contactoVida extends StatelessWidget {
  final String nombreUsuario;

  const contactoVida({super.key, required this.nombreUsuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
        title: Text(
          "Bienvenido $nombreUsuario",
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 18, // Tamaño reducido para evitar desbordamientos
            color: Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Contacto de VIDA',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: MediaQuery.of(context).size.width * 0.05, // Ajustado
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return _buildContactCard(index, context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          const url = 'https://www.example.com';
          launchUrl(Uri.parse(url));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.message_rounded, size: 28),
      ),
    );
  }

  Widget _buildContactCard(int index, BuildContext context) {
    final title = _getContactTitle(index);
    final subtitle = _getContactSubtitle(index);
    final imagePath = _getImagePath(index);

    return GestureDetector(
      onTap: () {
        // Navegación a contacto detalle
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: 'http://www.asesoresgam.com.mx/sistemas1/$imagePath',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 6, // Tamaño ajustado
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getContactTitle(int index) {
    switch (index) {
      case 0:
        return 'Patricia Moctezuma';
      case 1:
        return 'Diana Castro';
      case 2:
        return 'Veronica Sanchez';
      case 3:
        return 'Carolina Hernández';
      case 4:
        return 'Manuel Ramírez';
      default:
        return 'Contacto $index';
    }
  }

  String _getContactSubtitle(int index) {
    switch (index) {
      case 0:
        return 'Gerente de Promoción de Vida';
      case 1:
        return 'Consultor Especializado Vida';
      case 2:
        return 'Consultor Integral';
      case 3:
        return 'Gerente de operación y servicio';
      case 4:
        return 'Director de soporte, promoción y ventas';
      default:
        return 'Subtítulo $index';
    }
  }

  String _getImagePath(int index) {
    switch (index) {
      case 0:
        return 'fotosPerfil/Patricia M.png';
      case 1:
        return 'fotosPerfil/Diana C.png';
      case 2:
        return 'fotosPerfil/Veronica S.png';
      case 3:
        return 'fotosPerfil/Carolina H.png';
      case 4:
        return 'fotosPerfil/Manuel R.png';
      default:
        return 'fotosPerfil/default.png';
    }
  }
}
