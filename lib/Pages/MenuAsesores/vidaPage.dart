import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Vida extends StatefulWidget {
  const Vida({Key? key}) : super(key: key);

  @override
  _VidaState createState() => _VidaState();
}

class _VidaState extends State<Vida> {
  List<Map<String, String>> datos = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.1.89/gam/tablafoliosvida.php'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        datos = jsonResponse.map((dynamic item) {
          Map<String, String> mappedItem = {};
          for (var entry in item.entries) {
            mappedItem[entry.key] = entry.value ?? ''; // Manejar campos nulos
          }
          return mappedItem;
        }).toList();
      });
    } else {
      // Manejar el error en caso de que la solicitud falle
      print('Error en la solicitud: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Hubo un problema al obtener los datos.'),
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
  }


  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  TableRow _buildTableHeaderRow() {
    return TableRow(
      children: [
        _buildTableHeaderCell('Folio GAM'),
        _buildTableHeaderCell('Nombre del Contratante'),
        _buildTableHeaderCell('N Poliza'),
        _buildTableHeaderCell('Folio GNP'),
        _buildTableHeaderCell('Fecha Promesa'),
        _buildTableHeaderCell('Estatus Trámite'),
      ],
    );
  }

  TableCell _buildTableHeaderCell(String text) {
    return TableCell(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(Map<String, String> datos) {
    return TableRow(
      children: [
        _buildTableCell(datos['fgnp'] ?? ''),
        _buildTableCell(datos['contratante'] ?? ''),
        _buildTableCell(datos['poliza'] ?? ''),
        _buildTableCell(datos['polizap'] ?? ''),
        _buildTableCell(datos['fecha'] ?? ''),
        _buildTableCell(datos['estado'] ?? ''),  // Asegúrate de agregar 'estado'
      ],
    );
  }


  TableCell _buildTableCell(String text) {
    return TableCell(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mis Trámites de Vida',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Búsqueda'),
                            content: const TextField(
                              // Lógica de búsqueda
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Realizar búsqueda
                                  Navigator.pop(context);
                                },
                                child: const Text('Buscar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.blueAccent,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el primer filtro
                      },
                      child: const Text('ALTA DE POLIZA'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el segundo filtro
                      },
                      child: const Text('PAGOS'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el tercer filtro
                      },
                      child: const Text('MOVIMIENTOS'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el cuarto filtro
                      },
                      child: const Text('A TIEMPO'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el quinto filtro
                      },
                      child: const Text('POR VENCER'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para aplicar el sexto filtro
                      },
                      child: const Text('VENCIDOS'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Table(
                border: TableBorder.all(
                  color: Colors.blueAccent,
                  width: 2.0,
                ),
                children: [
                  _buildTableHeaderRow(),
                  for (var dato in datos) _buildTableRow(dato),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {
                  // Lógica para manejar la acción del ícono
                },
                icon: const Icon(
                  Icons.message_rounded,
                  size: 42,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
