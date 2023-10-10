import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
  String? _selectedFileName;
  String? _selectedOption;


  List<Map<String, dynamic>>? dataForFirstTable;
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>>? dataForThirdTable;

  @override
  void initState() {
    super.initState();
    fetchDataFromPHP();
    fetchDataForThirdTable();
  }

  DataColumn createDataColumnForFirstTable(String label, List<Map<String, dynamic>> data) {
    bool shouldShowColumn = !data.any((row) => row[label] == '***');

    if (shouldShowColumn) {
      return DataColumn(label: Text(label));
    } else {
      return const DataColumn(label: SizedBox.shrink());
    }
  }


  Future<void> fetchDataFromPHP() async {
    if (!mounted) return;

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

  Future<void> fetchDataForThirdTable() async {
    final String thirdTableUrl =
        'http://192.168.1.75/gam/detallevidaobservaciones.php?id=${widget.id}';
    try {
      final response = await http.get(Uri.parse(thirdTableUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isNotEmpty) {
          setState(() {
            dataForThirdTable = jsonData.cast<Map<String, dynamic>>();
          });
        } else {
          setState(() {
            dataForThirdTable = [];
          });
        }
      } else {
        print('Error al obtener datos de la tercera tabla: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al obtener datos de la tercera tabla: $error');
    }
  }


  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // El usuario seleccionó un archivo, puedes manejarlo aquí.
      final filePath = result.files.single.path;
      final fileName = result.files.single.name;
      // Puedes usar filePath y fileName según tus necesidades.
      print('Archivo seleccionado: $fileName');
      setState(() {
        _selectedFileName = fileName;
      });
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
        print('Observación enviada con éxito');
        _observationController.clear();
        fetchDataForThirdTable();

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      } else {
        print('Error al enviar la observación al servidor: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al enviar la observación al servidor: $error');
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

  Future<void> _mostrarDialogoCerrarFolio() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe tocar un botón para cerrar el cuadro de diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Términos y condiciones',style: TextStyle(fontFamily: 'Roboto',fontSize: 28),),
          content: const Text('De acuerdo a la Circular 16 de GNP donde se solicita la documentación física en original sin tachaduras ni enmendaduras, en una sola tinta tal y como se emitió la póliza te solicitamos nos hagas llegar dicha documentación en un plazo máximo de 15 días.', style: TextStyle(fontFamily: 'Roboto'),),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Realiza la acción de cierre aquí
                  Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: const Text('Acepto', style: TextStyle(fontFamily: 'Roboto', fontSize: 24),),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                },
                child: const Text('Cancelar', style: TextStyle(fontFamily: 'Roboto', fontSize: 24, color: Colors.red),),
              ),
            ),
          ],
        );
      },
    );
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
          controller: _scrollController,
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
                if (isLoading)
                  const CircularProgressIndicator()
                  else
                    SingleChildScrollView(
                      child: FutureBuilder<List<Map<String, dynamic>>?>(
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
                    DataColumn(label: Text('Archivo')),
                    DataColumn(label: Text('')),
                    DataColumn(label: SizedBox(width: 175, child: Text('Tipo de Documento'))),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(_selectedFileName != null ? Text(_selectedFileName!) : const Text('Ningún archivo seleccionado')),
                      DataCell(ElevatedButton(
                        onPressed: () {
                          _pickDocument();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                        ),
                        child: const Text('Seleccionar Archivo'),
                      )),
                      DataCell(
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DropdownButton<String>(
                            items: const [
                              DropdownMenuItem<String>(
                                value: 'Seleccionar', // Valor para la opción predeterminada
                                child: Text('Seleccionar'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Solicitud',
                                child: Text('Solicitud'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Identificación',
                                child: Text('Identificación'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Comprobante de domicilio',
                                child: Text('Comprobante de domicilio'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Cartas de Extraprima',
                                child: Text('Cartas de Extraprima'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Cartas de Rechazo',
                                child: Text('Cartas de Rechazo'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Cartas Adicionales',
                                child: Text('Cartas Adicionales'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Cuestionario Adicional de Suscripción',
                                child: Text('Cuestionario Adicional de Suscripción'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Formato de Cobranza Electrónica',
                                child: Text('Formato de Cobranza Electrónica'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Hoja H107',
                                child: Text('Hoja H107'),
                              ),
                              DropdownMenuItem<String>(
                                value: 'Solicitudes Adicionales',
                                child: Text('Solicitudes Adicionales'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value;
                              });
                            },
                            value: _selectedOption ?? 'Seleccionar',
                          ),
                        ),
                      ),
                      DataCell(ElevatedButton(
                        onPressed: () {
                          if (_selectedFileName != null && _selectedOption != null) {
                            // Realiza la acción de carga y procesamiento aquí
                            print('Archivo seleccionado: $_selectedFileName');
                            print('Opción seleccionada: $_selectedOption');
                            // Puedes agregar código para cargar el archivo y procesarlo aquí
                          } else {
                            // Muestra un mensaje de error si no se seleccionó un archivo o una opción
                            print('Por favor, selecciona un archivo y una opción antes de confirmar.');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                        ),
                        child: const Text('Confirmar'),
                      )),
                      DataCell(ElevatedButton(
                        onPressed: () {
                          // Aquí puedes realizar acciones para cancelar la operación, si es necesario
                          // También puedes limpiar el estado aquí si es necesario
                          setState(() {
                            _selectedFileName = null;
                            _selectedOption = null;
                          });
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
                if (isLoading)
                  const CircularProgressIndicator()
                else if (dataForThirdTable!.isEmpty)
                  const Text('No hay datos disponibles en el historial.')
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Usuario')),
                        DataColumn(label: Text('Observaciones')),
                        DataColumn(label: Text('Estado')),
                        DataColumn(label: Text('Fecha')),
                      ],
                      rows: dataForThirdTable!.map((data) {
                        return DataRow(
                          cells: [
                            DataCell(Text(data['usuario'] ?? '***')),
                            DataCell(Text(data['comentario'] ?? '***')),
                            DataCell(Text(data['estado1'] ?? '***')),
                            DataCell(Text(data['fecha_comentario'] ?? '***')),
                          ],
                        );
                      }).toList(),
                    ),
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
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(
                        label: Text('Observación'),
                        numeric: false,
                      ),
                      DataColumn(
                        label: Text(''),
                        numeric: false,
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(
                          Container(
                            constraints: const BoxConstraints(
                              maxWidth: 600,
                              minWidth: 600,
                            ),
                            child: TextField(
                              controller: _observationController,
                            ),
                          ),
                        ),
                        DataCell(
                          ElevatedButton(
                            onPressed: () {
                              String observation = _observationController.text;
                              _sendObservation(observation);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                            ),
                            child: const Text('Enviar'),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 32,),
                const Center(
                  child: Text(
                    'Finalizar folio',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        _mostrarDialogoCerrarFolio();
                      },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                      child: const Text('¿Deseas cerrar el folio?',style: TextStyle(fontFamily: 'Roboto', fontSize: 30),),
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
