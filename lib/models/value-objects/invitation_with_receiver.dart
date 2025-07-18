import 'package:firefly_chat_mobile/models/user.dart';

class InvitationWithReceiver {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;
  final DateTime? repliedAt;
  final DateTime createdAt;
  final User receiver;

  const InvitationWithReceiver({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    this.repliedAt,
    required this.createdAt,
    required this.receiver,
  });

  factory InvitationWithReceiver.fromJson(Map<String, dynamic> json) {
    final user = InvitationWithReceiver(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      status: json['status'],
      repliedAt: json['replied_at'] != null
          ? DateTime.parse(json['replied_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      receiver: User.fromJson(json['receiver']),
    );

    return user;
  }
}
