import 'package:flutter/material.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/services/pusher_service.dart';
import 'package:bisnet/pages/chat.dart';

class NotificationsScreen extends StatefulWidget {
  final Map<String, dynamic> currentUser;

  const NotificationsScreen({super.key, required this.currentUser});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    _subscribeRealtime();
  }

  Future<void> _load() async {
    try {
      final data = await AuthService.getNotifications();
      if (!mounted) return;
      setState(() {
        _notifications = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _subscribeRealtime() async {
    final myId = widget.currentUser['id'];
    if (myId == null) return;

    await PusherService.instance.subscribeToNotifications(
      userId: myId,
      onNotification: (data) {
        if (!mounted) return;
        setState(() {
          _notifications.insert(0, data);
        });
      },
    );
  }

  Future<void> _markAllRead() async {
    await AuthService.markAllNotificationsRead();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3C24),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: const Text(
              'Marcar todas',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? const Center(
              child: Text(
                'No tienes notificaciones',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final n = _notifications[index];
                  return _NotificationTile(
                    notification: n,
                    currentUserId: widget.currentUser['id'],
                    onTap: () async {
                      if (n['id'] != null) {
                        await AuthService.markNotificationRead(n['id']);
                      }
                      if (n['type'] == 'message' &&
                          n['from_user'] != null &&
                          context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              otherUser: n['from_user'],
                              currentUser: widget.currentUser,
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;
  final int? currentUserId;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final type = notification['type'];
    final fromUser = notification['from_user'];
    final data = notification['data'] ?? {};
    final isUnread = notification['read_at'] == null;

    String text;
    IconData icon;
    if (type == 'like') {
      text =
          '${fromUser?['name'] ?? 'Alguien'} le dio like a tu publicación "${data['post_title'] ?? ''}"';
      icon = Icons.star;
    } else {
      text =
          '${fromUser?['name'] ?? 'Alguien'} te envió un mensaje: "${data['preview'] ?? ''}"';
      icon = Icons.chat_bubble;
    }

    return Container(
      color: isUnread ? const Color(0xFFE9F4EC) : Colors.white,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF488C61)),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}
