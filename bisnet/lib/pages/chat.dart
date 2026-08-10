import 'package:flutter/material.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/services/pusher_service.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> otherUser;
  final Map<String, dynamic> currentUser;

  const ChatScreen({
    super.key,
    required this.otherUser,
    required this.currentUser,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _messages = [];
  bool _loading = true;
  bool _sending = false;

  int get _otherId => widget.otherUser['id'];
  int get _myId => widget.currentUser['id'];

  @override
  void initState() {
    super.initState();
    _load();
    _subscribeRealtime();
  }

  @override
  void dispose() {
    PusherService.instance.unsubscribeFromChat(myId: _myId, otherId: _otherId);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final data = await AuthService.getMessages(_otherId);
      if (!mounted) return;
      setState(() {
        _messages = data;
        _loading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _subscribeRealtime() async {
    await PusherService.instance.subscribeToChat(
      myId: _myId,
      otherId: _otherId,
      onMessage: (data) {
        if (!mounted) return;
        // Evita duplicar el mensaje que yo mismo acabo de enviar
        if (data['sender_id'] == _myId) return;
        setState(() {
          _messages.add(data);
        });
        _scrollToBottom();
      },
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    _controller.clear();

    // UI optimista
    final optimistic = {
      'sender_id': _myId,
      'receiver_id': _otherId,
      'body': text,
      'created_at': DateTime.now().toIso8601String(),
    };
    setState(() => _messages.add(optimistic));
    _scrollToBottom();

    try {
      await AuthService.sendMessage(_otherId, text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No se pudo enviar: $e')));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoPath = widget.otherUser['profile_photo'];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3C24),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              backgroundImage: photoPath != null
                  ? NetworkImage('${AuthService.storageUrl}/$photoPath')
                  : null,
              child: photoPath == null
                  ? const Icon(Icons.person, color: Color(0xFF488C61), size: 18)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              widget.otherUser['name'] ?? 'Usuario',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final m = _messages[index];
                      final isMine = m['sender_id'] == _myId;
                      return Align(
                        alignment: isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: isMine
                                ? const Color(0xFF488C61)
                                : const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            m['body'] ?? '',
                            style: TextStyle(
                              color: isMine ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF488C61),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _send,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
