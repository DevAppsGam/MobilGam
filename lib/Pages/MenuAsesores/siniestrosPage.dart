import 'dart:convert';
import 'package:appgam/Pages/MenuAsesores/Detalles/siniestroDetallePage.dart';
import 'package:appgam/main.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Siniestro extends StatefulWidget {
  final String nombreUsuario;

  const Siniestro({super.key, required this.nombreUsuario});

  @override
  _SiniestroState createState() => _SiniestroState();
}

class _SiniestroState extends State<Siniestro> {
  late Timer _inactivityTimer;

  List<Map<String, String>> datos = [];
  final int _perPage = 4;
  int _currentPage = 0;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    fetchData();
    _startInactivityTimer();
  }


  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliossiniestros.php?username=${widget.nombreUsuario}'));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          print(jsonResponse); // Imprime el JSON para inspección
          List<dynamic> data = jsonResponse;
          setState(() {
            datos = data.map((dynamic item) {
              Map<String, String> mappedItem = {};
              item.forEach((key, value) {
                // Manejar campos numéricos vacíos
                if (value is num || (value is String && value.isNotEmpty)) {
                  // Convertir a cadena si es necesario
                  mappedItem[key] = value.toString();
                } else {
                  // Mantener como está
                  mappedItem[key] = value;
                }
              });
              return mappedItem;
            }).toList();
          });
        } else {
          print('Error al con json.decode');
        }
      } else {
        _showErrorDialog('Hubo un problema al obtener los datos.');
      }
    } catch (e) {
      print('Error al decodificar JSON: $e');
      _showErrorDialog('Hubo un problema al decodificar los datos JSON.');
    }
  }



  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void performSearch() {
    if (searchTerm.isNotEmpty) {
      setState(() {
        final filteredData = datos.where((item) {
          final searchString = searchTerm.toLowerCase();
          for (var value in item.values) {
            final lowerValue = value.toLowerCase();
            if (lowerValue.contains(searchString)) {
              return true;
            }
          }
          if (double.tryParse(searchTerm) != null) {
            for (var value in item.values) {
              if (double.tryParse(value) == double.tryParse(searchTerm)) {
                return true;
              }
            }
          }
          return false;
        }).toList();
        if (filteredData.isEmpty) {
          _showNoResultsAlert();
        } else {
          datos = filteredData;
        }
      });
    } else {
      fetchData();
    }
  }

  void _showNoResultsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Sin Resultados', style: TextStyle(fontFamily: 'Roboto'),),
          content: const Text('No se encontraron resultados.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                fetchData();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
    _inactivityTimer.cancel();
  }

  void _startInactivityTimer() {
    const inactivityDuration = Duration(seconds: 300); // 30 segundos de inactividad
    _inactivityTimer = Timer(inactivityDuration, () {
      // Maneja la inactividad (por ejemplo, cierra la sesión)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
            (Route<dynamic> route) => false,
      );
    });
  }

  void _resetInactivityTimer() {
    // Reinicia el temporizador al detectar actividad
    _inactivityTimer.cancel();
    _startInactivityTimer();
  }

  TableRow _buildTableHeaderRow() {
    return TableRow(
      children: [
        _buildTableHeaderCell(' Folio GAM'),
        _buildTableHeaderCell(' RAMO '),
        _buildTableHeaderCell(' Contratante'),
        _buildTableHeaderCell(' Nombre del Afectado'),
        _buildTableHeaderCell(' N Póliza'),
        _buildTableHeaderCell(' Fecha solicitud'),
        _buildTableHeaderCell(' Estatus Trámite'),
      ],
    );
  }

  TableCell _buildTableHeaderCell(String text) {

    return TableCell(
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(15, 132, 194, 1),
        ),
        constraints: const BoxConstraints.expand(height: 70.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 13.0,
          ),
          child: Center(
            child: AutoSizeText(
              text,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.justify,
              maxLines: 2, // Ajusta el número máximo de líneas permitidas
              overflow: TextOverflow.ellipsis, // Añade puntos suspensivos al final si el texto se corta
              minFontSize: 9, // Tamaño mínimo del texto
              stepGranularity: 1, // Granularidad del tamaño del texto
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(Map<String, String> datos) {
    return TableRow(
      children: [
        _buildTableCell(datos['id'] ?? '', datos, 'id'),
        _buildTableCell(datos['linea_s'] ?? '', datos, 'linea_s'),
        _buildTableCell(datos['contratante'] ?? '', datos, 'contratante'),
        _buildTableCell(datos['afectado'] ?? '', datos, 'afectado'),
        _buildTableCell(datos['n_poliza'] ?? '', datos, 'n_poliza'),
        _buildTableCell(datos['fecha'] ?? '', datos, 'fecha'),
        _buildTableCell(datos['estado'] ?? '', datos, 'estado'),
      ],
    );
  }

  Widget _buildTableCell(String text, Map<String, String> datos,
      String columna) {
    Color textColor = columna == 'id'
        ? const Color.fromRGBO(15, 132, 194, 1)
        : Colors.black;
    String nPolizaValue = datos['n_poliza'] ?? '';

    return TableCell(
      child: GestureDetector(
        onTap: () {
          if (columna == 'id') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetalleSiniestro(
                      nombreUsuario: widget.nombreUsuario,
                      id: text,
                    ),
              ),
            );
          } else {
            print(
                'Columna no es "id" o el texto es nulo: columna=$columna, text=$text');
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 13.0,
          ),
          child: Center(
            child: Text(
              columna == 'poliza' ? nPolizaValue : text,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> allData = List.from(datos);
    List<Map<String, String>> filteredData = List.from(datos);

    int totalElementos = filteredData.length;
    int totalPaginas = (totalElementos + _perPage - 1) ~/ _perPage;

    if (totalPaginas > 0) {
      _currentPage = _currentPage.clamp(0, totalPaginas - 1);
    } else {
      _currentPage = 0;
    }

    int inicio = _currentPage * _perPage;
    int fin = (inicio + _perPage).clamp(0, totalElementos);

    if (fin > totalElementos) {
      fin = totalElementos;
    }

    List<Map<String, String>> currentPageData = filteredData.sublist(
        inicio, fin);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
          title: Text(
            'Bienvenido ${widget.nombreUsuario}',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 17,
              color: Color.fromRGBO(246, 246, 246, 1),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Center(
                        child: Text(
                          'Mis Trámites de Siniestros',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(73, 78, 84, 1),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Búsqueda'),
                                content: SingleChildScrollView(
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        searchTerm = value;
                                      });
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      performSearch();
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(
                      color: const Color.fromRGBO(91, 112, 124, .5),
                      width: 2.0,
                    ),
                    children: [
                      _buildTableHeaderRow(),
                      for (var dato in currentPageData) _buildTableRow(dato),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Página ${_currentPage + 1} de $totalPaginas',
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_currentPage > 0) {
                            _currentPage--;
                          }
                        });
                      },
                      child: const Text(
                        'Anterior',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if ((_currentPage + 1) * _perPage < datos.length) {
                            _currentPage++;
                          }
                        });
                      },
                      child: const Text(
                        'Siguiente',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
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
        )
    )
    ;
  }
}

void main() {
  runApp(const MaterialApp(
    home: Siniestro(nombreUsuario: ''),
  ));
}