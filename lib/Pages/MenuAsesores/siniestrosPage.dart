import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:appgam/Pages/asesoresPage.dart';

class SiniestroModel {
  final String id;
  final String ramo;
  final String contratante;
  final String afectado;
  final String nPoliza;
  final String fecha;
  final String estado;

  SiniestroModel({
    required this.id,
    required this.ramo,
    required this.contratante,
    required this.afectado,
    required this.nPoliza,
    required this.fecha,
    required this.estado,
  });

  factory SiniestroModel.fromJson(Map<String, dynamic> json) {
    return SiniestroModel(
      id: json['id'] ?? '',
      ramo: json['linea_s'] ?? '',
      contratante: json['contratante'] ?? '',
      afectado: json['afectado'] ?? '',
      nPoliza: json['n_poliza'] ?? '',
      fecha: json['fecha'] ?? '',
      estado: json['estado'] ?? '',
    );
  }
}

class Siniestro extends StatefulWidget {
  final String nombreUsuario;

  const Siniestro({super.key, required this.nombreUsuario});

  @override
  _SiniestroState createState() => _SiniestroState();
}

class _SiniestroState extends State<Siniestro> {
  final List<SiniestroModel> _datosOriginales = [];
  List<SiniestroModel> _datosFiltrados = [];
  int _rowsPerPage = 10;
  int _currentPage = 0;
  String _searchTerm = '';
  bool _isLoading = false;
  bool _isSearchVisible = false;

  String _sortColumn = 'id';
  bool _isAscending = true;

  late Timer _inactivityTimer;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _fetchData();
    _startInactivityTimer();
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliossiniestros.php?username=${widget.nombreUsuario}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> siniestros = data['data'];

        final nuevosDatos = siniestros.map((item) => SiniestroModel.fromJson(item)).toList();

        setState(() {
          _datosOriginales.addAll(nuevosDatos);
          _datosFiltrados = List.from(_datosOriginales);
        });
      } else {
        _showErrorDialog('Error al obtener datos del servidor.');
      }
    } catch (e) {
      _showErrorDialog('Error al cargar datos: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Búsqueda con debounce
  void _performSearch(String searchTerm) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchTerm = searchTerm;
        _datosFiltrados = _searchTerm.isEmpty
            ? List.from(_datosOriginales)
            : _datosOriginales.where((siniestro) {
          return siniestro.id.contains(searchTerm) ||
              siniestro.contratante.toLowerCase().contains(searchTerm.toLowerCase());
        }).toList();
      });
    });
  }

  void _sortTable(String column) {
    setState(() {
      if (_sortColumn == column) {
        _isAscending = !_isAscending;
      } else {
        _sortColumn = column;
        _isAscending = true;
      }

      _datosFiltrados.sort((a, b) {
        final aValue = _getValueForColumn(a, column);
        final bValue = _getValueForColumn(b, column);

        return _isAscending
            ? aValue.compareTo(bValue)
            : bValue.compareTo(aValue);
      });
    });
  }

  dynamic _getValueForColumn(SiniestroModel siniestro, String column) {
    switch (column) {
      case 'id':
        return siniestro.id;
      case 'ramo':
        return siniestro.ramo;
      case 'contratante':
        return siniestro.contratante;
      case 'fecha':
        return siniestro.fecha;
      default:
        return '';
    }
  }

  void _changePage(bool isNext) {
    setState(() {
      if (isNext) {
        if ((_currentPage + 1) * _rowsPerPage < _datosFiltrados.length) {
          _currentPage++;
        }
      } else {
        if (_currentPage > 0) {
          _currentPage--;
        }
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _startInactivityTimer() {
    const duration = Duration(seconds: 300);
    _inactivityTimer = Timer(duration, () {
      Navigator.popUntil(context, (route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _inactivityTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final start = _currentPage * _rowsPerPage;
    final end = (_currentPage + 1) * _rowsPerPage;
    final visibleRows = _datosFiltrados.sublist(
      start,
      end > _datosFiltrados.length ? _datosFiltrados.length : end,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
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
            Text('Bienvenido, ${widget.nombreUsuario}'),
          ],
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(  // Agregado para permitir desplazamiento
        child: Column(
          children: [
            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: _performSearch,
                  decoration: const InputDecoration(
                    hintText: 'Buscar...',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(  // Asegura que la tabla no crezca más allá de un límite
                constraints: BoxConstraints(maxHeight: 500),  // Ajusta la altura máxima
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: const Text('Folio GAM'),
                        onSort: (columnIndex, ascending) => _sortTable('id'),
                      ),
                      DataColumn(
                        label: const Text('RAMO'),
                        onSort: (columnIndex, ascending) => _sortTable('ramo'),
                      ),
                      DataColumn(
                        label: const Text('Contratante'),
                        onSort: (columnIndex, ascending) => _sortTable('contratante'),
                      ),
                      DataColumn(
                        label: const Text('Fecha'),
                        onSort: (columnIndex, ascending) => _sortTable('fecha'),
                      ),
                    ],
                    rows: visibleRows.map((siniestro) {
                      return DataRow(
                        cells: [
                          DataCell(Text(siniestro.id)),
                          DataCell(Text(siniestro.ramo)),
                          DataCell(Text(siniestro.contratante)),
                          DataCell(Text(siniestro.fecha)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _changePage(false),
                    child: const Text('< Anterior'),
                  ),
                  TextButton(
                    onPressed: () => _changePage(true),
                    child: const Text('Siguiente >'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _DataSource extends DataTableSource {
  final List<SiniestroModel> _datos;

  _DataSource(this._datos);

  @override
  DataRow getRow(int index) {
    final siniestro = _datos[index];
    return DataRow(
      cells: [
        DataCell(Text(siniestro.id)),
        DataCell(Text(siniestro.ramo)),
        DataCell(Text(siniestro.contratante)),
        DataCell(Text(siniestro.fecha)),
      ],
    );
  }

  @override
  int get rowCount => _datos.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
