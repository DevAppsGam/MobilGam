import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path; // Importa la biblioteca path y dale un alias, como "path"
import 'dart:io';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

class DetalleVida extends StatefulWidget {
  final String nombreUsuario;
  final String id;

  const DetalleVida({super.key, required this.nombreUsuario, required this.id});

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

  bool _isLoading = true; // Estado de carga inicial
  List<Map<String, dynamic>>? _secondTableData;
  List<Map<String, dynamic>>? _dataForThirdTable;

  @override
  void initState() {
    super.initState();
    fetchDataFromPHP();
    fetchDataForThirdTable();
  }

  Future<void> _loadData() async {
    try {
      // Simula una carga de datos
      await Future.delayed(const Duration(seconds: 5));
      // Aquí obtendrás tus datos de la API o de donde provengan
      setState(() {
        // Asignar datos a las variables
        _secondTableData = []; // Reemplaza con tus datos
        _dataForThirdTable = []; // Reemplaza con tus datos
        _isLoading = false; // Cambia el estado a no cargando
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Manejo de errores
    }
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

    final String url = 'https://www.asesoresgam.com.mx/sistemas1/gam/detallevida.php?id=${widget.id}';

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
        'https://www.asesoresgam.com.mx/sistemas1/gam/detallevidaobservaciones.php?id=${widget.id}';
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      // El usuario seleccionó un archivo, puedes manejarlo aquí.
      final filePath = result.files.single.path;
      final fileName = result.files.single.name;
      // Puedes usar filePath y fileName según tus necesidades.
      print('Archivo seleccionado: $fileName');
      setState(() {
        _selectedFileName = fileName; // Actualiza _selectedFileName con el nombre del archivo seleccionado
      });
    } else {
      // El usuario canceló la selección de archivos.
      print('Selección de archivos cancelada.');
    }
    fetchDataForThirdTable();
  }

  Future<void> _sendObservation(String observation) async {
    const String url = 'https://www.asesoresgam.com.mx/sistemas1/gam/detallevidacrearobservacion.php';

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
    final String secondTableUrl = 'https://asesoresgam.com.mx/sistemas1/gam/detallevidadocumentos.php?id=${widget.id}';
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


  Future<void> uploadDocument(String fileName, String id) async {
    // Escapa los caracteres especiales en el nombre del archivo, si es necesario
    final escapedFileName = Uri.encodeComponent(fileName);

    // Crea la URL con los parámetros en la forma adecuada
    final url = 'http://192.168.1.77/gam/detallevidasubirdoc.php?id=$id&archivo=$escapedFileName';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // La solicitud se realizó con éxito, puedes manejar la respuesta aquí si es necesario.
        print('Documento enviado con éxito');
        fetchDataForThirdTable();
      } else {
        // Maneja los errores de la solicitud aquí.
        print('Error al enviar el documento al servidor: ${response.statusCode}');
      }
    } catch (error) {
      // Maneja los errores de excepción aquí.
      print('Error al enviar el documento al servidor: $error');
    }
  }

