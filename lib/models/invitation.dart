class Invitation {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;
  final DateTime? repliedAt;
  final DateTime createdAt;

  const Invitation({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    this.repliedAt,
    required this.createdAt,
  });

  set id(String id) {
    this.id = id;
  }

  set senderId(String senderId) {
    this.senderId = senderId;
  }

  set receiverId(String receiverId) {
    this.receiverId = receiverId;
  }

  set status(String status) {
    this.status = status;
  }

  set repliedAt(DateTime? repliedAt) {
    this.repliedAt = repliedAt;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  factory Invitation.fromJson(Map<String, dynamic> json) {
    final user = Invitation(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      status: json['status'],
      repliedAt: json['replied_at'] != null
          ? DateTime.parse(json['replied_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );

    return user;
  }

  @override
  String toString() {
    return 'Invitation(id: $id, senderId: $senderId, receiverId: $receiverId, status: $status, repliedAt: $repliedAt, createdAt: $createdAt)';
  }
}
