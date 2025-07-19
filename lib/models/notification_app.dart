import 'package:firefly_chat_mobile/@types/notification_type.dart';

class NotificationApp {
  final String id;
  final String recipientId;
  final NotificationType type;
  final NotificationData data;
  final bool isRead;
  final DateTime createdAt;

  NotificationApp({
    required this.id,
    required this.recipientId,
    required this.type,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

  NotificationApp copyWith({
    String? id,
    String? recipientId,
    NotificationType? type,
    NotificationData? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationApp(
      id: id ?? this.id,
      recipientId: recipientId ?? this.recipientId,
      type: type ?? this.type,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  set id(String id) {
    this.id = id;
  }

  set recipientId(String recipientId) {
    this.recipientId = recipientId;
  }

  set type(NotificationType type) {
    this.type = type;
  }

  set data(NotificationData data) {
    this.data = data;
  }

  set isRead(bool isRead) {
    this.isRead = isRead;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  factory NotificationApp.fromJson(Map<String, dynamic> json) {
    final notification = NotificationApp(
      id: json['id'],
      recipientId: json['recipient_id'],
      type: NotificationType.values.firstWhere(
        (e) => e.value == json['notification_type']['key'],
        orElse: () => NotificationType.others,
      ),
      data: NotificationData.fromJson(json['data']),
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );

    return notification;
  }

  @override
  String toString() {
    return 'Notification(id: $id, recipientId: $recipientId, type: $type, data: $data, isRead: $isRead, createdAt: $createdAt)';
  }
}

class NotificationData {
  final String title;
  final String content;
  final dynamic metadata;

  NotificationData({required this.title, required this.content, this.metadata});

  set title(String title) {
    this.title = title;
  }

  set content(String content) {
    this.content = content;
  }

  set metadata(dynamic metadata) {
    this.metadata = metadata;
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    final data = NotificationData(
      title: json['title'],
      content: json['content'],
      metadata: json['metadata'],
    );

    return data;
  }

  @override
  String toString() {
    return 'NotificationData(title: $title, content: $content, metadata: $metadata)';
  }
}
