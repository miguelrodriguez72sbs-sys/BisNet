import 'package:flutter/material.dart';
import 'package:bisnet/widgets/search_bar.dart';
import 'package:bisnet/widgets/notifications_bell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF6B962D),
        title: Row(
          children: [
            Image.asset('assets/Lechuzas/Logo.png', height: 40),
            const SizedBox(width: 12),
            const Text(
              'Bisnet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          NotificationBell(notificationCount: 1, onPressed: () {}),
          CustomSearchBar(
            width: 150,
            onChanged: (value) {
              // lógica de búsqueda aquí
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const Center(
        child: Text('Contenido principal aquí'),
      ), //borrar esta linea y agregar el contenido real de la pantalla de inicio
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF6B962D),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
