import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Vida extends StatefulWidget {
  const Vida({Key? key}) : super(key: key);

  @override
  _VidaState createState() => _VidaState();
}

class _VidaState extends State<Vida> {
  // Ejemplo de datos de la base de datos
  List<Map<String, String>> datos = [
    {
      'folioGAM': '12345',
      'nombreContratante': 'Juan Pérez',
      'nPoliza': '98765',
      'folioGNP': '54321',
      'fechaPromesa': '2023-08-15',
      'estatusTramite': 'En proceso',
    },
    // Agregar más datos según sea necesario
  ];

  @override
  void initState() {
    super.initState();
    // Cambiar la orientación a horizontal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Restaurar la orientación predeterminada
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BIENVENIDO ASESOR',
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
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mis Trámites de Vida',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Mostrar cuadro de diálogo de búsqueda
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Búsqueda'),
                            content: const TextField(
                              // Lógica de búsqueda
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Realizar búsqueda
                                  Navigator.pop(context);
                                },
                                child: const Text('Buscar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.blueAccent,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el primer filtro
                      },
                      child: const Text('ALTA DE POLIZA'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el segundo filtro
                      },
                      child: const Text('PAGOS'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el tercer filtro
                      },
                      child: const Text('MOVIMIENTOS'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el cuarto filtro
                      },
                      child: const Text('A TIEMPO'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el quinto filtro
                      },
                      child: const Text('POR VENCER'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el sexto filtro
                      },
                      child: const Text('VENCIDOS'),
                    ),
                  ],
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Table(
                border: TableBorder.all(
                  color: Colors.blueAccent,
                  width: 2.0,
                ),
                children: [
                  _buildTableHeaderRow(),
                  for (var dato in datos) _buildTableRow(dato),
                ],
              ),

            ),
// Añadir el Align y el IconButton aquí
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {
                  // Lógica para manejar la acción del ícono
                  // Por ejemplo, puedes abrir un cuadro de diálogo, realizar una acción, etc.
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

  TableRow _buildTableHeaderRow() {
    return TableRow(
      children: [
        _buildTableHeaderCell('Folio GAM'),
        _buildTableHeaderCell('Nombre del Contratante'),
        _buildTableHeaderCell('N Poliza'),
        _buildTableHeaderCell('Folio GNP'),
        _buildTableHeaderCell('Fecha Promesa'),
        _buildTableHeaderCell('Estatus Trámite'),
      ],
    );
  }

  TableCell _buildTableHeaderCell(String text) {
    return TableCell(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(Map<String, String> dato) {
    return TableRow(
      children: [
        _buildTableCell(dato['folioGAM']!),
        _buildTableCell(dato['nombreContratante']!),
        _buildTableCell(dato['nPoliza']!),
        _buildTableCell(dato['folioGNP']!),
        _buildTableCell(dato['fechaPromesa']!),
        _buildTableCell(dato['estatusTramite']!),
      ],
    );
  }

  TableCell _buildTableCell(String text) {
    return TableCell(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}