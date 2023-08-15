import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class graficas extends StatefulWidget {
  const graficas({Key? key}) : super(key: key);

  @override
  _graficasState createState() => _graficasState();
}

class _graficasState extends State<graficas> {
  late Future<Map<String, dynamic>> _dataFuture;
  late Future<List<Map<String, dynamic>>> _lineChartDataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = obtenerDatos();
    _lineChartDataFuture = obtenerDatosLineChart();
  }

  Future<Map<String, dynamic>> obtenerDatos() async {
    final response = await http.get(Uri.parse('http://192.168.1.89/gam/obtenerpolizasvida.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener los datos');
    }
  }

  Future<List<Map<String, dynamic>>> obtenerDatosLineChart() async {
    final response = await http.get(Uri.parse('http://192.168.1.89/gam/vidapormeses.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Página de Gráficas',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 60), // Espacio entre título y gráfica
                AspectRatio(
                  aspectRatio: 1.5, // Ajusta el tamaño de la gráfica
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: _dataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error al cargar los datos');
                      } else if (snapshot.hasData) {
                        final totalTerminado = snapshot.data!['totalTerminado'];
                        final totalTerminadoConPoliza = snapshot.data!['totalTerminadoConPoliza'];
                        return PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: totalTerminado.toDouble(),
                                color: Colors.blue,
                                title: 'Polizas Emitidas',
                              ),
                              PieChartSectionData(
                                value: totalTerminadoConPoliza.toDouble(),
                                color: Colors.blueGrey,
                                title: 'Polizas Pagadas',
                              ),
                            ],
                            // Otras configuraciones de la gráfica
                          ),
                        );
                      } else {
                        return const Text('No se encontraron datos');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 60),
                AspectRatio(
                  aspectRatio: 1.5, // Ajusta el tamaño de la gráfica
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _lineChartDataFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error al cargar los datos');
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: data.map((item) => FlSpot(
                                    double.parse(item['mes'].toString()),
                                    item['total'].toDouble()
                                )).toList(),
                                isCurved: true,
                                colors: [Colors.blue],
                                dotData: FlDotData(show: false),
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: SideTitles(showTitles: true),
                              bottomTitles: SideTitles(
                                showTitles: true,
                                getTitles: (value) {
                                  return 'Mes $value';
                                },
                              ),
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: true),
                          ),
                        );
                      } else {
                        return const Text('No se encontraron datos');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: graficas()));
}
