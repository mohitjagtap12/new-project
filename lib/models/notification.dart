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

  AgroNotification copyWith({
    String? id,
    String? title,
    String? message,
    String? time,
    String? type,
    bool? isRead,
  }) {
    return AgroNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }
}
