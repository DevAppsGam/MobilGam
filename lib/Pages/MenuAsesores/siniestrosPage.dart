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
  final int _perPage = 10;
  int _currentPage = 0;
  String searchTerm = '';
  ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        // Incrementa la página actual para la paginación
        _currentPage++;
      });
    }
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
    _scrollController.addListener(_scrollListener);
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliossiniestros.php?username=${widget.nombreUsuario}'));
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonResponse = json.decode(response.body);
          List<dynamic> data = jsonResponse;
          setState(() {
            datos = data.map((dynamic item) {
              Map<String, String> mappedItem = {};
              item.forEach((key, value) {
                if (value is num || (value is String && value.isNotEmpty)) {
                  mappedItem[key] = value.toString();
                } else {
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
            'Sin Resultados',
            style: TextStyle(fontFamily: 'Roboto'),
          ),
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
  @override
  void dispose() {
    // Configurar las orientaciones permitidas
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Quitar el listener del scroll
    _scrollController.removeListener(_scrollListener);

    // Cancelar el temporizador de inactividad
    _inactivityTimer.cancel();

    // Liberar el controlador de scroll
    _scrollController.dispose();

    // Llamar al método dispose del padre
    super.dispose();
  }


  void _startInactivityTimer() {
    const inactivityDuration = Duration(seconds: 300);
    _inactivityTimer = Timer(inactivityDuration, () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
            (Route<dynamic> route) => false,
      );
    });
  }

  void _resetInactivityTimer() {
    _inactivityTimer.cancel();
    _startInactivityTimer();
  }

  TableRow _buildTableHeaderRow() {
    return TableRow(
      children: [
        _buildTableHeaderCell('Folio GAM'),
        _buildTableHeaderCell('RAMO'),
        _buildTableHeaderCell('Contratante'),
        _buildTableHeaderCell('Nombre del Afectado'),
        _buildTableHeaderCell('N Póliza'),
        _buildTableHeaderCell('Fecha solicitud'),
        _buildTableHeaderCell('Estatus Trámite'),
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              minFontSize: 9,
              stepGranularity: 1,
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

  Widget _buildTableCell(String text, Map<String, String> datos, String columna) {
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
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value;
                    });
                    performSearch();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Buscar...',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  border: TableBorder.all(
                    color: const Color.fromRGBO(15, 132, 194, 1),
                    width: 1,
                  ),
                  children: [
                    _buildTableHeaderRow(),
                    ...filteredData
                        .skip(_currentPage * _perPage)
                        .take(_perPage)
                        .map((e) => _buildTableRow(e))
                        .toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
