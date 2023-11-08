import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:appgam/Pages/MenuAsesores/Detalles/vidaDetallePage.dart';

class Vida extends StatefulWidget {
  final String nombreUsuario;
  const Vida({Key? key, required this.nombreUsuario}) : super(key: key);

  @override
  _VidaState createState() => _VidaState();
}

class _VidaState extends State<Vida> {
  List<Map<String, String>> datos = [];
  final int _perPage = 4;
  int _currentPage = 0;
  String filtroAplicado = '';
  Map<String, String> filterButtonText = {
    'ALTA DE POLIZA': 'ALTA DE POLIZA',
    'PAGOS': 'PAGOS',
    'MOVIMIENTOS': 'MOVIMIENTOS',
  };

  Set<String> activeFilters = Set<String>();
  String searchTerm = ''; // Nuevo campo para el término de búsqueda

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
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.142/gam/tablafoliosvida.php?username=${widget.nombreUsuario}'));
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
        });
      } else {
        _showErrorDialog('Hubo un problema al obtener los datos.');
      }
    } catch (e) {
      print('Error al obtener los datos: $e');
      _showErrorDialog('Hubo un problema al obtener los datos.');
    }
  }

  Future<void> fetchDataWithFilter(String? filterNames) async {
    if (filterNames != null) {
      final response = await http.get(Uri.parse(
          'http://192.168.1.142/gam/tablafoliosvida.php?filter=$filterNames&username=${widget.nombreUsuario}'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          datos = jsonResponse.map((dynamic item) {
            Map<String, String> mappedItem = {};
            for (var entry in item.entries) {
              // Asegúrate de que el valor sea convertido a String antes de asignarlo
              mappedItem[entry.key] = entry.value.toString();
            }
            return mappedItem;
          }).toList();
          filtroAplicado = filterButtonText[filterNames] ?? '';
        });
      } else {
        _showErrorDialog('Hubo un problema al obtener los datos.');
      }
    } else {
      // Manejar la lógica en caso de que filterNames sea nulo.
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
        filterButtonText[filterName] = buttonText;
      } else {
        activeFilters.add(filterName);
        filterButtonText[filterName] = isFilterActive(filterName) ? buttonText : 'Quitar';
      }

      // Actualiza el texto del filtro aplicado
      filtroAplicado = activeFilters.isNotEmpty ? 'Filtro Aplicado' : '';
    });

    if (activeFilters.isNotEmpty) {
      String filters = activeFilters.join(',');
      fetchDataWithFilter(filters);
    } else {
      fetchData();
    }
  }



  // Función para realizar la búsqueda
  void performSearch() {
    if (searchTerm.isNotEmpty) {
      setState(() {
        final filteredData = datos.where((item) {
          final searchString = searchTerm.toLowerCase();

          // Realizar la búsqueda en todos los campos de la fila
          for (var value in item.values) {
            final lowerValue = value.toLowerCase();
            if (lowerValue.contains(searchString)) {
              return true;
            }
          }

          // También verifica si el término de búsqueda es un número y si coincide con algún valor numérico en la fila
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
          // Mostrar alerta si no se encontraron resultados
          _showNoResultsAlert();
        } else {
          datos = filteredData;
        }
      });
    } else {
      // Si el término de búsqueda está vacío, muestra todos los datos nuevamente.
      fetchData();
    }
  }

  void _showNoResultsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sin Resultados', style: TextStyle(fontFamily: 'Roboto'),),
          content: const Text('No se encontraron resultados.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Recargar la tabla original
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
  }

  TableRow _buildTableHeaderRow() {
    return TableRow(
      children: [
        _buildTableHeaderCell(' Folio GAM'),
        _buildTableHeaderCell(' Nombre del Contratante '),
        _buildTableHeaderCell(' N° Póliza'),
        _buildTableHeaderCell(' Folio GNP'),
        _buildTableHeaderCell(' Fecha Promesa '),
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
        constraints: const BoxConstraints.expand(height: 50.0), // Establecer un alto específico para la celda
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 13.0,
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
    String nPolizaValue = datos['poliza'] ?? ''; // Usar el operador '!' para asegurarse de que 'datos['polizap']' no sea nulo
    Color textColorf = columna == 'fecha_promesa' ? const Color.fromRGBO(15, 132, 194, 1) : Colors.black;

    // Ajuste basado en el valor de 't_solicitud'
    if (datos['t_solicitud'] == 'PAGOS') {
      nPolizaValue = datos['polizap'] ?? '';  // Aquí debes proporcionar el nombre correcto del campo que contiene el valor para 'N Poliza' cuando 't_solicitud' es 'PAGOS'.
    }else if(datos['t_solicitud']=='ALTA DE POLIZA'){
      nPolizaValue=datos['polizap'] ?? '';
    }

    if(columna=='fecha_promesa'){
      if(datos['semaforo']=='verde'){
        textColor = Colors.green;
      } else if(datos['semaforo']=='rojo'){
        textColor=Colors.red;
      }else if(datos['semaforo']=='amarillo'){
        textColor=Colors.yellow;
      }
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

    List<Map<String, String>> currentPageData = filteredData.sublist(inicio, fin);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido ${widget.nombreUsuario}',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16),
                      Row(
                        children: filterButtonText.keys.map((filterName) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Ajusta el valor según sea necesario
                            child: ElevatedButton(
                              onPressed: () => toggleFiltro(filterName, filterButtonText[filterName]!),
                              style: ElevatedButton.styleFrom(
                                primary: isFilterActive(filterName) ? Colors.grey : Colors.blue,
                              ),
                              child: Text(
                                filterButtonText[filterName]!,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: (){
                          fetchDataWithFilter('A_TIEMPO');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightGreen,
                        ),
                        child: const Text(
                          'A TIEMPO',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: (){

                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(241, 201, 132, 1.0),
                        ),
                        child: const Text('POR VENCER',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: (){

                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red  ,
                        ),
                        child: const Text('VENCIDOS',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  filtroAplicado.isNotEmpty ? 'Filtro Aplicado: $filtroAplicado' : '',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0),
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
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Vida(nombreUsuario: ''),
  ));
}