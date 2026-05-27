import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                  const SizedBox(width: 12),
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

            // 2. CONTENIDO DEL PERFIL (Scrollable)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Tarjeta de información del Usuario
                  const UserInfoCard(),
                  
                  const SizedBox(height: 12),

                  // Lista de publicaciones (Simulación basándonos en image_661c0a.png)
                  const UserPostCard(hasImage: true),
                  const UserPostCard(hasImage: false),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // 3. BARRA DE NAVEGACIÓN INFERIOR (Custom Bottom Bar)
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
                    'assets/Iconos_movil/Estadias.png',
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
                  // Icono Usuario / Perfil (Seleccionado / Activo en blanco como la captura)
                  Image.asset(
                    'assets/Iconos_movil/usuario seleccionado.png',
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

// =========================================================================
// WIDGET: TARJETA DE INFORMACIÓN DE USUARIO
// =========================================================================
class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9), // Fondo gris claro de las tarjetas
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono de perfil e información
              const Icon(Icons.person, color: Colors.black, size: 36),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    'Carrer',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
              const Spacer(),
              // Iconos de la derecha: Editar y Cerrar Sesión
              Row(
                children: [
                  Image.asset(
                    'assets/Iconos compartidos/editar.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.edit, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/Iconos_movil/Cerrar sesion.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.logout, color: Colors.black),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// =========================================================================
// WIDGET: TARJETA DE PUBLICACIONES DEL USUARIO
// =========================================================================
class UserPostCard extends StatelessWidget {
  final bool hasImage;

  const UserPostCard({super.key, required this.hasImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9), // Fondo gris claro
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado del Post: Info de usuario y botón borrar
          Row(
            children: [
              const Icon(Icons.person, color: Colors.black, size: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Name',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    'Date',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const Spacer(),
              // Icono de basura para eliminar publicación
              Image.asset(
                'assets/Iconos compartidos/basura.png',
                height: 24,
                width: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.delete, color: Colors.black),
              ),
            ],
          ),
          
          const SizedBox(height: 14),
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 12),

          // Renderizar el recuadro blanco de imagen solo si corresponde
          if (hasImage) ...[
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 64,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Fila de puntuación de estrellas
            Row(
              children: [
                Image.asset(
                  'assets/Iconos compartidos/estrella.png',
                  height: 24,
                  width: 24,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.star_border, color: Colors.black),
                ),
                const SizedBox(width: 8),
                const Text(
                  '0',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}