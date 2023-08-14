import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class graficas extends StatelessWidget {
  const graficas({Key? key}) : super(key: key);

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
                const Text(
                  'Página de Gráficas',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20), // Espacio entre título y gráfica
                AspectRatio(
                  aspectRatio: 1.5, // Ajusta el tamaño de la gráfica
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 40,
                          color: Colors.blue,
                          title: 'Sección 1',
                        ),
                        PieChartSectionData(
                          value: 30,
                          color: Colors.green,
                          title: 'Sección 2',
                        ),
                        // Agrega más secciones según tus datos
                      ],
                      // Otras configuraciones de la gráfica
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  width: 400, // Cambia este valor al ancho deseado
                  height: 300, // Cambia este valor a la altura deseada
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 10), // Enero
                            FlSpot(1, 15), // Febrero
                            FlSpot(2, 20), // Marzo
                            // ... Añade los otros meses
                          ],
                          isCurved: true,
                          //color: [color.blue],
                          barWidth: 4,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(show: false),
                        ),
                        // Agregar más objetos LineChartBarData para múltiples líneas si es necesario
                      ],
                      titlesData: FlTitlesData(
                        leftTitles: SideTitles(showTitles: true), // Configurar etiquetas del eje Y izquierdo
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTitles: (value) {
                            List<String> monthNames = [
                              'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
                            ];
                            if (value >= 0 && value < monthNames.length) {
                              return monthNames[value.toInt()];
                            }
                            return '';
                          },
                        ),
                      ),
                      // Otras configuraciones de la gráfica
                    ),
                    // Opcional: controlar las animaciones
                    swapAnimationDuration: Duration(milliseconds: 150),
                    swapAnimationCurve: Curves.linear,
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  width: 300, // Cambia el ancho según tus necesidades
                  height: 300, // Cambia la altura según tus necesidades
                  child: BarChart(
                    BarChartData(
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              y: 10,
                              //colors: Color.fromRGBO(128, 80, 78, 0.2),
                              width: 8,
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              y: 15,
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
                    swapAnimationDuration: Duration(milliseconds: 150),
                    swapAnimationCurve: Curves.linear,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
