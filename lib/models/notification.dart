class AgroNotification {
  final String id;
  final String title;
  final String message;
  final String time;
  final String type; // 'order', 'market', 'labour', 'contract'
  bool isRead;

  AgroNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}
