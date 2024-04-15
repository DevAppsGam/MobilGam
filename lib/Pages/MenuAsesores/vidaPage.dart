import 'dart:convert';
import 'package:appgam/main.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:appgam/Pages/MenuAsesores/Detalles/vidaDetallePage.dart';
import 'dart:async';

class Vida extends StatefulWidget {
  final String nombreUsuario;

  const Vida({super.key, required this.nombreUsuario});

  @override
  _VidaState createState() => _VidaState();
}

class _VidaState extends State<Vida> {
  late Timer _inactivityTimer;

  List<Map<String, String>> datos = [];
  final int _perPage = 4;
  int _currentPage = 0;
  String filtroAplicado = '';
  Map<String, String> filterButtonText = {
    'ALTA DE POLIZA': 'ALTA DE POLIZA',
    'PAGOS': 'PAGOS',
    'MOVIMIENTOS': 'MOVIMIENTOS',
  };

  Set<String> activeFilters = <String>{};
  String searchTerm = '';

  String filtroAplicadoSemaforo = '';


  bool isFilterActive(String filterName) {
    return activeFilters.contains(filterName);
  }

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
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliosvida.php?username=${widget.nombreUsuario}'));
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


  Future<void> fetchDataWithFilter(String? filterNames) async {
    if (filterNames != null) {
      String combinedFilters = filterNames;

      // Si hay filtros activos, se combinan con el filtro actual
      if (activeFilters.isNotEmpty) {
        combinedFilters += ',' + activeFilters.join(',');
      }

      final response = await http.get(Uri.parse(
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliosvida.php?filter=$combinedFilters&username=${widget
              .nombreUsuario}'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          datos = jsonResponse.map((dynamic item) {
            Map<String, String> mappedItem = {};
            for (var entry in item.entries) {
              mappedItem[entry.key] = entry.value.toString();
            }
            return mappedItem;
          }).toList();
          filtroAplicado = filterButtonText[filterNames] ?? '';
        });
      } else {
        _showErrorDialog(
            'Hubo un problema al obtener los datos.Código de estado: ${response
                .statusCode}');
      }
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

  void toggleFiltro(String filterName, String buttonText) {
    setState(() {
      if (isFilterActive(filterName)) {
        activeFilters.remove(filterName);
      } else {
        activeFilters.clear();
        activeFilters.add(filterName);
      }
      filtroAplicado = activeFilters.isNotEmpty ? 'Filtros Aplicados: ${activeFilters.join(', ')}' : '';
    });

    if (['ALTA DE POLIZA', 'PAGOS', 'MOVIMIENTOS'].contains(filterName)) {
      fetchDataWithFilter(filterName);
    } else {
      applySecondFilter(filterName);
    }
  }

  void applySecondFilter(String filterName) {
    // Obtener el primer filtro activo
    String primaryFilter = activeFilters.first;

    // Aplicar el segundo filtro a la información filtrada por el primer filtro
    String combinedFilters = '$primaryFilter,$filterName';
    fetchDataWithFilter(combinedFilters);
  }


  void applyFilters() {
    // Construir el parámetro de filtros para la URL
    String filters = activeFilters.join(',');

    // Llamar a la función fetchDataWithFilter con los filtros aplicados
    fetchDataWithFilter(filters);
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

  Future<void> fetchDataWithGreenSemaforo() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliosvida.php?filter=A_TIEMPO&username=${widget.nombreUsuario}'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          datos = jsonResponse.map((dynamic item) {
            Map<String, String> mappedItem = {};
            for (var entry in item.entries) {
              mappedItem[entry.key] = entry.value.toString();
            }
            return mappedItem;
          }).toList();
          filtroAplicado = 'A TIEMPO';
        });
      } else {
        _showErrorDialog(
            'Hubo un problema al obtener los datos.Código de estado: ${response
                .statusCode}');
      }
    } catch (e) {
      print('Error al decodificar JSON: $e');
      _showErrorDialog('Hubo un problema al decodificar los datos JSON.');
    }
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
    const inactivityDuration = Duration(seconds: 420); // se maneja en segundos 5min=300seg de inactividad
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
        _buildTableHeaderCell(' Contratante '),
        _buildTableHeaderCell(' N° Póliza'),
        _buildTableHeaderCell(' Folio GNP'),
        _buildTableHeaderCell(' Fecha Promesa '),
        _buildTableHeaderCell(' Estatus Trámite'),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return TableCell(
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(15, 132, 194, 1),
        ),
        constraints: const BoxConstraints.expand(height: 70.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
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
              textAlign: TextAlign.center,
              maxLines: 1, // Ajusta el número máximo de líneas permitidas
              overflow: TextOverflow.ellipsis, // Añade puntos suspensivos al final si el texto se corta
              minFontSize: 10, // Tamaño mínimo del texto
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
        _buildTableCell(datos['contratante'] ?? '', datos, 'contratante'),
        _buildTableCell(datos['poliza'] ?? '', datos, 'poliza'),
        _buildTableCell(datos['fgnp'] ?? '', datos, 'fgnp'),
        _buildTableCell(datos['fecha_promesa'] ?? '', datos, 'fecha_promesa'),
        _buildTableCell(datos['estado'] ?? '', datos, 'estado'),
      ],
    );
  }

  Widget _buildTableCell(String text, Map<String, String> datos, String columna) {
    Color textColor = columna == 'id' ? const Color.fromRGBO(15, 132, 194, 1) : Colors.black;
    String nPolizaValue = datos['poliza'] ?? '';
    Color textColorf = columna == 'fecha_promesa' ? const Color.fromRGBO(15, 132, 194, 1) : Colors.black;

    if (datos['t_solicitud'] == 'PAGOS') {
      nPolizaValue = datos['polizap'] ?? '';
    } else if (datos['t_solicitud'] == 'ALTA DE POLIZA') {
      nPolizaValue = datos['polizap'] ?? '';
    }
    if (columna == 'fecha_promesa') {
      if (datos['semaforo'] == 'verde') {
        textColor = Colors.green;
      } else if (datos['semaforo'] == 'rojo') {
        textColor = Colors.red;
      } else if (datos['semaforo'] == 'amarillo') {
        textColor = Colors.yellow;
      }
    }
    int maxLines = 1; // Número máximo de líneas predeterminado
    // Ajustar el número máximo de líneas para cada columna según tus requisitos
    if (columna == 'contratante') {
      maxLines = 4;
    }
    return TableCell(
      child: GestureDetector(
        onTap: () {
          if (columna == 'id') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalleVida(
                  nombreUsuario: widget.nombreUsuario,
                  id: text,
                ),
              ),
            );
          } else {
            print('Columna no es "id" o el texto es nulo: columna=$columna, text=$text');
          }
        },

        child: Container(
          constraints: const BoxConstraints(minHeight: 70.0), // Establece el alto mínimo de la celda
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 13.0),
          child: Center(
              child: AutoSizeText(
                columna == 'poliza' ? nPolizaValue : text,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: maxLines, // Ajusta el número máximo de líneas permitidas
                overflow: TextOverflow.ellipsis, // Añade puntos suspensivos al final si el texto se corta
                minFontSize: 10, // Tamaño mínimo del texto
                stepGranularity: 1, // Granularidad del tamaño del texto
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
                          'Mis Trámites de Vida',
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
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 11.0, // Espacio entre los botones
                    children: [
                      ...filterButtonText.keys.map((filterName) {
                        return ElevatedButton(
                          onPressed: () => toggleFiltro(filterName, filterButtonText[filterName]!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFilterActive(filterName) ? Colors.grey : Colors.blue,
                          ),
                          child: Text(
                            filterButtonText[filterName]!,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }).toList(),
                      ElevatedButton(
                        onPressed: () {
                          fetchDataWithGreenSemaforo();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                        ),
                        child: const Text(
                          'A TIEMPO',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para el botón "POR VENCER"
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(241, 201, 132, 1.0),
                        ),
                        child: const Text(
                          'POR VENCER',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para el botón "VENCIDOS"
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'VENCIDOS',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    filtroAplicado.isNotEmpty
                        ? 'Filtro Aplicado: $filtroAplicado'
                        : '',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
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
                ),Align(
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
    home: Vida(nombreUsuario: ''),
  ));
}