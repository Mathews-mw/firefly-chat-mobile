class ReadReceipt {
  final String messageId;
  final String userId;
  final DateTime readAt;

  const ReadReceipt({
    required this.messageId,
    required this.userId,
    required this.readAt,
  });

  set messageId(String messageId) {
    this.messageId = messageId;
  }

  set userId(String userId) {
    this.userId = userId;
  }

  set readAt(DateTime readAt) {
    this.readAt = readAt;
  }

  factory ReadReceipt.fromJson(Map<String, dynamic> json) {
    final readReceipt = ReadReceipt(
      messageId: json['message_id'],
      userId: json['user_id'],
      readAt: DateTime.parse(json['read_at']),
    );

    return readReceipt;
  }

  @override
  String toString() {
    return 'ReadReceipt(messageId: $messageId, userId: $userId, readAt: $readAt)';
  }
}
