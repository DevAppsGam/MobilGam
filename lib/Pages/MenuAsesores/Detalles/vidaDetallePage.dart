import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetalleVida extends StatefulWidget {
  final String nombreUsuario;

  DetalleVida({required this.nombreUsuario});

  @override
  _DetalleVidaState createState() => _DetalleVidaState();
}

class _DetalleVidaState extends State<DetalleVida> {
  Map<String, String> _datosVida = {};

  @override
  void initState() {
    super.initState();
    fetchData().then((data) {
      setState(() {
        _datosVida = data as Map<String, String>;
      });
    });
  }

  Future<List<String>> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.100.73/gam/detallevida.php'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);

      // Verificar que la respuesta contenga al menos los cuatro valores esperados
      if (jsonResponse.length >= 4) {
        return jsonResponse.cast<String>();
      } else {
        throw Exception('Respuesta incompleta');
      }
    } else {
      throw Exception('Error al cargar los datos');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Póliza de ${widget.nombreUsuario}'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16.0,
                    columns: const [
                      DataColumn(label: Text('Campo')),
                      DataColumn(label: Text('Valor')),
                    ],
                    rows: _datosVida.entries.map((entry) {
                      return DataRow(
                        cells: [
                          DataCell(Text(entry.key)),
                          DataCell(Text(entry.value)),
                        ],
                      );
                    }).toList(),
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
