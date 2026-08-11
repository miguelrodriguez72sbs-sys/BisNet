import 'package:flutter/material.dart';
import 'package:bisnet/pages/login.dart';
import 'package:bisnet/main.dart';

class TraductorScreen extends StatefulWidget {
  const TraductorScreen({super.key});

  @override
  State<TraductorScreen> createState() => _TraductorScreenState();
}

class _TraductorScreenState extends State<TraductorScreen> {
  void _selectLanguage(Locale locale) {
    MyApp.of(context)?.setLocale(locale);
    // Si se abre desde otra pantalla (login / editar perfil), vuelve a ella.
    // En el primer arranque no hay pantalla previa, así que va al login.
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

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

      body: LayoutBuilder(
        builder: (context, constraints) {
          // ============================================================
          // DISEÑO PARA PANTALLAS GRANDES (PC / WEB)
          // ============================================================

          if (constraints.maxWidth >= 800) {
            return Row(
              children: [
                // ------------------------------------------------------
                // SECCIÓN DE IDIOMAS
                // ------------------------------------------------------
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Choose your language',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ------------------------------------------------
                          // BANDERA MÉXICO
                          // ------------------------------------------------
                          Image.asset(
                            'assets/Iconos_movil/BanderaMexico.png',
                            width: 80,
                            height: 50,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(height: 16),

                          // ------------------------------------------------
                          // BOTÓN ESPAÑOL
                          // ------------------------------------------------
                          ElevatedButton(
                            onPressed: () {
                              _selectLanguage(const Locale('es'));
                            },
                            child: const Text('Español'),
                          ),

                          const SizedBox(height: 20),

                          // ------------------------------------------------
                          // BANDERA USA
                          // ------------------------------------------------
                          Image.asset(
                            'assets/Iconos_movil/BanderaUSA.png',
                            width: 80,
                            height: 50,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(height: 16),

                          // ------------------------------------------------
                          // BOTÓN ENGLISH
                          // ------------------------------------------------
                          ElevatedButton(
                            onPressed: () {
                              _selectLanguage(const Locale('en'));
                            },
                            child: const Text('English'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // --------------------------------------------------------
                // SECCIÓN DE LA LECHUZA
                // --------------------------------------------------------
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/Lechuzas/Lechuza_3.png',
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            );
          }

          // ============================================================
          // DISEÑO PARA CELULAR / TABLET
          // ============================================================

          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Choose your language',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --------------------------------------------------
                    // BANDERA MÉXICO
                    // --------------------------------------------------
                    Image.asset(
                      'assets/Iconos_movil/BanderaMexico.png',
                      width: 70,
                      height: 45,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 10),

                    // --------------------------------------------------
                    // BOTÓN ESPAÑOL
                    // --------------------------------------------------
                    ElevatedButton(
                      onPressed: () {
                        _selectLanguage(const Locale('es'));
                      },
                      child: const Text('Español'),
                    ),

                    const SizedBox(height: 20),

                    // --------------------------------------------------
                    // BANDERA USA
                    // --------------------------------------------------
                    Image.asset(
                      'assets/Iconos_movil/BanderaUSA.png',
                      width: 70,
                      height: 45,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 10),

                    // --------------------------------------------------
                    // BOTÓN ENGLISH
                    // --------------------------------------------------
                    ElevatedButton(
                      onPressed: () {
                        _selectLanguage(const Locale('en'));
                      },
                      child: const Text('English'),
                    ),

                    const SizedBox(height: 32),

                    // --------------------------------------------------
                    // LECHUZA
                    // --------------------------------------------------
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
        },
      ),
    );
  }
}
