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

  @override
  void initState() {
    super.initState();
    _dataFuture = obtenerDatos();
  }

  Future<Map<String, dynamic>> obtenerDatos() async {
    final response = await http.get(Uri.parse('http://192.168.1.89/gam/obtenerpolizasvida.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
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
                                title: 'Terminado',
                              ),
                              PieChartSectionData(
                                value: totalTerminadoConPoliza.toDouble(),
                                color: Colors.green,
                                title: 'Terminado con Póliza',
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
                SizedBox(
                  width: 400, // Cambia este valor al ancho deseado
                  height: 300, // Cambia este valor a la altura deseada
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

                        return LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: [
                                  FlSpot(0, totalTerminado.toDouble()), // Terminado
                                  FlSpot(1, totalTerminadoConPoliza.toDouble()), // Terminado con Póliza
                                  // ... Añade otros valores si es necesario
                                ],
                                isCurved: true,
                                // Resto del código de LineChart
                              ),
                            ],
                            // Resto del código de títulos
                            titlesData: FlTitlesData(
                              leftTitles: SideTitles(showTitles: true),
                              bottomTitles: SideTitles(
                                showTitles: true,
                                getTitles: (value) {
                                  // Aquí puedes personalizar las etiquetas en el eje X
                                  // según tus necesidades y datos
                                  return 'Grupo $value';
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Text('No se encontraron datos');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: 300, // Cambia el ancho según tus necesidades
                  height: 300, // Cambia la altura según tus necesidades
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

                        return BarChart(
                          BarChartData(
                            barGroups: [
                              BarChartGroupData(
                                x: 0,
                                barRods: [
                                  BarChartRodData(
                                    y: totalTerminado.toDouble(),
                                    //colors: Color.fromRGBO(128, 80, 78, 0.2),
                                    width: 8,
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    y: totalTerminadoConPoliza.toDouble(),
                                    //color: Colors.green,
                                    width: 8,
                                  ),
                                ],
                              ),
                              // Agrega más grupos de barras según tus datos
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: SideTitles(showTitles: true),
                              bottomTitles: SideTitles(
                                showTitles: true,
                                getTitles: (value) {
                                  // Aquí puedes personalizar las etiquetas en el eje X
                                  // según tus necesidades y datos
                                  return 'Grupo $value';
                                },
                              ),
                            ),
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
