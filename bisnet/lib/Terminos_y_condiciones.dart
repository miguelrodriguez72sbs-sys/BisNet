import 'package:flutter/material.dart';
// NUEVA PANTALLA: TÉRMINOS Y CONDICIONES 

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B962D), 
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 320, 
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F4), 
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Imagen del Búho desde carpeta assets
                  Image.asset(
                    'assets/Lechuzas/Lechuza_1.png',
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 120,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Título
                  const Text(
                    'Terms and conditions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Texto descriptivo 
                  const Text(
                    'Fostering a positive, inclusive, and safe environment.\n\n'
                    'We develop and use tools, and provide resources to our community members that help them have positive and inclusive experiences, even when we believe they may need help. We also have teams and systems dedicated to combating abuse and violations of our Terms and policies, as well as harmful and deceptive behavior. We use all the information we have, including yours, to try to keep our platform safe. We may also share information about misuse or harmful content with other Meta Companies or law enforcement.\n\n'
                    'Learn more in the Privacy Policy.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1C1B1F),
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botón Accept
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Al presionar aceptar, cierra esta pantalla y regresa al Login
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A8E25), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50), 
                        ),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
