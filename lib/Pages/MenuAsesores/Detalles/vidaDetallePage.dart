import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetalleVida extends StatefulWidget {
  final String nombreUsuario;
  final String id;

  DetalleVida({required this.nombreUsuario, required this.id});

  @override
  _DetalleVidaState createState() => _DetalleVidaState();
}

class _DetalleVidaState extends State<DetalleVida> {
  Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    fetchDataFromPHP();
  }

  Future<void> fetchDataFromPHP() async {
    final String url = 'http://192.168.100.73/gam/detallevida.php?id=${widget.id}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          setState(() {
            data = jsonData[0];
          });
        } else {
          // Manejar el caso en el que no se encontraron datos.
        }
      } else {
        // Manejar errores aquí, como mostrar un mensaje de error.
        print('Error al obtener datos: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores de excepción aquí.
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Póliza de ${widget.nombreUsuario}'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Información de la Póliza',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 16),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Campo')),
                    DataColumn(label: Text('Valor')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text('Negocio')),
                        DataCell(Text(data['negocio'] ?? '')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Fecha')),
                        DataCell(Text(data['fecha'] ?? '')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Estado')),
                        DataCell(Text(data['estado'] ?? '')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Contratante')),
                        DataCell(Text(data['contratante'] ?? '')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Poliza')),
                        DataCell(Text(data['polizap'] ?? '')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Tipo de Solicitud')),
                        DataCell(Text(data['t_solicitud'] ?? '')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Monto')),
                        DataCell(Text(data['monto'] ?? '')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Moneda de Pagos')),
                        DataCell(Text(data['moneda_pagos'] ?? '')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Prioridad')),
                        DataCell(Text(data['prioridad'] ?? '')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Comentarios')),
                        DataCell(Text(data['comentarios'] ?? '')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Folio GNP')),
                        DataCell(Text(data['fgnp'] ?? '')),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
