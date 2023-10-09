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

  List<Map<String, dynamic>>? dataForThirdTable;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchDataFromPHP();
    fetchDataForThirdTable();
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
    final status = await Permission.storage.request();

    if (status.isGranted) {
      // Acceso concedido, puedes abrir el selector de archivos aquí.
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Manejar el archivo seleccionado aquí.
        final filePath = result.files.single.path;
        final fileName = result.files.single.name;
        // Puedes usar filePath y fileName según tus necesidades.
        print('Archivo seleccionado: $fileName');
      } else {
        // El usuario canceló la selección de archivos.
      }
    } else if (status.isDenied) {
      // El usuario denegó el permiso, puedes mostrar un mensaje de error o pedirlo nuevamente.
      print('Permiso de almacenamiento externo denegado.');
    } else if (status.isPermanentlyDenied) {
      // El usuario denegó permanentemente el permiso, puedes mostrar un mensaje y dirigir al usuario a la configuración de la aplicación.
      print('Permiso de almacenamiento externo denegado permanentemente.');
      openAppSettings(); // Abre la configuración de la aplicación.
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
                else if (!dataForThirdTable!.isEmpty)
                  const Text('No hay datos disponibles en la segunda tabla.')
                else if (dataForThirdTable != null && dataForThirdTable!.isEmpty)
                    Text('Error al cargar los datos de la segunda tabla: $errorMessage')
                  else
                    SingleChildScrollView(
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
                        rows: dataForThirdTable!.map((data) {
                          return DataRow(
                            cells: [
                              DataCell(Text(data['nomusuario'] ?? '***')),
                              DataCell(Text(data['nombre'] ?? '***')),
                              DataCell(
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.file_download),
                                ),
                              ),
                              DataCell(
                                data['validado'] == true
                                    ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                                    : const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              DataCell(Text(data['fecha_creacion'] ?? '***')),
                            ],
                          );
                        }).toList(),
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
                    DataColumn(label: Text('Subir Archivo')),
                    DataColumn(label: Text('Opción')),
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(ElevatedButton(
                        onPressed: () {
                          _pickDocument();
                        },
                        child: const Text('Seleccionar Archivo'),
                      )),
                      DataCell(DropdownButton<String>(
                        items: List.generate(10, (index) {
                          return DropdownMenuItem<String>(
                            value: 'Opción ${index + 1}',
                            child: Text('Opción ${index + 1}'),
                          );
                        }),
                        onChanged: (value) {},
                        value: null,
                      )),
                      DataCell(ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                        ),
                        child: const Text('Confirmar'),
                      )),
                      DataCell(ElevatedButton(
                        onPressed: () {},
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
                        DataColumn(label: Text('')),
                        DataColumn(label: Text('Usuario')),
                        DataColumn(label: Text('Observaciones')),
                        DataColumn(label: Text('Estado')),
                        DataColumn(label: Text('Fecha')),
                      ],
                      rows: dataForThirdTable!.map((data) {
                        return DataRow(
                          cells: [
                            const DataCell(Text('')),
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
