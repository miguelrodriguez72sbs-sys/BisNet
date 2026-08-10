import 'package:flutter/material.dart';
import 'package:bisnet/services/auth_service.dart';
import 'package:bisnet/L10n/app_localizations.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
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

  Future<void> _markAllRead() async {
    try {
      await AuthService.markAllNotificationsRead();
      await _loadNotifications();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.error)));
    }
  }

  Future<void> _markRead(int index) async {
    final notification = _notifications[index];
    if (notification['read_at'] != null) return;

    setState(() {
      _notifications[index]['read_at'] = DateTime.now().toIso8601String();
    });

    try {
      await AuthService.markNotificationRead(notification['id']);
    } catch (e) {
      // si falla, se vuelve a marcar como no leída
      if (!mounted) return;
      setState(() {
        _notifications[index]['read_at'] = null;
      });
    }
  }

  bool get _hasUnread =>
      _notifications.any((notification) => notification['read_at'] == null);

  AppLocalizations get t => AppLocalizations.of(context)!;

  String _relativeTime(String? iso) {
    if (iso == null) return '';
    try {
      final created = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(created);
      if (diff.inMinutes < 1) return t.justNow;
      if (diff.inHours < 1) return '${diff.inMinutes} ${t.minAgo}';
      if (diff.inDays < 1) return '${diff.inHours} ${t.hoursAgo}';
      if (diff.inDays < 7) return '${diff.inDays} ${t.daysAgo}';
      return '${created.day}/${created.month}/${created.year}';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D3C24),
        title: Text(
          t.notifications,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: t.markAllRead,
            icon: const Icon(Icons.done_all, color: Colors.white),
            onPressed: _hasUnread ? _markAllRead : null,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? Center(
              child: Text(
                t.noNotifications,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadNotifications,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  final isUnread = notification['read_at'] == null;
                  return _NotificationTile(
                    notification: notification,
                    isUnread: isUnread,
                    relativeTime: _relativeTime(notification['created_at']),
                    onTap: () => _markRead(index),
                  );
                },
              ),
            ),
    );
  }
}

// =========================================================================
// WIDGET: TARJETA DE NOTIFICACIÓN
// =========================================================================
class _NotificationTile extends StatelessWidget {
  final Map<String, dynamic> notification;
  final bool isUnread;
  final String relativeTime;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.isUnread,
    required this.relativeTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final fromUser = notification['from_user'] as Map<String, dynamic>?;
    final fromName = fromUser?['name'] ?? '';
    final type = notification['type'] ?? '';
    final data = notification['data'];
    final preview = data is Map
        ? (data['preview'] ?? data['message'] ?? '').toString()
        : '';

    final IconData icon;
    final String actionText;
    switch (type) {
      case 'like':
        icon = Icons.star;
        actionText = t.likedYourPost;
        break;
      case 'message':
        icon = Icons.chat_bubble;
        actionText = t.sentYouAMessage;
        break;
      default:
        icon = Icons.notifications;
        actionText = '';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isUnread ? const Color(0xFFE7EFD8) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF488C61),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$fromName $actionText',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isUnread
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (preview.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  relativeTime,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                if (isUnread) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF488C61),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
