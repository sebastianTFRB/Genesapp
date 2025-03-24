import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:genesapp/medicScreen/visorodf.dart';
import 'package:url_launcher/url_launcher.dart';

class VerArticulosScreen extends StatelessWidget {
  const VerArticulosScreen({super.key});

  Future<void> _abrirArchivo(String nombreArchivo) async {
    final url = 'http://192.168.20.10:5000/uploads/$nombreArchivo';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el archivo: $url';
    }
  }

  String _formatearFecha(Timestamp timestamp) {
    final fecha = timestamp.toDate();
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Artículos Publicados")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('articulos_medicos')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No hay artículos publicados."));
          }

          final articulos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: articulos.length,
            itemBuilder: (context, index) {
              final data = articulos[index].data() as Map<String, dynamic>;
              final nombre = data['nombreArchivo'] ?? 'Sin nombre';
              final email = data['email'] ?? 'Desconocido';
              final fecha = data['fecha'] != null ? _formatearFecha(data['fecha']) : 'Sin fecha';

              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(nombre),
                  subtitle: Text('Publicado por: $email\nFecha: $fecha'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VisorPdfScreen(nombreArchivo: nombre),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
