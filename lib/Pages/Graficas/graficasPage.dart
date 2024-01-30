import 'package:flutter/material.dart';

class Graficas extends StatefulWidget {
  final String nombreUsuario;

  const Graficas({super.key, required this.nombreUsuario});

  @override
  _GraficasState createState() => _GraficasState();
}

class _GraficasState extends State<Graficas> {
  // Mantén solo las partes esenciales del código, eliminando el resto

  @override
  void initState() {
    super.initState();
  }

  // Elimina partes no esenciales del código

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido ${widget.nombreUsuario}',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/back.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/img/mantenimiento.png',
                width: 500,  // Ajusta el ancho según tus necesidades
                height: 500,  // Ajusta la altura según tus necesidades
              ),
            ),
            Positioned(
              bottom: 16,  // Ajusta la posición vertical según sea necesario
              right: 16,  // Ajusta la posición horizontal según sea necesario
              child: IconButton(
                onPressed: () {
                  // Lógica para manejar la acción del ícono
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

void main() {
  runApp(const MaterialApp(
    home: Graficas(nombreUsuario: ''),
  ));
}
