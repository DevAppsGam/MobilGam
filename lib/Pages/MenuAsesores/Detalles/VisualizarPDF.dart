import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/services.dart'; // Importa el paquete services.dart

class PdfViewer extends StatefulWidget {
  final String pdfUrl;

  PdfViewer({required this.pdfUrl});

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late PdfController _pdfController;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openData(InternetFile.get(widget.pdfUrl)),
    );
    super.initState();

    // Establece la orientación de la pantalla a vertical cuando se abre el PdfViewer
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Restaura las preferencias de orientación cuando se cierra el PdfViewer
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _pdfController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel += 0.25;
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel -= 0.25;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: _zoomOut,
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () {
              // Agrega la lógica para descargar el PDF
              // Puedes usar un paquete como 'permission_handler' para gestionar permisos de almacenamiento.
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Agrega la lógica para imprimir el PDF
              // Puedes usar el paquete 'printing' para facilitar la impresión.
            },
          ),
        ],
      ),
      body: Center(
        child: PhotoView.customChild(
          backgroundDecoration: const BoxDecoration(color: Colors.white),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          initialScale: _zoomLevel,
          child: PdfView(
            controller: _pdfController,
          ),
        ),
      ),
    );
  }
}
