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
          final jsonResponse = json.decode(response.body) as List<dynamic>;
          setState(() {
            datos = jsonResponse.map((dynamic item) {
              Map<String, String> mappedItem = {};
              if (item is Map<String, dynamic>) {
                item.forEach((key, value) {
                  // Manejar campos numéricos vacíos
                  mappedItem[key] = value?.toString() ?? '';
                });
              }
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

      if (activeFilters.isNotEmpty) {
        combinedFilters += ',${activeFilters.join(',')}';
      }

      final response = await http.get(Uri.parse(
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliosvida.php?filter=$combinedFilters&username=${widget.nombreUsuario}'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          datos = jsonResponse.map((dynamic item) {
            Map<String, String> mappedItem = {};
            if (item is Map<String, dynamic>) {
              item.forEach((key, value) {
                mappedItem[key] = value?.toString() ?? '';
              });
            }
            return mappedItem;
          }).toList();
          filtroAplicado = filterButtonText[filterNames] ?? '';
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

  void toggleFiltro(String filterName, String buttonText) {
    setState(() {
      if (isFilterActive(filterName)) {
        activeFilters.remove(filterName);
      } else {
        activeFilters.clear();
        activeFilters.add(filterName);
      }

      if (['A TIEMPO', 'POR VENCER', 'VENCIDOS'].contains(filterName)) {
        filtroAplicado = buttonText;
      } else {
        filtroAplicado = activeFilters.isNotEmpty ? activeFilters.join(', ') : '';
      }
    });

    if (['A TIEMPO', 'POR VENCER', 'VENCIDOS'].contains(filterName)) {
      fetchDataWithFilter(filterName);
    } else {
      applySecondFilter(filterName);
    }
  }

  void applySecondFilter(String filterName) {
    if (activeFilters.isNotEmpty) {
      String primaryFilter = activeFilters.first;
      String combinedFilters = '$primaryFilter,$filterName';
      fetchDataWithFilter(combinedFilters);
    } else {
      fetchDataWithFilter(filterName);
    }
  }

  void performSearch() {
    if (searchTerm.isNotEmpty) {
      setState(() {
        final filteredData = datos.where((item) {
          final searchString = searchTerm.toLowerCase();
          return item.values.any((value) {
            final lowerValue = value.toLowerCase();
            if (lowerValue.contains(searchString)) {
              return true;
            }
            return double.tryParse(searchTerm) != null && double.tryParse(value) == double.tryParse(searchTerm);
          });
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
            'Sin Resultados', style: TextStyle(fontFamily: 'Roboto'),
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

  Future<void> fetchDataWithGreenSemaforo() async {
    try {
      final url = 'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliosvida.php?filter=A_TIEMPO&username=${widget.nombreUsuario}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          datos = jsonResponse.map((dynamic item) {
            Map<String, String> mappedItem = {};
            if (item is Map<String, dynamic>) {
              item.forEach((key, value) {
                mappedItem[key] = value?.toString() ?? '';
              });
            }
            return mappedItem;
          }).toList();
          filtroAplicado = 'A TIEMPO';
        });
      } else {
        _showErrorDialog('Hubo un problema al obtener los datos. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al decodificar JSON: $e');
      _showErrorDialog('Hubo un problema al decodificar los datos JSON.');
    }
  }

  void fetchDataWithYellowSemaforo() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliosvida.php?filter=POR_VENCER&username=${widget.nombreUsuario}'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          datos = jsonResponse.map((dynamic item) {
            Map<String, String> mappedItem = {};
            if (item is Map<String, dynamic>) {
              item.forEach((key, value) {
                mappedItem[key] = value?.toString() ?? '';
              });
            }
            return mappedItem;
          }).toList();
          filtroAplicado = 'POR VENCER';
        });
      } else {
        _showErrorDialog('Hubo un problema al obtener los datos. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al decodificar JSON: $e');
      _showErrorDialog('Hubo un problema al decodificar los datos JSON.');
    }
  }

  void fetchDataWithRedSemaforo() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.asesoresgam.com.mx/sistemas1/gam/tablafoliosvida.php?filter=VENCIDOS&username=${widget.nombreUsuario}'));
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          datos = jsonResponse.map((dynamic item) {
            Map<String, String> mappedItem = {};
            if (item is Map<String, dynamic>) {
              item.forEach((key, value) {
                mappedItem[key] = value?.toString() ?? '';
              });
            }
            return mappedItem;
          }).toList();
          filtroAplicado = 'VENCIDOS';
        });
      } else {
        _showErrorDialog('Hubo un problema al obtener los datos. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al decodificar JSON: $e');
      _showErrorDialog('Hubo un problema al decodificar los datos JSON.');
    }
  }

  void _startInactivityTimer() {
    _inactivityTimer = Timer.periodic(const Duration(minutes: 5), (Timer timer) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const MyApp(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _inactivityTimer.cancel();
    super.dispose();
  }

  bool isFilterActive(String filterName) {
    return activeFilters.contains(filterName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vida'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(
                  onSearch: (searchTerm) {
                    setState(() {
                      this.searchTerm = searchTerm;
                    });
                    performSearch();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  fetchDataWithGreenSemaforo();
                },
                child: const Text('A TIEMPO'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchDataWithYellowSemaforo();
                },
                child: const Text('POR VENCER'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchDataWithRedSemaforo();
                },
                child: const Text('VENCIDOS'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: datos.length,
              itemBuilder: (context, index) {
                final item = datos[index];
                return Card(
                  child: ListTile(
                    title: AutoSizeText(item['Nombre'] ?? 'No disponible'),
                    subtitle: AutoSizeText(item['Descripción'] ?? 'No disponible'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleVida(id: widget.nombreUsuario, nombreUsuario: '',),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final Function(String) onSearch;

  DataSearch({required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [];
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}
