import 'package:flutter/material.dart';
import 'package:bisnet/pages/login.dart';
import 'package:bisnet/main.dart';

class TraductorScreen extends StatefulWidget {
  const TraductorScreen({super.key});

  @override
  State<TraductorScreen> createState() => _TraductorScreenState();
}

class _TraductorScreenState extends State<TraductorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3C24),
        title: Row(
          children: [
            Image.asset('assets/Lechuzas/Logo.png', height: 40),
            const SizedBox(width: 12),
            const Text(
              'Bisnet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose your language',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  //Cambia el idioma a español
                  MyApp.of(context)?.setLocale(const Locale('es'));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Español'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  //Cambia el idioma a inglés
                  MyApp.of(context)?.setLocale(const Locale('en'));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('English'),
              ),
              const SizedBox(height: 32),
              Image.asset(
                'assets/Lechuzas/Lechuza_3.png',
                height: 180,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
