class ChatMessage {
  final String id;
  final String senderId;
  final String content;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.isDeleted,
    required this.createdAt,
    this.updatedAt,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? content,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  set id(String id) {
    this.id = id;
  }

  set senderId(String senderId) {
    this.senderId = senderId;
  }

  set content(String content) {
    this.content = content;
  }

  set isDeleted(bool isDeleted) {
    this.isDeleted = isDeleted;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  set updatedAt(DateTime? updatedAt) {
    this.updatedAt = updatedAt;
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final user = ChatMessage(
      id: json['id'],
      senderId: json['sender_id'],
      content: json['content'],
      isDeleted: json['is_deleted'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['replied_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );

    return user;
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, senderId: $senderId, content: $content, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
