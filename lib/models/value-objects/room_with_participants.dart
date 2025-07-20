import 'package:firefly_chat_mobile/@types/room_type.dart';
import 'package:firefly_chat_mobile/models/chat_message.dart';
import 'package:firefly_chat_mobile/models/value-objects/participant_with_user.dart';

class RoomWithParticipants {
  final String id;
  final RoomType type;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? ownerId;
  final DateTime createdAt;
  final List<ParticipantWithUser> participants;
  final List<ChatMessage> chatMessages;

  const RoomWithParticipants({
    required this.id,
    required this.type,
    this.name,
    this.description,
    this.imageUrl,
    this.ownerId,
    required this.createdAt,
    required this.participants,
    required this.chatMessages,
  });

  factory RoomWithParticipants.fromJson(Map<String, dynamic> json) {
    final roomWithParticipants = RoomWithParticipants(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'],
      ownerId: json['owner_id'],
      type: RoomType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => RoomType.private,
      ),
      createdAt: DateTime.parse(json['created_at']),
      participants: (json['participants'] as List)
          .map((participant) => ParticipantWithUser.fromJson(participant))
          .toList(),
      chatMessages: (json['chat_messages'] as List)
          .map((message) => ChatMessage.fromJson(message))
          .toList(),
    );

    return roomWithParticipants;
  }
}
