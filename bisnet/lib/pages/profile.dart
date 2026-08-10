import 'package:flutter/material.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/pages/login.dart';
import 'package:bisnet/pages/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  final bool isGuest;
  const ProfileScreen({super.key, this.isGuest = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;
  List _posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data  = await AuthService.getProfile();
      final posts = await AuthService.getMyPosts();
      setState(() {
        _user    = data;
        _posts   = posts;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F4),
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar personalizada ──────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6B962D),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/Lechuzas/Logo.png',
                    height: 40,
                    width: 40,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.account_circle, color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 12),
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
                  Image.asset(
                    'assets/Iconos_movil/Notificacion.png',
                    height: 24,
                    width: 24,
                    color: Colors.white,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.notifications, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
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

            // ── Contenido scrollable ──────────────────────────────
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        UserInfoCard(user: _user),
                        const SizedBox(height: 12),
                        ..._posts.map(
                          (post) => UserPostCard(
                            post: post,
                            onDelete: () async {
                              await AuthService.deletePost(post['id']);
                              _loadData();
                            },
                          ),
                        ),
                        if (_posts.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                'You have not made any posts yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                      ],
                    ),
            ),

            // ── Barra de navegación inferior ──────────────────────
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF6B962D),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('assets/Iconos_movil/home.png',
                      height: 32, width: 32, color: Colors.white,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.home, color: Colors.white, size: 32)),
                  Image.asset('assets/Iconos_movil/Estadias.png',
                      height: 32, width: 32, color: Colors.white,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.business, color: Colors.white, size: 32)),
                  Image.asset('assets/Iconos_movil/Publicar.png',
                      height: 32, width: 32, color: Colors.white,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.add_circle_outline, color: Colors.white, size: 32)),
                  Image.asset('assets/Iconos_movil/Juegos.png',
                      height: 32, width: 32, color: Colors.white,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.sports_esports, color: Colors.white, size: 32)),
                  Image.asset('assets/Iconos_movil/usuario seleccionado.png',
                      height: 32, width: 32, color: Colors.white,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, color: Colors.white, size: 32)),
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
// WIDGET: AVATAR DE PERFIL (con foto real o ícono por defecto)
// =========================================================================
class _ProfileAvatar extends StatelessWidget {
  final String? photoPath;

  const _ProfileAvatar({required this.photoPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: photoPath != null
            ? Image.network(
                '${AuthService.storageUrl}/$photoPath',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, color: Colors.black, size: 36),
              )
            : const Icon(Icons.person, color: Colors.black, size: 36),
      ),
    );
  }
}

// =========================================================================
// WIDGET: TARJETA DE INFORMACIÓN DE USUARIO
// =========================================================================
class UserInfoCard extends StatelessWidget {
  final Map<String, dynamic>? user;

  const UserInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileAvatar(photoPath: user?['profile_photo']),
              const SizedBox(width: 8),
              // ── Mejora del Archivo 2: Flexible evita overflow en textos largos ──
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?['name'] ?? 'Name',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      user?['career'] ?? 'Career',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final updatedUser = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(user: user),
                        ),
                      );
                      if (updatedUser != null) {
                        (context as Element).markNeedsBuild();
                      }
                    },
                    child: Image.asset(
                      'assets/Iconos compartidos/editar.png',
                      height: 24,
                      width: 24,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.edit, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      await AuthService.deleteToken();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: Image.asset(
                      'assets/Iconos_movil/Cerrar sesion.png',
                      height: 24,
                      width: 24,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.logout, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user?['description'] ?? 'No description',
            style: const TextStyle(fontSize: 16, color: Colors.black),
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
  final Map<String, dynamic> post;
  final VoidCallback onDelete;

  const UserPostCard({super.key, required this.post, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Encabezado ────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.person, color: Colors.black, size: 32),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['user']?['name'] ?? 'Usuario',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    post['created_at']?.substring(0, 10) ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Post'),
                      content: const Text('Are you sure?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) onDelete();
                },
                child: Image.asset(
                  'assets/Iconos compartidos/basura.png',
                  height: 24,
                  width: 24,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.delete, color: Colors.black),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Título del post ───────────────────────────────────
          Text(
            post['title'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // ── Descripción ───────────────────────────────────────
          Text(
            post['description'] ?? '',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),

          // ── Imagen del post (si existe) ───────────────────────
          if (post['media_path'] != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '${AuthService.storageUrl}/${post['media_path']}',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 64,
                  color: Colors.grey,
                ),
              ),
            ),
          ],

          const SizedBox(height: 12),

          // ── Estrellas ─────────────────────────────────────────
          Row(
            children: [
              Image.asset(
                'assets/Iconos compartidos/estrella.png',
                height: 24,
                width: 24,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.star_border, color: Colors.black),
              ),
              const SizedBox(width: 8),
              const Text(
                '0',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}