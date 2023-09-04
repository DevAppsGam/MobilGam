import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Vida extends StatefulWidget {
  const Vida({Key? key}) : super(key: key);

  @override
  _VidaState createState() => _VidaState();
}

class _VidaState extends State<Vida> {
  List<Map<String, String>> datos = [];
  final int _perPage = 4;
  int _currentPage = 0;
  String filtroAplicado = '';

  bool altaDePolizaFilter = false;
  bool pagosFilter = false;
  bool movimientosFilter = false;
  bool aTiempoFilter = false;
  bool porVencerFilter = false;
  bool vencidosFilter = false;

  String altaDePolizaButtonText = 'ALTA DE POLIZA';
  String pagosButtonText = 'PAGOS';
  String movimientosButtonText = 'MOVIMIENTOS';
  String aTiempoButtonText = 'A TIEMPO';
  String porVencerButtonText = 'POR VENCER';
  String vencidosButtonText = 'VENCIDOS';

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
    final response =
    await http.get(Uri.parse('http://192.168.1.89/gam/tablafoliosvida.php'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        datos = jsonResponse.map((dynamic item) {
          Map<String, String> mappedItem = {};
          for (var entry in item.entries) {
            mappedItem[entry.key] = entry.value ?? '';
          }
          return mappedItem;
        }).toList();
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Hubo un problema al obtener los datos.'),
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
  }

  Future<void> fetchDataWithFilter(String filterName) async {
    final response = await http.get(
      Uri.parse('http://192.168.1.89/gam/tablafoliosvida.php?filter=$filterName'),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        datos = jsonResponse.map((dynamic item) {
          Map<String, String> mappedItem = {};
          for (var entry in item.entries) {
            mappedItem[entry.key] = entry.value ?? '';
          }
          return mappedItem;
        }).toList();
        filtroAplicado = filterName;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Hubo un problema al obtener los datos.'),
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
  }

  void toggleFiltro(String filterName, String buttonText) {
    setState(() {
      switch (filterName) {
        case 'alta_de_poliza':
          altaDePolizaFilter = !altaDePolizaFilter;
          altaDePolizaButtonText = altaDePolizaFilter ? 'QUITAR FILTRO' : 'ALTA DE POLIZA';
          break;
        case 'pagos':
          pagosFilter = !pagosFilter;
          pagosButtonText = pagosFilter ? 'QUITAR FILTRO' : 'PAGOS';
          break;
        case 'movimientos':
          movimientosFilter = !movimientosFilter;
          movimientosButtonText = movimientosFilter ? 'QUITAR FILTRO' : 'MOVIMIENTOS';
          break;
        case 'a_tiempo':
          aTiempoFilter = !aTiempoFilter;
          aTiempoButtonText = aTiempoFilter ? 'QUITAR FILTRO' : 'A TIEMPO';
          break;
        case 'por_vencer':
          porVencerFilter = !porVencerFilter;
          porVencerButtonText = porVencerFilter ? 'QUITAR FILTRO' : 'POR VENCER';
          break;
        case 'vencidos':
          vencidosFilter = !vencidosFilter;
          vencidosButtonText = vencidosFilter ? 'QUITAR FILTRO' : 'VENCIDOS';
          break;
      }
      filtroAplicado = altaDePolizaFilter || pagosFilter || movimientosFilter || aTiempoFilter || porVencerFilter || vencidosFilter
          ? 'Filtro Aplicado'
          : ''; // Actualiza el texto de filtro aplicado
    });
    if (filtroAplicado.isNotEmpty) {
      fetchDataWithFilter(filterName);
    } else {
      fetchData();
    }
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
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(Map<String, String> datos) {
    return TableRow(
      children: [
        _buildTableCell(datos['id'] ?? ''),
        _buildTableCell(datos['contratante'] ?? ''),
        _buildTableCell(datos['poliza'] ?? ''),
        _buildTableCell(datos['polizap'] ?? ''),
        _buildTableCell(datos['fecha'] ?? ''),
        _buildTableCell(datos['estado'] ?? ''),
      ],
    );
  }

  TableCell _buildTableCell(String text) {
    return TableCell(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalElementos = datos.length;
    int totalPaginas = (totalElementos + _perPage - 1) ~/ _perPage;

    _currentPage = _currentPage.clamp(0, totalPaginas - 1);

    int inicio = _currentPage * _perPage;
    int fin = inicio + _perPage;
    if (fin > totalElementos) {
      fin = totalElementos;
    }

    List<Map<String, String>> currentPageData = datos.sublist(inicio, fin);

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
        child: SingleChildScrollView(
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Búsqueda'),
                              content: const TextField(
                                // Lógica de búsqueda
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // Realizar búsqueda
                                    Navigator.pop(context);
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
                      ElevatedButton(
                        onPressed: () => toggleFiltro('alta_de_poliza', altaDePolizaButtonText),
                        style: ElevatedButton.styleFrom(
                          primary: altaDePolizaFilter ? Colors.grey : Colors.blue,
                        ),
                        child: Text(altaDePolizaButtonText),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => toggleFiltro('pagos', pagosButtonText),
                        style: ElevatedButton.styleFrom(
                          primary: pagosFilter ? Colors.grey : Colors.blue,
                        ),
                        child: Text(pagosButtonText),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => toggleFiltro('movimientos', movimientosButtonText),
                        style: ElevatedButton.styleFrom(
                          primary: movimientosFilter ? Colors.grey : Colors.blue,
                        ),
                        child: Text(movimientosButtonText),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => toggleFiltro('a_tiempo', aTiempoButtonText),
                        style: ElevatedButton.styleFrom(
                          primary: aTiempoFilter ? Colors.grey : Colors.blue,
                        ),
                        child: Text(aTiempoButtonText),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => toggleFiltro('por_vencer', porVencerButtonText),
                        style: ElevatedButton.styleFrom(
                          primary: porVencerFilter ? Colors.grey : Colors.blue,
                        ),
                        child: Text(porVencerButtonText),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => toggleFiltro('vencidos', vencidosButtonText),
                        style: ElevatedButton.styleFrom(
                          primary: vencidosFilter ? Colors.grey : Colors.blue,
                        ),
                        child: Text(vencidosButtonText),
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
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
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
                    for (var dato in currentPageData) _buildTableRow(dato),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_currentPage > 0) {
                          _currentPage--;
                        }
                      });
                    },
                    child: const Text('Anterior'),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if ((_currentPage + 1) * _perPage < datos.length) {
                          _currentPage++;
                        }
                      });
                    },
                    child: const Text('Siguiente'),
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
    home: Vida(),
  ));
}
