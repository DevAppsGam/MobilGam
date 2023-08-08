import 'package:flutter/material.dart';

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
                            title: Text('Búsqueda'),
                            content: TextField(
                              // Lógica de búsqueda
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Realizar búsqueda
                                  Navigator.pop(context);
                                },
                                child: Text('Buscar'),
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
          style: TextStyle(
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
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
