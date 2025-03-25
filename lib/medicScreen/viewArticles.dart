import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:genesapp/medicScreen/visorodf.dart';


class VerArticulosScreen extends StatelessWidget {
  const VerArticulosScreen({super.key});

  
  

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
