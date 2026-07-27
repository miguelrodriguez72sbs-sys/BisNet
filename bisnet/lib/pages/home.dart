import 'package:flutter/material.dart';
import 'package:bisnet/widgets/search_bar.dart';
import 'package:bisnet/widgets/notifications_bell.dart';
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

  List<Widget> get _pages => [
    const HomeFeedScreen(),
    EstadiasScreen(isGuest: widget.isGuest),
    const PostScreen(),
    GamesScreen(isGuest: widget.isGuest),
    ProfileScreen(isGuest: widget.isGuest),
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        actions: [
          NotificationBell(notificationCount: 1, onPressed: () {}),
          CustomSearchBar(width: 150, onChanged: (value) {}),
          const SizedBox(width: 8),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF488C61),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (widget.isGuest && [1, 2, 3].contains(index)) {
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
