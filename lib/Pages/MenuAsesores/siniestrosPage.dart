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

  List<Map<String, String>> datosOriginales = [];
  List<Map<String, String>> datosFiltrados = [];
  final int _perPage = 10;
  int _currentPage = 0;
  String searchTerm = '';
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool noMoreData = false;

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

  Future<void> fetchData({int page = 0}) async {
    if (isLoading || noMoreData) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliossiniestros.php?username=${widget.nombreUsuario}&page=$page&perPage=$_perPage'));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> siniestros = data['data'];

        if (siniestros.isEmpty) {
          setState(() {
            noMoreData = true;
          });
        } else {
          setState(() {
            datosOriginales.addAll(siniestros.map<Map<String, String>>((dynamic item) {
              return item.map<String, String>((key, value) {
                return MapEntry(
                  key.toString(),
                  value?.toString() ?? "",
                );
              });
            }).toList());

            datosFiltrados = List.from(datosOriginales);
          });
        }
      } else {
        _showErrorDialog('Error al obtener los datos del servidor.');
      }
    } catch (e) {
      _showErrorDialog('Error al decodificar JSON: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _currentPage++;
      fetchData(page: _currentPage);
    }
  }

  void performSearch() {
    setState(() {
      if (searchTerm.isEmpty) {
        datosFiltrados = List.from(datosOriginales);
      } else {
        final searchString = searchTerm.toLowerCase();
        datosFiltrados = datosOriginales.where((item) {
          return item.values.any((value) =>
          value.toLowerCase().contains(searchString) ||
              double.tryParse(value) == double.tryParse(searchTerm));
        }).toList();
      }
    });
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
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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
    _scrollController.removeListener(_scrollListener);
    _inactivityTimer.cancel();
    _scrollController.dispose();
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
    return TableCell(
      child: GestureDetector(
        onTap: () {
          if (columna == 'id') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalleSiniestro(
                  nombreUsuario: widget.nombreUsuario,
                  id: text,
                ),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: columna == 'id'
                    ? const Color.fromRGBO(15, 132, 194, 1)
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
        title: Text(
          'Bienvenido ${widget.nombreUsuario}',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 17,
            color: Colors.white,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  searchTerm = value;
                  performSearch();
                },
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: datosFiltrados.isEmpty
                  ? isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const Center(child: Text('No hay datos disponibles.'))
                  : SingleChildScrollView(
                controller: _scrollController,
                child: Table(
                  border: TableBorder.all(
                    color: const Color.fromRGBO(15, 132, 194, 1),
                    width: 1,
                  ),
                  children: [
                    _buildTableHeaderRow(),
                    ...datosFiltrados.map((e) => _buildTableRow(e)),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
