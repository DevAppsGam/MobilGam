import 'dart:convert';
import 'package:appgam/Pages/asesoresPage.dart';
import 'package:appgam/main.dart';
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
        _showErrorDialog('Hubo un problema al obtener los datos.');
      }
    } catch (e) {
      _showErrorDialog('Hubo un problema al decodificar los datos JSON.');
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
          return item.values.any((value) => value.toLowerCase().contains(searchString));
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

  Future<void> fetchDataWithSemaforo(String semaforo) async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliosvida.php?filter=$semaforo&username=${widget.nombreUsuario}'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as List;
        setState(() {
          datos = jsonResponse.map((item) => Map<String, dynamic>.from(item)).toList();
          filtroAplicado = semaforo.replaceAll('_', ' ');
        });
      } else {
        _showErrorDialog('Hubo un problema al obtener los datos. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
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
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
          _buildTableCell(item['id'] ?? ''),
          _buildTableCell(item['contratante'] ?? ''),
          _buildTableCell(item['poliza'] ?? ''),
          _buildTableCell(item['folio_gnp'] ?? ''),
          _buildTableCell(item['fecha_promesa'] ?? ''),
          _buildTableCell(item['estatus_tramite'] ?? ''),
        ],
      );
    }).toList();
  }

  Widget _buildTableCell(String text) {
    return TableCell(
      child: Container(
        constraints: const BoxConstraints.expand(height: 70.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontFamily: 'Roboto'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableContainer() {
    return Container(
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
        border: TableBorder.all(color: Colors.grey.shade300),
        children: [
          _buildTableHeaderRow(),
          ..._buildTableRows(),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filterName, String buttonText, Color color, Color pressedColor) {
    return ElevatedButton(
      onPressed: () {
        toggleFiltro(filterName);
      },
      style: ElevatedButton.styleFrom(
        primary: isFilterActive(filterName) ? pressedColor : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: Text(buttonText, style: const TextStyle(fontFamily: 'Roboto')),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _currentPage > 0 ? () {
            setState(() {
              _currentPage--;
            });
          } : null,
        ),
        Text(
          'Página ${_currentPage + 1}',
          style: const TextStyle(fontFamily: 'Roboto'),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: datos.length > (_currentPage + 1) * _perPage ? () {
            setState(() {
              _currentPage++;
            });
          } : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetInactivityTimer,
      onPanDown: (_) => _resetInactivityTimer(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: (){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => Asesores(nombreUsuario: widget.nombreUsuario,)),
                    (Route<dynamic> route) => false, // Esto elimina todas las rutas anteriores
              );
            },
          ),
          title:  Text('Detalles de Folios de Vida de ${widget.nombreUsuario}', style: TextStyle(fontFamily: 'Roboto')),
          backgroundColor: const Color.fromRGBO(15, 132, 194, 1),
        ),
        body: Column(
          children: [
            if (filtroAplicado.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Filtro aplicado: $filtroAplicado',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Wrap(
              spacing: 8.0, // Espacio horizontal entre los botones
              runSpacing: 4.0, // Espacio vertical entre las líneas de botones
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: 90.0, // Ajustar el ancho para que se ajuste mejor
                  child: _buildFilterButton('ALTA DE POLIZA', 'ALTA', Colors.blue[300]!, Colors.blue[900]!),
                ),
                SizedBox(
                  width: 95.0,
                  child: _buildFilterButton('PAGOS', 'PAGOS', Colors.blue[300]!, Colors.blue[900]!),
                ),
                SizedBox(
                  width: 150.0,
                  child: _buildFilterButton('MOVIMIENTOS', 'MOVIMIENTOS', Colors.blue[300]!, Colors.blue[900]!),
                ),
                SizedBox(
                  width: 120.0,
                  child: _buildFilterButton('A TIEMPO', 'A TIEMPO', Colors.green, Colors.green[900]!),
                ),
                SizedBox(
                  width: 150.0,
                  child: _buildFilterButton('POR VENCER', 'POR VENCER', Colors.yellow, Colors.yellow[900]!),
                ),
                SizedBox(
                  width: 120.0,
                  child: _buildFilterButton('VENCIDOS', 'VENCIDOS', Colors.red, Colors.red[900]!),
                ),
                IconButton(
                  icon: Icon(
                    _isSearchVisible ? Icons.close : Icons.search,
                    color: const Color.fromRGBO(15, 132, 194, 1),
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearchVisible = !_isSearchVisible;
                    });
                  },
                ),
              ],
            ),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildTableContainer(),
              ),
            ),
            const SizedBox(height: 8.0),
            _buildPaginationControls(),
          ],
        ),
      ),
    );
  }
}
