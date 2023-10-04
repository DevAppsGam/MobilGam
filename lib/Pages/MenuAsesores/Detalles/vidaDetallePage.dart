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
  bool isLoading = false;
  String errorMessage = '';
  final TextEditingController _observationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataFromPHP();
  }

  Future<void> fetchDataFromPHP() async {
    if (!mounted) return; // Evitar actualizaciones si el widget ya no está en el árbol

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final String url = 'http://192.168.1.75/gam/detallevida.php?id=${widget.id}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          setState(() {
            data = jsonData[0];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'No se encontraron datos.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Error al obtener datos: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $error';
      });
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

  Future<List<Map<String, dynamic>>?> fetchDataForThirdTable() async {
    final String thirdTableUrl = 'http://192.168.1.75/gam/detallevidaobservaciones.php?id=${widget.id}';
    try {
      final response = await http.get(Uri.parse(thirdTableUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          // Los datos se obtuvieron correctamente, así que los devolvemos.
          return jsonData.cast<Map<String, dynamic>>();
        } else {
          // No se encontraron datos en la tercera tabla.
          return [];
        }
      } else {
        // Manejar errores aquí, como mostrar un mensaje de error.
        print('Error al obtener datos de la tercera tabla: ${response.statusCode}');
        return null; // Devolvemos null en caso de error.
      }
    } catch (error) {
      // Manejar errores de excepción aquí.
      print('Error al obtener datos de la tercera tabla: $error');
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

  Future<void> _sendObservation(String observation) async {
    const String url = 'http://192.168.1.75/gam/detallevidacrearobservacion.php';

    try {
      final response = await http.get(
        Uri.parse('$url?id=${widget.id}&observacion=$observation'),
      );

      if (response.statusCode == 200) {
        // La observación se envió con éxito al servidor PHP.
        // Puedes mostrar un mensaje de éxito o realizar cualquier otra acción necesaria.
        print('Observación enviada con éxito');
      } else {
        // Manejar errores aquí, como mostrar un mensaje de error.
        print('Error al enviar la observación al servidor: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores de excepción aquí.
      print('Error al enviar la observación al servidor: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles de la Póliza de ${widget.nombreUsuario}',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                const Center(
                  child: Text(
                    'Información de la Póliza',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Folio GAM')),
                      DataColumn(label: Text('Línea de Negocio')),
                      DataColumn(label: Text('Fecha de Solicitud')),
                      DataColumn(label: Text('Estado')),
                      DataColumn(label: Text('Contratante')),
                      DataColumn(label: Text('Póliza')),
                      DataColumn(label: Text('Tipo de Solicitud')),
                      DataColumn(label: Text('Tipo de movimiento')),
                      DataColumn(label: Text('Prioridad')),
                      DataColumn(label: Text('Comentarios')),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text(data['id'] ?? '***')),
                        DataCell(Text(data['negocio'] ?? '***')),
                        DataCell(Text(data['fecha'] ?? '***')),
                        DataCell(Text(data['estado'] ?? '***')),
                        DataCell(Text(data['contratante'] ?? '***')),
                        DataCell(Text(data['polizap'] ?? '***')),
                        DataCell(Text(data['t_solicitud'] ?? '***')),
                        DataCell(Text(data['t_movimiento'] ?? '***')),
                        DataCell(Text(data['prioridad'] ?? '***')),
                        DataCell(Text(data['comentarios'] ?? '***')),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    'Documentos Relacionados',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>?>(
                  future: fetchDataForSecondTable(),
                  builder: (context, snapshot) {
                    if (isLoading) {
                      return const CircularProgressIndicator();
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No hay datos disponibles en la segunda tabla.');
                    } else if (snapshot.hasError) {
                      return Text('Error al cargar los datos de la segunda tabla: ${snapshot.error}');
                    } else {
                      final List<Map<String, dynamic>> secondTableData = snapshot.data!;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                                  IconButton(
                                    onPressed: () {
                                      // Lógica para abrir o ver el archivo aquí.
                                      // Puedes usar navegación o mostrar un visor de archivos, según tus necesidades.
                                    },
                                    icon: const Icon(Icons.search), // Cambia el icono aquí
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    onPressed: () {
                                      // Lógica para descargar el archivo aquí.
                                      // Puedes implementar la descarga del archivo en esta función.
                                    },
                                    icon: const Icon(Icons.file_download), // Cambia el icono aquí
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
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    'Subir Documentos',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
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
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    'Historial de Observaciones',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                FutureBuilder<List<Map<String, dynamic>>?>(
                  future: fetchDataForThirdTable(),
                  builder: (context, snapshot) {
                    if (isLoading) {
                      return const CircularProgressIndicator();
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No hay datos disponibles en el historial.');
                    } else if (snapshot.hasError) {
                      return Text('Error al cargar los datos del historial: ${snapshot.error}');
                    } else {
                      final List<Map<String, dynamic>> thirdTableData = snapshot.data!;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('Usuario')),
                            DataColumn(label: Text('Observaciones')),
                            DataColumn(label: Text('Estado')),
                            DataColumn(label: Text('Fecha')),
                          ],
                          rows: thirdTableData.map((data) {
                            return DataRow(
                              cells: [
                                /*
                                DataCell(
                                  // Aquí puedes mostrar una imagen si tienes una URL de imagen en tu data.
                                  // Puedes usar Image.network o Image.asset según tus necesidades.
                                  // Ejemplo:
                                  Image.network(
                                    data['imagen'] ?? '***',
                                    width: 50, // Ajusta el tamaño de la imagen
                                    height: 50,
                                  ),
                                ),
                                */
                                const DataCell(Text('')),
                                DataCell(Text(data['usuario'] ?? '***')),
                                DataCell(Text(data['comentario'] ?? '***')),
                                DataCell(Text(data['estado1'] ?? '***')),
                                DataCell(Text(data['fecha_comentario'] ?? '***')),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    'Agregar observación',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 20, // Espacio entre columnas
                    columns: const [
                      DataColumn(
                        label: Text('Observación'),
                        // Establece un ancho máximo para la columna de observación
                        // El valor puede ajustarse según tus necesidades
                        numeric: false, // Esto evita que la columna se ajuste automáticamente al contenido
                      ),
                      DataColumn(
                        label: Text(''),
                        // Establece un ancho máximo para la columna de Enviar
                        // El valor puede ajustarse según tus necesidades
                        numeric: false,
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 600, minWidth: 600,
                            ), // Ancho máximo de la celda
                            child: TextField(
                              controller: _observationController,
                            ), // Celda con un campo de texto para la observación
                          ),
                        ),// Celda con un checkbox para Aceptar
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              // Obtener el valor del campo de observación
                              String observation = _observationController.text;

                              // Llamar a la función para enviar la observación al servidor
                              _sendObservation(observation);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // Color de fondo del botón "Enviar"
                            ),
                            child: const Text('Enviar'),
                          ),

                        ),
                      ]),
                      // Agrega más filas según sea necesario
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Términos y Condiciones')),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(
                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 600, minWidth: 600,
                          ), // Ancho máximo de la celda
                          child: const Text('De acuerdo a la Circular 16 de GNP donde se solicita la documentación física en original sin tachaduras ni enmendaduras, en una sola tinta tal y como se emitió la póliza te solicitamos nos hagas llegar dicha documentación en un plazo máximo de 15 días.',style: TextStyle(fontFamily: 'Robot'),),
                        ),
                      ),
                      DataCell(
                        ElevatedButton(
                          onPressed: () {
                            // Lógica para aceptar los términos y condiciones aquí.
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue, // Color de fondo del botón "Aceptar"
                          ),
                          child: const Text('Aceptar'),
                        ),
                      ),
                    ]),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
