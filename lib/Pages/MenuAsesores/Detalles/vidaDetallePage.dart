import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

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
    final String url = 'http://192.168.1.75/gam/detallevida.php?id=${widget.id}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          setState(() {
            data = jsonData[0];
          });
        } else {
          // Manejar el caso en el que no se encontraron datos.
          // Puedes mostrar un mensaje de error o una página vacía.
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

  Future<List<Map<String, dynamic>>?> fetchDataForSecondTable() async {
    final String secondTableUrl = 'http://192.168.1.75/gam/detallevidadocumentos.php?id=${widget.id}';
    try {
      final response = await http.get(Uri.parse(secondTableUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          // Los datos se obtuvieron correctamente, así que los devolvemos.
          return jsonData.cast<Map<String, dynamic>>();
        } else {
          // No se encontraron datos en la segunda tabla.
          return [];
        }
      } else {
        // Manejar errores aquí, como mostrar un mensaje de error.
        print('Error al obtener datos de la segunda tabla: ${response.statusCode}');
        return null; // Devolvemos null en caso de error.
      }
    } catch (error) {
      // Manejar errores de excepción aquí.
      print('Error al obtener datos de la segunda tabla: $error');
      return null; // Devolvemos null en caso de error.
    }
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      // Aquí puedes acceder a la información del archivo seleccionado, como su nombre y bytes.
      print('Nombre del archivo: ${file.name}');
      print('Bytes del archivo: ${file.bytes}');

      // También puedes realizar acciones adicionales, como enviar el archivo al servidor.
    } else {
      // El usuario canceló la selección de archivos.
      print('Selección de archivos cancelada.');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Póliza de ${widget.nombreUsuario}'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                    DataColumn(label: Text('Folio GAM')),
                    DataColumn(label: Text('Línea de Negocio')),

                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text('Folio GAM')),
                        DataCell(Text(data['id'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Línea de Negocio')),
                        DataCell(Text(data['negocio'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Fecha de Solicitud')),
                        DataCell(Text(data['fecha'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Estado')),
                        DataCell(Text(data['estado'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Contratante')),
                        DataCell(Text(data['contratante'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Póliza')),
                        DataCell(Text(data['poliza'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Tipo de Solicitud')),
                        DataCell(Text(data['t_solicitud'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Tipo de Movimiento')),
                        DataCell(Text(data['movimiento'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Monto')),
                        DataCell(Text(data['monto'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Moneda de Pagos')),
                        DataCell(Text(data['moneda_pagos'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Prioridad')),
                        DataCell(Text(data['prioridad'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Comentarios')),
                        DataCell(Text(data['comentarios'] ?? '***')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Text('Folio GNP')),
                        DataCell(Text(data['fgnp'] ?? '***')),
                      ],
                    ),
                    // ... Otras filas de datos aquí ...
                  ],
                ),
                const SizedBox(height: 32),

                const SizedBox(height: 32),
                const Text(
                  'Documentos Relacionados',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>?>(
                  future: fetchDataForSecondTable(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No hay datos disponibles en la segunda tabla.');
                    } else if (snapshot.hasError) {
                      return const Text('Error al cargar los datos de la segunda tabla.');
                    } else {
                      final List<Map<String, dynamic>> secondTableData = snapshot.data!;

                      return SingleChildScrollView( // Agregar el SingleChildScrollView aquí
                        scrollDirection: Axis.horizontal, // Esto permite el desplazamiento horizontal
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Usuario')),
                            DataColumn(label: Text('Nombre del Archivo')),
                            DataColumn(label: Text('Ver')),
                            DataColumn(label: Text('Descargar')),
                            DataColumn(label: Text('Aprobado')),
                            DataColumn(label: Text('Fecha de Carga')),
                          ],
                          rows: secondTableData.map((data) {
                            return DataRow(
                              cells: [
                                DataCell(Text(data['nomusuario'] ?? '***')),
                                DataCell(Text(data['nombre'] ?? '***')),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () {
                                      // Lógica para abrir o ver el archivo aquí.
                                      // Puedes usar navegación o mostrar un visor de archivos, según tus necesidades.
                                    },
                                    child: const Text('a'),
                                  ),
                                ),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () {
                                      // Lógica para abrir o ver el archivo aquí.
                                      // Puedes usar navegación o mostrar un visor de archivos, según tus necesidades.
                                    },
                                    child: const Text('a'),
                                  ),
                                ),
                                DataCell(
                                  data['validado'] == true
                                      ? const Icon(
                                    Icons.check,
                                    color: Colors.green, // Color verde para el ícono de paloma
                                  )
                                      : const Icon(
                                    Icons.cancel,
                                    color: Colors.red, // Color rojo para el ícono de tache
                                  ),
                                ),
                                DataCell(Text(data['fecha_creacion'] ?? '***')),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
            /*
            const SizedBox(height: 32),
                const Text(
                  'Subir Documentos',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Subir Archivo')),
                    DataColumn(label: Text('Opción')),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(ElevatedButton(
                        onPressed: () {
                          // Lógica para abrir el selector de archivos aquí
                          _pickDocument();
                        },
                        child: const Text('Seleccionar Archivo'),
                      )),
                      DataCell(DropdownButton<String>(
                        // Aquí configura la lista desplegable con las 10 opciones
                        items: List.generate(10, (index) {
                          return DropdownMenuItem<String>(
                            value: 'Opción ${index + 1}',
                            child: Text('Opción ${index + 1}'),
                          );
                        }),
                        onChanged: (value) {
                          // Lógica para manejar la selección de la opción aquí
                        },
                        value: null, // Puedes establecer un valor inicial si es necesario
                      )),
                      DataCell(ElevatedButton(
                        onPressed: () {
                          // Lógica para confirmar aquí
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                        ),
                        child: const Text('Confirmar'),
                      )),
                      DataCell(ElevatedButton(
                        onPressed: () {
                          // Lógica para cancelar aquí
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                        ),
                        child: const Text('Cancelar'),
                      )),
                    ]),
                  ],
                ),
                */
                const SizedBox(height: 32),
                const Text(
                  'Historial',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
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