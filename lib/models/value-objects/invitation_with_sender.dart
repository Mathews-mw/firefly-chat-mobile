import 'package:firefly_chat_mobile/models/user.dart';

class InvitationWithSender {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;
  final DateTime? repliedAt;
  final DateTime createdAt;
  final User sender;

  const InvitationWithSender({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    this.repliedAt,
    required this.createdAt,
    required this.sender,
  });

  factory InvitationWithSender.fromJson(Map<String, dynamic> json) {
    final user = InvitationWithSender(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      status: json['status'],
      repliedAt: json['replied_at'] != null
          ? DateTime.parse(json['replied_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      sender: User.fromJson(json['sender']),
    );

    return user;
  }
}
