import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genesapp/widgets/custom_app_bar.dart';
import 'package:genesapp/widgets/roleBasedDrawer.dart';

class GiasScreen extends StatefulWidget {
  const GiasScreen({super.key});

  @override
  State<GiasScreen> createState() => _GiasScreenState();
}

class _GiasScreenState extends State<GiasScreen> {
  String? role;
  bool loading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> syndromes = [
    {
      "name": "Síndrome de Williams",
      "color": Colors.greenAccent,
    },
    {
      "name": "Síndrome de Turner",
      "color": Colors.yellow,
    },
    {
      "name": "Síndrome de Down",
      "color": Colors.orange,
    },
    {
      "name": "Mucopolisacáridos",
      "color": Colors.lightGreen,
    },
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        role = doc.data()?['role'];
        loading = false;
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void nextSyndrome() {
    setState(() {
      currentIndex = (currentIndex + 1) % syndromes.length;
    });
  }

  void previousSyndrome() {
    setState(() {
      currentIndex = (currentIndex - 1 + syndromes.length) % syndromes.length;
    });
  }

  void selectSyndrome(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWithDrawer(
        title: syndromes[currentIndex]["name"],
        color: syndromes[currentIndex]["color"],
        scaffoldKey: _scaffoldKey,
      ),
      drawer: RoleBasedDrawer(
        role: role,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: syndromes[currentIndex]["color"],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: previousSyndrome,
                        ),
                        Text(
                          syndromes[currentIndex]["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                          onPressed: nextSyndrome,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: PopupMenuButton<int>(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onSelected: selectSyndrome,
                            itemBuilder: (context) {
                              return List.generate(syndromes.length, (index) {
                                return PopupMenuItem<int>(
                                  value: index,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        margin: const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: syndromes[index]["color"],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Text(
                                        syndromes[index]["name"],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Información sobre ${syndromes[currentIndex]["name"]}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
