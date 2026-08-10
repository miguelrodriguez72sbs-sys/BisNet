import 'package:flutter/material.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/pages/communities.dart';

class HomeFeedScreen extends StatefulWidget {
  final bool isGuest;
  const HomeFeedScreen({super.key, this.isGuest = false});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  List<dynamic> _posts = [];
  bool _loading = true;
  Map<String, dynamic>? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final posts = await AuthService.getPosts();
      final user = await AuthService.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _posts = posts;
        _currentUser = user;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Widget? _buildFAB(BuildContext context) {
    if (widget.isGuest) return null; // los invitados solo ven publicaciones

    return FloatingActionButton(
      backgroundColor: const Color(0xFF488C61),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ComunidadesScreen()),
        );
      },
      child: const Icon(Icons.group, color: Colors.white, size: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: _posts.isEmpty
          ? const Center(
              child: Text(
                'No hay publicaciones aún',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return PostCard(
                    post: post,
                    currentUser: _currentUser,
                    isGuest: widget.isGuest,
                    onDelete: () async {
                      await AuthService.deletePost(post['id']);
                      _loadData();
                    },
                  );
                },
              ),
            ),
    );
  }
}

// =========================================================================
// WIDGET: TARJETA DE PUBLICACIÓN
// =========================================================================
class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final Map<String, dynamic>? currentUser;
  final VoidCallback onDelete;
  final bool isGuest;

  const PostCard({
    super.key,
    required this.post,
    required this.onDelete,
    this.currentUser,
    this.isGuest = false,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _likedByMe = false;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _likedByMe = widget.post['liked_by_me'] == true;
    _likesCount = (widget.post['likes_count'] is int)
        ? widget.post['likes_count']
        : 0;
  }

  Future<void> _handleLike() async {
    setState(() {
      _likedByMe = !_likedByMe;
      _likesCount += _likedByMe ? 1 : -1;
    });

    try {
      final response = await AuthService.toggleLike(widget.post['id']);
      if (!mounted) return;
      setState(() {
        _likedByMe = response['liked'] == true;
        _likesCount = (response['likes_count'] is int)
            ? response['likes_count']
            : _likesCount;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _likedByMe = !_likedByMe;
        _likesCount += _likedByMe ? 1 : -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final currentUser = widget.currentUser;

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
          Row(
            children: [
              const Icon(Icons.person, color: Colors.black, size: 32),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['user']?['name'] ?? 'Usuario',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      post['created_at']?.substring(0, 10) ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (currentUser != null && post['user_id'] == currentUser['id'])
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
                    if (confirm == true) widget.onDelete();
                  },
                  child: Image.asset(
                    'assets/Iconos compartidos/basura.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.delete, color: Colors.black),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            post['title'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            post['description'] ?? '',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),

          const SizedBox(height: 12),

          if (post['media_path'] != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                '${AuthService.storageUrl}/${post['media_path']}',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  size: 64,
                  color: Colors.grey,
                ),
              ),
            ),

          const SizedBox(height: 12),

          GestureDetector(
            onTap: widget.isGuest ? null : _handleLike,
            child: Row(
              children: [
                Icon(
                  _likedByMe ? Icons.star : Icons.star_border,
                  color: _likedByMe ? Colors.amber : Colors.black,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '$_likesCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
