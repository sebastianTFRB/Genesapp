import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class VisorPdfScreen extends StatelessWidget {
  final String nombreArchivo;

  const VisorPdfScreen({super.key, required this.nombreArchivo});

  @override
  Widget build(BuildContext context) {
    final String baseUrl = 'http://192.168.20.10:5000/uploads/';
    final String encodedNombre = Uri.encodeComponent(nombreArchivo);
    final String fullUrl = '$baseUrl$encodedNombre';

    return Scaffold(
      appBar: AppBar(title: Text(nombreArchivo)),
      body: SfPdfViewer.network(fullUrl),
    );
  }
}
