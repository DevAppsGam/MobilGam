import 'dart:convert';
import 'package:appgam/Pages/MenuAsesores/Detalles/vidaDetallePage.dart';
import 'package:appgam/Pages/asesoresPage.dart';
import 'package:appgam/main.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class Vida extends StatefulWidget {
  final String nombreUsuario;

  const Vida({super.key, required this.nombreUsuario});

  @override
  _VidaState createState() => _VidaState();
}

class _VidaState extends State<Vida> {
  bool _isLoading = false;
  bool _isSearchVisible = false;
  late Timer _inactivityTimer;
  List<Map<String, dynamic>> datos = [];
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

  bool isFilterActive(String filterName) => activeFilters.contains(filterName);

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
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliosvida.php?username=${widget.nombreUsuario}'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        if (jsonResponse.isNotEmpty) {
          setState(() {
            datos = jsonResponse.map((item) => Map<String, dynamic>.from(item)).toList();
          });
        }
      } else {
        _showErrorDialog('Hubo un problema al obtener los datos. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Hubo un problema: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchDataWithFilter(String? filterNames) async {
    if (filterNames != null) {
      String combinedFilters = filterNames;

      if (activeFilters.isNotEmpty) {
        combinedFilters += ',${activeFilters.join(',')}';
      }

      try {
        final response = await http.get(Uri.parse(
            'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliosvida.php?filter=$combinedFilters&username=${widget.nombreUsuario}'));
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body) as List;
          setState(() {
            datos = jsonResponse.map((item) => Map<String, dynamic>.from(item)).toList();
          });
        } else {
          _showErrorDialog('Hubo un problema al obtener los datos. Código de estado: ${response.statusCode}');
        }
      } catch (e) {
        _showErrorDialog('Hubo un problema: ${e.toString()}');
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

  void toggleFiltro(String filterName) {
    setState(() {
      if (isFilterActive(filterName)) {
        activeFilters.remove(filterName);
      } else {
        activeFilters.add(filterName);
      }
      filtroAplicado = activeFilters.isNotEmpty ? activeFilters.join(', ') : '';
      applyFilters();
    });
  }

  void applyFilters() {
    String filters = activeFilters.join(',');
    fetchDataWithFilter(filters);
  }

  void performSearch() {
    if (searchTerm.isNotEmpty) {
      setState(() {
        final filteredData = datos.where((item) {
          final searchString = searchTerm.toLowerCase();
          return item.values.any((value) => value is String && value.toLowerCase().contains(searchString));
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
          title: const Text('Sin Resultados', style: TextStyle(fontFamily: 'Roboto')),
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
    _inactivityTimer.cancel();
    super.dispose();
  }

  void _startInactivityTimer() {
    const inactivityDuration = Duration(seconds: 420);
    _inactivityTimer = Timer(inactivityDuration, () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const MyApp()),
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
        _buildTableHeaderCell('Contratante'),
        _buildTableHeaderCell('N° Póliza'),
        _buildTableHeaderCell('Folio GNP'),
        _buildTableHeaderCell('Fecha Promesa'),
        _buildTableHeaderCell('Estatus Trámite'),
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
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 12.0),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildTableRows() {
    List<Map<String, dynamic>> paginatedData = datos
        .skip(_currentPage * _perPage)
        .take(_perPage)
        .toList();
    return paginatedData.map((item) {
      return TableRow(
        children: [
          _buildTableCell(
            isFolio: true,
            item['id'] ?? '',
          ),
          _buildTableCell(item['contratante'] ?? ''),
          _buildTableCell(item['poliza'] ?? ''),
          _buildTableCell(item['fgnp'] ?? ''),
          _buildTableCell(item['fecha_promesa'] ?? ''),
          _buildTableCell(item['estado'] ?? ''),
        ],
      );
    }).toList();
  }

  Widget _buildTableCell(String text, {bool isFolio = false}) {
    return TableCell(
      child: GestureDetector(
        onTap: isFolio ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleVida(
                nombreUsuario: widget.nombreUsuario,
                id: text,
              ),
            ),
          );
        } : null,
        child: Container(
          constraints: const BoxConstraints.expand(height: 75.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: isFolio ? Colors.blue : Colors.black,
                  decoration: isFolio ? TextDecoration.underline : TextDecoration.none,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableContainer() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Table(
          border: TableBorder.all(color: Colors.black),
          children: [
            _buildTableHeaderRow(),
            ..._buildTableRows(),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    double appBarTextSize = MediaQuery.textScalerOf(context).scale(16);

    return GestureDetector(
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),
      child: Scaffold(
        resizeToAvoidBottomInset: true, // Asegura que la pantalla se ajuste al teclado
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      Asesores(nombreUsuario: widget.nombreUsuario),
                ),
                    (Route<dynamic> route) => false,
              );
            },
          ),
          title: Text(
            'Folios de Vida de ${widget.nombreUsuario}',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: appBarTextSize,
              color: const Color.fromRGBO(246, 246, 246, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
          actions: [
            if (!_isSearchVisible)
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isSearchVisible = true;
                  });
                },
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (_isSearchVisible)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchTerm = value;
                      });
                      performSearch();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Buscar...',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: _buildFilterButton('ALTA DE POLIZA', 'ALTA', Colors.blue[300]!, Colors.blue[900]!),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: _buildFilterButton('PAGOS', 'PAGOS', Colors.blue[300]!, Colors.blue[900]!),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: _buildFilterButton('MOVIMIENTOS', 'MOVIMIENTOS', Colors.blue[300]!, Colors.blue[900]!),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: _buildFilterButton('A TIEMPO', 'A TIEMPO', Colors.green, Colors.green[900]!),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: _buildFilterButton('POR VENCER', 'POR VENCER', Colors.yellow, Colors.yellow[900]!),
                      ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: _buildFilterButton('VENCIDOS', 'VENCIDOS', Colors.red, Colors.red[900]!),
                      ),
                    ],
                  ),
                ],
              ),
              if (filtroAplicado.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Filtro aplicado: $filtroAplicado',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey[200],
                      child: Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                            ),
                            children: [
                              _buildTableHeaderCell('FOLIO GAM'),
                              _buildTableHeaderCell('CONTRATANTE'),
                              _buildTableHeaderCell('N° PÓLIZA'),
                              _buildTableHeaderCell('FOLIO GNP'),
                              _buildTableHeaderCell('FECHA PROMESA'),
                              _buildTableHeaderCell('ESTATUS TRÁMITE'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _isLoading
                        ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color.fromRGBO(250, 161, 103, 2),
                          ),
                          SizedBox(height: 14.0),
                          Text(
                            'Cargando datos, por favor espera...',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                        : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Table(
                        border: TableBorder.all(color: Colors.grey.shade300),
                        children: _buildTableRows(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              _buildPaginationControls(),
            ],
          ),
        ),
        floatingActionButton: _isSearchVisible
            ? FloatingActionButton(
          onPressed: () {
            setState(() {
              _isSearchVisible = false;
            });
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.close),
        )
            : null,
      ),
    );
  }


  Widget _buildPaginationControls() {
    int totalPages = (datos.length / _perPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _currentPage > 0
              ? () {
            setState(() {
              _currentPage--;
            });
          }
              : null, // Deshabilitado si estás en la primera página
        ),
        Text(
          'Página ${_currentPage + 1} de $totalPages',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: _currentPage < totalPages - 1
              ? () {
            setState(() {
              _currentPage++;
            });
          }
              : null, // Deshabilitado si estás en la última página
        ),
      ],
    );
  }

  Widget _buildFilterButton(String filterName, String displayName, Color color, Color activeColor) {
    bool isActive = isFilterActive(filterName);

    return GestureDetector(
      onTap: () {
        toggleFiltro(filterName);
      },
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 100.0, // Ancho mínimo para uniformidad (ajusta según necesites)
          minHeight: 50.0, // Altura mínima fija para todos los botones
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: isActive ? activeColor : color,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            displayName,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10.5,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

}
