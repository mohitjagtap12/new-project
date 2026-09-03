import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/notification.dart';
import '../../../widgets/empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  final List<AgroNotification> notifications;

  const NotificationsScreen({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<AgroNotification> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.notifications);
  }

  void _markAllAsRead() {
    setState(() {
      _items = _items.map((n) => n.copyWith(isRead: true)).toList();
    });
    AppUtils.showSnackBar(context, 'All marked as read');
  }

  void _clearAll() {
    setState(() {
      _items.clear();
    });
    AppUtils.showSnackBar(context, 'Notifications cleared');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_items.isNotEmpty) ...[
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark Read', style: TextStyle(fontWeight: FontWeight.bold, color: AgroColors.primary)),
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
              tooltip: 'Clear',
              onPressed: _clearAll,
            ),
          ],
        ],
      ),
      body: _items.isEmpty
          ? const EmptyStateWidget(
              title: 'No new notifications.',
              description: 'You are all caught up! Updates on crops, labour, and market orders will arrive here.',
              icon: Icons.notifications_none,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: item.isRead ? Colors.white : const Color(0xFFF1F8E9),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    leading: CircleAvatar(
                      backgroundColor: item.isRead ? AgroColors.surfaceVariant : AgroColors.primaryContainer,
                      child: Icon(
                        _getIcon(item.title),
                        color: item.isRead ? AgroColors.textMuted : AgroColors.primary,
                        size: 22,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                              color: AgroColors.textDark,
                            ),
                          ),
                        ),
                        Text(item.time, style: const TextStyle(fontSize: 12, color: AgroColors.textLight)),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        item.message,
                        style: const TextStyle(fontSize: 13, color: AgroColors.textMuted, height: 1.3),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _items[index] = item.copyWith(isRead: true);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }

  IconData _getIcon(String title) {
    if (title.contains('Labour')) return Icons.people;
    if (title.contains('Buyer')) return Icons.storefront;
    if (title.contains('Order')) return Icons.local_shipping;
    return Icons.notifications;
  }
}
