import 'package:flutter/material.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/pages/chat.dart';

class ChatListScreen extends StatefulWidget {
  final Map<String, dynamic> currentUser;

  const ChatListScreen({super.key, required this.currentUser});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<dynamic> _conversations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await AuthService.getConversations();
      if (!mounted) return;
      setState(() {
        _conversations = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3C24),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Mensajes', style: TextStyle(color: Colors.white)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
          ? const Center(
              child: Text(
                'Aún no tienes conversaciones.\nBusca a alguien para empezar a chatear.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                itemCount: _conversations.length,
                itemBuilder: (context, index) {
                  final c = _conversations[index];
                  final user = c['user'];
                  final lastMessage = c['last_message'];
                  final unreadCount = c['unread_count'] ?? 0;
                  final photoPath = user?['profile_photo'];

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFEFEFEF),
                      backgroundImage: photoPath != null
                          ? NetworkImage(
                              '${AuthService.storageUrl}/$photoPath',
                            )
                          : null,
                      child: photoPath == null
                          ? const Icon(Icons.person, color: Color(0xFF488C61))
                          : null,
                    ),
                    title: Text(
                      user?['name'] ?? 'Usuario',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      lastMessage?['body'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: unreadCount > 0
                        ? CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          )
                        : null,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            otherUser: user,
                            currentUser: widget.currentUser,
                          ),
                        ),
                      );
                      _load();
                    },
                  );
                },
              ),
            ),
    );
  }
}
