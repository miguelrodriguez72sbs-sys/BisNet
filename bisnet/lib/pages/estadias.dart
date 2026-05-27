import 'package:flutter/material.dart';

class EstadiasScreen extends StatelessWidget {
  const EstadiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo crema suave de la aplicación
      backgroundColor: const Color(0xFFF9F9F4),
      body: SafeArea(
        child: Column(
          children: [
            // 1. BARRA SUPERIOR (Custom AppBar)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6B962D), // Verde principal
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Mini logo de la lechuza
                  Image.asset(
                    'assets/Lechuzas/Logo.png',
                    height: 40,
                    width: 40,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_circle, color: Colors.white, size: 40),
                  ),
                  // Título de la app
                  const Text(
                    'BISNET',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  // Icono de Notificación
                  Image.asset(
                    'assets/Iconos_movil/Notificacion.png',
                    height: 24,
                    width: 24,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.notifications, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  // Barra de búsqueda simulada
                  Container(
                    width: 90,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: Icon(Icons.search, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. LISTA DE TARJETAS DE ESTADÍAS (Scrollable)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  EstadiaCard(),
                  EstadiaCard(),
                  EstadiaCard(),
                  SizedBox(height: 12), // Espacio al final de la lista
                ],
              ),
            ),

            // 3. BARRA DE NAVEGACIÓN INFERIOR (Custom Bottom Bar) - CORREGIDA
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF6B962D), // Verde principal
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Icono Home
                  Image.asset(
                    'assets/Iconos_movil/home.png',
                    height: 32,
                    width: 32,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.home, color: Colors.white, size: 32),
                  ),
                  // Icono Estadías
                  Image.asset(
                    'assets/Iconos_movil/Estadias seleccionadas.png',
                    height: 32,
                    width: 32,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, color: Colors.white, size: 32),
                  ),
                  // Icono Publicar (+)
                  Image.asset(
                    'assets/Iconos_movil/Publicar.png',
                    height: 32,
                    width: 32,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.add_circle_outline, color: Colors.white, size: 32),
                  ),
                  // Icono Juegos
                  Image.asset(
                    'assets/Iconos_movil/Juegos.png',
                    height: 32,
                    width: 32,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_esports, color: Colors.white, size: 32),
                  ),
                  // Icono Usuario / Perfil
                  Image.asset(
                    'assets/Iconos_movil/usuario.png',
                    height: 32,
                    width: 32,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget personalizado para las Tarjetas de Empresa
class EstadiaCard extends StatelessWidget {
  const EstadiaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9), // Gris claro del fondo de la tarjeta
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado: Icono de usuario y Nombre de la Empresa
          Row(
            children: [
              const Icon(Icons.person, color: Colors.black, size: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Company',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Carrer',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Etiqueta de Descripción
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          // Botón "See details"
          Center(
            child: SizedBox(
              width: 180,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Acción para ver detalles en el futuro
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B962D), // Verde oliva del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'See details',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
