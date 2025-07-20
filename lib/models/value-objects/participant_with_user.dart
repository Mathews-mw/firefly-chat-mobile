import 'package:firefly_chat_mobile/models/user.dart';

class ParticipantWithUser {
  final String id;
  final String roomId;
  final String userId;
  final User user;

  const ParticipantWithUser({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.user,
  });

  factory ParticipantWithUser.fromJson(Map<String, dynamic> json) {
    final participantWithUser = ParticipantWithUser(
      id: json['id'],
      roomId: json['room_id'],
      userId: json['user_id'],
      user: User.fromJson(json['user']),
    );

    return participantWithUser;
  }
}
