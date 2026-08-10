import 'package:flutter/material.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/services/realtime_service.dart';
import 'package:laravel_reverb/laravel_reverb.dart';

class CommunityDetailScreen extends StatefulWidget {
  final Map<String, dynamic> community;

  const CommunityDetailScreen({super.key, required this.community});

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _members = [];
  bool _loadingMembers = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMembers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    try {
      final data = await AuthService.getCommunityMembers(
        widget.community['id'],
      );
      if (!mounted) return;
      setState(() {
        _members = data;
        _loadingMembers = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingMembers = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final community = widget.community;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3C24),
        title: Text(
          community['name'] ?? 'Comunidad',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.chat), text: 'Chat'),
            Tab(icon: Icon(Icons.people), text: 'Miembros'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatTab(communityId: widget.community['id']),
          MembersTab(members: _members, loading: _loadingMembers),
        ],
      ),
    );
  }
}

// =========================================================================
// TAB: CHAT
// =========================================================================
class ChatTab extends StatefulWidget {
  final int communityId;
  const ChatTab({super.key, required this.communityId});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  List<dynamic> _messages = [];
  bool _loading = true;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? _currentUser;
  Subscription? _realtimeSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
    _initRealtime();
  }

  Future<void> _initRealtime() async {
    try {
      final reverb = await RealtimeService.instance.ensureConnected();
      if (!mounted) return;

      _realtimeSubscription = reverb
          .private('community.${widget.communityId}')
          .listen('.message.sent', _onNewMessage);
    } catch (e) {
      debugPrint('No se pudo conectar el chat en tiempo real: $e');
    }
  }

  void _onNewMessage(Map<String, dynamic> data) {
    if (!mounted) return;
    final alreadyExists = _messages.any((m) => m['id'] == data['id']);
    if (alreadyExists) return;

    setState(() => _messages.add(data));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _loadData() async {
    final user = await AuthService.getCurrentUser();
    if (!mounted) return;
    setState(() => _currentUser = user);
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final data = await AuthService.getCommunityMessages(widget.communityId);
      if (!mounted) return;
      setState(() {
        _messages = data;
        _loading = false;
      });
      // Scroll al final
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    try {
      await AuthService.sendCommunityMessage(
        communityId: widget.communityId,
        message: text,
      );
      _loadMessages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _realtimeSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? const Center(
                  child: Text(
                    'No hay mensajes aún',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isMe = msg['user_id'] == _currentUser?['id'];

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? const Color(0xFF488C61)
                              : const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (!isMe)
                              Text(
                                msg['user']?['name'] ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF488C61),
                                ),
                              ),
                            Text(
                              msg['message'] ?? '',
                              style: TextStyle(
                                color: isMe ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              msg['created_at']?.substring(11, 16) ?? '',
                              style: TextStyle(
                                fontSize: 10,
                                color: isMe ? Colors.white60 : Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF0F0F0),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF488C61),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// TAB: MIEMBROS
// =========================================================================
class MembersTab extends StatelessWidget {
  final List<dynamic> members;
  final bool loading;

  const MembersTab({super.key, required this.members, required this.loading});

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    if (members.isEmpty) {
      return const Center(
        child: Text('No hay miembros', style: TextStyle(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        final isAdmin = member['role'] == 'admin';

        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFF488C61),
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text(member['user']?['name'] ?? 'Usuario'),
          subtitle: Text(member['user']?['career'] ?? ''),
          trailing: isAdmin
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF488C61),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Admin',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                )
              : null,
        );
      },
    );
  }
}