  Future<void> uploadFile(String fileName, String id) async {
    final file = File(fileName); // Abre el archivo seleccionado
    const url = 'https://asesoresgam.com.mx/sistemas1/gam/uploaddocumentovida.php'; // URL del servicio de carga en el servidor

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(
        http.MultipartFile(
          'file', // Nombre del campo en el formulario
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: path.basename(file.path), // Nombre del archivo
        ),
      );
      request.fields['id'] = id; // Puedes enviar otros datos junto con el archivo, como el ID

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Documento enviado con éxito');
      } else {
        print('Error al enviar el archivo al servidor: ${response.statusCode}');
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print('Error al enviar el archivo al servidor: $e');
    } finally {
      //file.close(); // Cierra el archivo después de enviarlo
    }
  }

  Future<void> _mostrarDialogoCerrarFolio() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe tocar un botón para cerrar el cuadro de diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Términos y condiciones',style: TextStyle(fontFamily: 'Roboto',fontSize: 24),),
          content: const Text('De acuerdo a la Circular 16 de GNP donde se solicita la documentación física en original sin tachaduras ni enmendaduras, en una sola tinta tal y como se emitió la póliza te solicitamos nos hagas llegar dicha documentación en un plazo máximo de 15 días.', style: TextStyle(fontFamily: 'Roboto'),),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Realiza la acción de cierre aquí
                  Navigator.of(context).pop(); // Cierra el cuadro de diálogo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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

  Widget buildTableCell(String content, {bool isHeader = false, bool isTransparent = false}) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      constraints: BoxConstraints(
        minHeight: isHeader ? 40 : 80, // Ajusta según sea necesario
      ),
      decoration: BoxDecoration(
        color: isTransparent ? Colors.transparent : (isHeader ? Colors.blueAccent : Colors.white),
        border: isTransparent ? const Border() : Border.all(color: Colors.grey),
      ),
      child: isHeader
          ? Center(
        child: Text(
          content,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : Row(
        children: [
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double appBarTextSize = MediaQuery.textScalerOf(context).scale(16);
    final Paint? foreground;
    const String altaPoliza = 'ALTA DE POLIZA';
    const String PAGOS = 'PAGOS';
    const String MOVIMIENTOS = 'MOVIMIENTOS';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalles de la Solicitud de ${widget.nombreUsuario}',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: const Color.fromRGBO(246, 246, 246, 1),
            fontSize: appBarTextSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
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
                    'Información de la Solicitud de Vida',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(73, 78, 84, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                if(isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    buildTableRow([
                      'Folio GAM',
                      'Línea de Negocio',
                      'Fecha de Solicitud',
                      'Estado',
                    ], isHeader: true),
                    buildTableRow([
                      data['id'] ?? 'N/A',
                      data['negocio'] ?? 'N/A',
                      data['fecha'] ?? 'N/A',
                      data['estado'] ?? 'N/A',
                    ]),
                    buildTableRow([
                      'Contratante',
                      'Póliza',
                      'Tipo de Solicitud',
                      'Comentarios',
                    ], isHeader: true),
                    buildTableRow([
                      data['contratante'] ?? 'N/A',
                      data['t_solicitud'] == MOVIMIENTOS ? data['poliza'] ?? 'N/A' : data['polizap'] ?? 'N/A',
                      data['t_solicitud'] ?? 'N/A',
                      data['comentarios'] ?? 'N/A',
                    ]),
                    buildTableRow([
                      'Prioridad',
                      getCampoPrioridad(data),
                      getCampoFolio(data),
                      getCampoMoneda(data),
                    ], isHeader: true),
                    buildTableRow([
                      data['prioridad'] ?? 'N/A',
                      data['t_solicitud'] == altaPoliza ? data['prima'] ?? 'N/A' : data['t_solicitud'] == PAGOS ? data['monto'] ?? 'N/A' : data['movimiento'] ?? 'N/A',
                      data['t_solicitud'] == altaPoliza || data['t_solicitud'] == PAGOS ? data['fgnp'] ?? 'N/A' : '',
                      data['t_solicitud'] == altaPoliza || data['t_solicitud'] == PAGOS ? data['monedap'] ?? 'N/A' : '',
                    ]),
                    buildTableRow([
                      data['t_solicitud'] == MOVIMIENTOS ? '' : 'Producto',
                      data['t_solicitud'] == MOVIMIENTOS ? '' : 'Rango',
                      '',
                      '',
                    ], isHeader: true, headerIndices: [0, 1]),
                    buildTableRow([
                      data['t_solicitud'] == MOVIMIENTOS ? '' : data['producto'] ?? 'N/A',
                      data['t_solicitud'] == MOVIMIENTOS ? '' : data['rango'] ?? 'N/A',
                      '',
                      '',
                    ]),
                  ],
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Documentos Relacionados',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(73, 78, 84, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                            return const Text('No hay documentos en esta póliza.',style: TextStyle(fontFamily: 'Roboto',fontSize: 20,color: Color.fromRGBO(15, 132, 194, 1),),);
                          } else if (snapshot.hasError) {
                            return Text('Error al cargar los datos de la segunda tabla: ${snapshot.error}');
                          } else {
                            final List<Map<String, dynamic>> secondTableData = snapshot.data!;

                            return Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              border: TableBorder.all(),
                              children: [
                                const TableRow(
                                  decoration: BoxDecoration(color: Color.fromRGBO(15, 132, 194, 1)),
                                  children: [
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          'Usuario',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(9.5),
                                        child: Center(
                                          child: Text(
                                            'Nombre del Archivo',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          'Ver',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          'Descargar',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          'Aprobado',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Center(
                                        child: Text(
                                          'Fecha de Carga',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                for (var data in secondTableData)
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                            data['nomusuario'] ?? '***',
                                            style: const TextStyle(fontFamily: 'Roboto', fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(9.5),
                                          child: Center(
                                            child: Text(
                                              data['nombre'] ?? '***',
                                              style: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () {

                                            },
                                            icon: const Icon(Icons.search), // Cambia el icono aquí
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: IconButton(
                                            onPressed: () async {
                                              // Extrae el nombre del archivo eliminando el prefijo '../'
                                              String nombreSinPrefijo = data['nombre']?.replaceFirst('../', '') ?? '';

                                              // Construye la URL del archivo PDF
                                              String pdfUrl = "https://www.asesoresgam.com.mx/sistemas/$nombreSinPrefijo";

                                              try {
                                                // Utiliza la función downloadFile para descargar el archivo
                                                File? downloadedFile = await FileDownloader.downloadFile(
                                                  url: pdfUrl,
                                                  name: nombreSinPrefijo,
                                                  onProgress: (String? fileName, double progress) {
                                                    print('EL ARCHIVO $fileName TIENE UN PROGRESO DE $progress');
                                                  },
                                                  onDownloadCompleted: (String path) {
                                                    print('ARCHIVO DESCARGADO EN LA RUTA: $path');

                                                    // Abre el gestor de archivos después de la descarga
                                                    OpenFilex.open(path);
                                                  },
                                                  onDownloadError: (String error) {
                                                    print('ERROR DE DESCARGA: $error');
                                                  },
                                                );

                                                if (downloadedFile != null) {
                                                  // El archivo se ha descargado y puedes realizar otras acciones según tus necesidades
                                                }
                                              } catch (e) {
                                                print('ERROR DURANTE LA DESCARGA: $e');
                                              }
                                            },
                                            icon: const Icon(Icons.file_download),
                                          ),
                                        ),
                                      ),

                                      TableCell(
                                        child: Center(
                                          child: data['validado'] == true
                                              ? const Icon(
                                            Icons.check,
                                            color: Colors.green, // Color verde para el ícono de paloma
                                          )
                                              : const Icon(
                                            Icons.cancel,
                                            color: Colors.red, // Color rojo para el ícono de tache
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Center(
                                          child: Text(
                                            data['fecha_creacion'] ?? '***',
                                            style: const TextStyle(fontFamily: 'Roboto', fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
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
                      color: Color.fromRGBO(73, 78, 84, 1),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Archivo',style: TextStyle(fontFamily: 'Roboto',fontSize: 18,color: Color.fromRGBO(15, 132, 194, 1),),)),
                      DataColumn(label: Text('')),
                      DataColumn(label: SizedBox(width: 175, child: Text('Tipo de Documento',style: TextStyle(fontFamily: 'Roboto',fontSize: 18,color: Color.fromRGBO(15, 132, 194, 1),),))),
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                height: 250,
                                child: _selectedFileName != null ? Text(_selectedFileName!) : const Text('Ningún archivo seleccionado',style: TextStyle(fontFamily: 'Roboto',fontSize: 14),),
                              ),
                            ),

                            DataCell(ElevatedButton(
                              onPressed: () {
                                _pickDocument();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
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
                                      child: Text('Seleccionar',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Solicitud',
                                      child: Text('Solicitud',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Identificacion',
                                      child: Text('Identificación',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Comprobante_domicilio',
                                      child: Text('Comprobante de Domicilio',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Cartas_Extraprima',
                                      child: Text('Cartas de Extraprima',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Cartas_Rechazo',
                                      child: Text('Cartas de Rechazo',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Cartas_Adicionales',
                                      child: Text('Cartas Adicionales',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Cuestionario_Adicional_Suscripción',
                                      child: Text('Cuestionario Adicional de Suscripción',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Formato_Cobranza_Electrónica',
                                      child: Text('Formato de Cobranza Electrónica',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Hoja_H107',
                                      child: Text('Hoja H107',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Solicitudes_Adicionales',
                                      child: Text('Solicitudes Adicionales',style: TextStyle(fontFamily: 'Roboto',fontSize: 16),),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOption = value;
                                      // Actualizar el nombre del archivo según el tipo de documento
                                      if (value != 'Seleccionar') {
                                        _selectedFileName = '$value${widget.id}.pdf';
                                      } else {
                                        _selectedFileName = null; // No se seleccionó un tipo de documento
                                      }
                                    });
                                  },
                                  value: _selectedOption ?? 'Seleccionar',
                                ),
                              ),
                            ),
                            DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    if (_selectedFileName != null && _selectedOption != null) {
                                      // Realiza la acción de carga y procesamiento aquí
                                      print('Archivo seleccionado: $_selectedFileName');
                                      print('Opción seleccionada: $_selectedOption');

                                      // Llama a la función para cargar el documento al servidor PHP.
                                      final fileName = _selectedFileName ?? ''; // Valor por defecto si _selectedFileName es nulo
                                      uploadDocument(fileName, widget.id);
                                    } else {
                                      // Muestra un mensaje de error si no se seleccionó un archivo o una opción
                                      print('Por favor, selecciona un archivo y una opción antes de confirmar.');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightGreen,
                                  ),
                                  child: const Text('Confirmar'),
                                )

                            ),
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
                                backgroundColor: Colors.redAccent,
                              ),
                              child: const Text('Cancelar'),
                            )),
                          ]),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    'Historial de Observaciones',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(73, 78, 84, 1),
                    ),
                  ),
                ),
                if (isLoading)
                  const CircularProgressIndicator()
                else if (dataForThirdTable?.isEmpty ?? true)
                  const Text('No hay datos disponibles en el historial.')
                else
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(),
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: Color.fromRGBO(15, 132, 194, 1)),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(9.5),
                              child: Center(
                                child: Text('Usuario',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),),
                              ),
                            ),

                          ),
                          TableCell(
                            child: Center(
                              child: Text('Observaciones',style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text('Estado',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),),
                            ),
                          ),
                          TableCell(
                            child: Center(
                              child: Text('Fecha',style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                          ),
                        ],
                      ),
                      for (var data in dataForThirdTable!)
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                child: Text(data['usuario'] ?? '***',
                                style: const TextStyle(
                                  fontFamily: 'roboto',
                                  fontSize: 17,
                                ),),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(9.5),
                                child: Center(
                                  child: Text(data['comentario'] ?? '***',
                                    style: const TextStyle(
                                      fontFamily: 'roboto',
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(data['estado1'] ?? '***',
                                  style: const TextStyle(
                                    fontFamily: 'roboto',
                                    fontSize: 18,
                                  ),),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(data['fecha_comentario'] ?? '***',
                                  style: const TextStyle(
                                    fontFamily: 'roboto',
                                    fontSize: 18,
                                  ),),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    'Agregar observación',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(73, 78, 84, 1),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 20,
                    columns: const [
                      DataColumn(
                        label: Text('Observación',style: TextStyle(fontFamily: 'Roboto',fontSize: 24),),
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
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text('Enviar',style: TextStyle(fontFamily: 'Roboto',fontSize: 20),),
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
                      backgroundColor: Colors.green,
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

  TableRow buildTableRow(
      List<String> cells, {
        bool isHeader = false,
        List<int>? headerIndices,
      }) {
    return TableRow(
      children: List.generate(cells.length, (index) {
        // Verifica si el índice actual está en headerIndices o si headerIndices es null
        bool applyHeaderStyle = isHeader && (headerIndices == null || headerIndices.contains(index));
        String cellContent = cells[index];

        // Aquí puedes imprimir para depurar
        print('Célula: $cellContent, Estilo de encabezado: $applyHeaderStyle');

        // Verifica si la celda está vacía
        if (cellContent.isEmpty) {
          // Devuelve una celda vacía con estilo transparente
          return buildTableCell('', isHeader: false, isTransparent: true); // Asegúrate de que buildTableCell maneje el nuevo parámetro
        } else {
          // Devuelve la celda construida normalmente
          return buildTableCell(cellContent, isHeader: applyHeaderStyle);
        }
      }),
    );
  }



}

String getCampoPrioridad(Map<String, dynamic> data) {
  if (data['t_solicitud'] == 'ALTA_POLIZA') return 'Prima';
  if (data['t_solicitud'] == 'PAGOS') return 'Monto';
  return 'Tipo de Movimiento';
}

String getCampoFolio(Map<String, dynamic> data) {
  return (data['t_solicitud'] == 'ALTA_POLIZA' || data['t_solicitud'] == 'PAGOS')
      ? 'Folio GNP'
      : '';
}

String getCampoMoneda(Map<String, dynamic> data) {
  return (data['t_solicitud'] == 'ALTA_POLIZA' || data['t_solicitud'] == 'PAGOS')
      ? 'Moneda'
      : '';
}
