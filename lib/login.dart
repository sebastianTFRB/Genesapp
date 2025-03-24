import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:genesapp/usersScreen/screens_guias/guias_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'adminScreen/admin.dart';
import 'medicScreen/medico.dart';
import 'pacientScreen/paciente.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FlutterLogo(size: 80),
              const SizedBox(height: 20),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('Iniciar Sesión', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Correo electrónico'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Contraseña'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _signInWithEmail,
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                        child: _isLoading ? const CircularProgressIndicator() : const Text('Ingresar'),
                      ),
                      const SizedBox(height: 10),
                      SignInButton(
                        Buttons.Google,
                        text: "Iniciar sesión con Google",
                        onPressed: () => _signInWithGoogle(),
                      ),
                      
                      const SizedBox(height: 10),
                      if (_error.isNotEmpty)
                        Text(_error, style: const TextStyle(color: Colors.red)),
                        TextButton(
                        onPressed: () async {
                          await GoogleSignIn().signOut();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Listo, ahora puedes elegir otra cuenta")),
                          );
                        },
                        child: const Text("¿Usar otra cuenta de Google?"),
                      )
                    ],
                    
                  ),
                ),
              ),
                          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text("¿No tienes cuenta? Regístrate"),
            )

            ],
          ),
        ),
      ),
    );
    
  }

  Future<void> _signInWithEmail() async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _navigateBasedOnRole(userCredential.user);
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Error al iniciar sesión');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
      scopes: ['email'],
      // Esto permite que el selector aparezca incluso si ya se ha iniciado sesión previamente
      signInOption: SignInOption.standard,
    );

    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // El usuario canceló o no eligió cuenta
      print('No se seleccionó cuenta');
      return;
    }

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'email': user.email,
            'role': 'patient',
            'created_at': DateTime.now(),
          });
        }

        await _navigateBasedOnRole(user);
      }
    } catch (e) {
      setState(() => _error = 'Error al iniciar sesión con Google');
    }
  }

  

  Future<void> _navigateBasedOnRole(User? user) async {
    if (!mounted || user == null) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GuiasScreen()),
    );
  }


  


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
