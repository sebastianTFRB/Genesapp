import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genesapp/adminScreen/admin.dart';
import 'package:genesapp/adminScreen/adminrequest.dart';
import 'package:genesapp/medicScreen/articles.dart';
import 'package:genesapp/medicScreen/medico.dart';
import 'package:genesapp/medicScreen/viewArticles.dart';
import 'package:genesapp/pacientScreen/paciente.dart';
import 'package:genesapp/usersScreen/perfil.dart';
import 'package:genesapp/login.dart';

import 'package:genesapp/usersScreen/williamspredict.dart';

class RoleBasedDrawer extends StatelessWidget {
  final String? role;

  const RoleBasedDrawer({
    super.key,
    required this.role,
  });

  void _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menú de navegación', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          if (role == 'admin') ...[
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Panel de Administrador'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Panel de Verificación'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminVerificationPanel()),
                );
              },
            ),
          ],
          if (role == 'doctor')
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Panel de Médico'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DoctorScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('subir articulo'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SubirArticuloScreen()),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.feed),
              title: const Text('publicaciones'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VerArticulosScreen()),
              ),
            ),
          if (role == 'patient')
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Panel de Paciente'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              ),
            ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('predictividad williams'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Williamspredict()),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Mi perfil'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () => _handleLogout(context),
          ),
        ],
      ),
    );
  }
}
