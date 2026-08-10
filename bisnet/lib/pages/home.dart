import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bisnet/widgets/search_bar.dart';
import 'package:bisnet/widgets/notifications_bell.dart';
import 'package:bisnet/pages/notifications.dart';
import 'package:bisnet/pages/post.dart';
import 'package:bisnet/pages/games.dart';
import 'package:bisnet/pages/profile.dart';
import 'package:bisnet/pages/estadias.dart';
import 'package:bisnet/pages/home_feed.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/L10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;
  const HomeScreen({super.key, this.isGuest = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _searchQuery = '';
  int _notificationCount = 0;
  Timer? _notificationTimer;

  @override
  void initState() {
    super.initState();
    _loadNotificationCount();
    // Refresca el conteo cada 20s para recibir nuevas notificaciones
    _notificationTimer = Timer.periodic(
      const Duration(seconds: 20),
      (_) => _loadNotificationCount(),
    );
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadNotificationCount() async {
    if (widget.isGuest) return;
    try {
      final count = await AuthService.getUnreadNotificationsCount();
      if (!mounted) return;
      setState(() => _notificationCount = count);
    } catch (e) {
      // sin conexión o sesión expirada: se mantiene el conteo anterior
    }
  }

  Future<void> _openNotifications() async {
    final t = AppLocalizations.of(context)!;
    if (widget.isGuest) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.loginRequired)));
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
    _loadNotificationCount();
  }

  List<Widget> get _pages => [
    HomeFeedScreen(isGuest: widget.isGuest, searchQuery: _searchQuery),
    EstadiasScreen(isGuest: widget.isGuest),
    const PostScreen(),
    GamesScreen(isGuest: widget.isGuest),
    ProfileScreen(isGuest: widget.isGuest),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0D3C24),
        titleSpacing: 8,
        title: Row(
          children: [
            Image.asset(
              'assets/Lechuzas/Logo.png',
              height: screenWidth < 360 ? 32 : 40, // logo se achica en pantallas pequeñas
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Bisnet',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        actions: [
          NotificationBell(
            notificationCount: widget.isGuest ? 0 : _notificationCount,
            onPressed: _openNotifications,
          ),
          CustomSearchBar(
            width: screenWidth * 0.35, // antes: 150 fijo
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF488C61),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (widget.isGuest && index != 0) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(t.loginRequired)));
            return;
          }

          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: t.home),
          BottomNavigationBarItem(
            icon: const Icon(Icons.apartment),
            label: t.stays,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_box),
            label: t.post,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.sports_esports),
            label: t.plays,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: t.profile,
          ),
        ],
      ),
    );
  }
}

