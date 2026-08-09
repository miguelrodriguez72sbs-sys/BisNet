import 'package:flutter/material.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/pages/chat.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;
  final Map<String, dynamic>? currentUser;

  const SearchResultsScreen({super.key, required this.query, this.currentUser});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _controller;
  bool _loading = true;
  String? _error;
  List<dynamic> _users = [];
  List<dynamic> _posts = [];
  List<dynamic> _estadias = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
    _runSearch(widget.query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _users = [];
        _posts = [];
        _estadias = [];
        _loading = false;
        _error = null;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await AuthService.search(query);
      if (!mounted) return;
      setState(() {
        _users = result['users'] ?? [];
        _posts = result['posts'] ?? [];
        _estadias = result['estadias'] ?? [];
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo realizar la búsqueda';
        _loading = false;
      });
    }
  }

  bool get _hasNoResults =>
      _users.isEmpty && _posts.isEmpty && _estadias.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3C24),
        iconTheme: const IconThemeData(color: Colors.white),
        title: TextField(
          controller: _controller,
          autofocus: widget.query.isEmpty,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Buscar usuarios, posts, estadías...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onSubmitted: _runSearch,
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _hasNoResults
          ? const Center(
              child: Text(
                'Sin resultados',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_users.isNotEmpty) ...[
                  _SectionTitle('Usuarios'),
                  ..._users.map(
                    (u) => _UserResultTile(
                      user: u,
                      currentUser: widget.currentUser,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_posts.isNotEmpty) ...[
                  _SectionTitle('Publicaciones'),
                  ..._posts.map((p) => _PostResultTile(post: p)),
                  const SizedBox(height: 16),
                ],
                if (_estadias.isNotEmpty) ...[
                  _SectionTitle('Estadías'),
                  ..._estadias.map((e) => _EstadiaResultTile(estadia: e)),
                ],
              ],
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0D3C24),
        ),
      ),
    );
  }
}

class _UserResultTile extends StatelessWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic>? currentUser;
  const _UserResultTile({required this.user, this.currentUser});

  @override
  Widget build(BuildContext context) {
    final photoPath = user['profile_photo'];
    final isMe = currentUser != null && user['id'] == currentUser!['id'];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEFEFEF),
          backgroundImage: photoPath != null
              ? NetworkImage('${AuthService.storageUrl}/$photoPath')
              : null,
          child: photoPath == null
              ? const Icon(Icons.person, color: Color(0xFF488C61))
              : null,
        ),
        title: Text(user['name'] ?? ''),
        subtitle: Text(user['career'] ?? ''),
        trailing: (currentUser != null && !isMe)
            ? const Icon(Icons.chat_bubble_outline, color: Color(0xFF488C61))
            : null,
        onTap: (currentUser != null && !isMe)
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ChatScreen(otherUser: user, currentUser: currentUser!),
                  ),
                );
              }
            : null,
      ),
    );
  }
}

class _PostResultTile extends StatelessWidget {
  final Map<String, dynamic> post;
  const _PostResultTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.article_outlined, color: Color(0xFF488C61)),
        title: Text(
          post['title'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          post['description'] ?? '',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '${post['likes_count'] ?? 0} ❤',
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}

class _EstadiaResultTile extends StatelessWidget {
  final Map<String, dynamic> estadia;
  const _EstadiaResultTile({required this.estadia});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.apartment, color: Color(0xFF488C61)),
        title: Text(estadia['empresa'] ?? ''),
        subtitle: Text(estadia['giro'] ?? ''),
      ),
    );
  }
}
