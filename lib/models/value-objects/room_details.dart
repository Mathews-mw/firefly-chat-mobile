import 'package:firefly_chat_mobile/@types/room_type.dart';
import 'package:firefly_chat_mobile/models/attachment.dart';
import 'package:firefly_chat_mobile/models/value-objects/participant_with_user.dart';

class RoomDetails {
  final String id;
  final RoomType type;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? ownerId;
  final DateTime createdAt;
  final List<ParticipantWithUser> participants;
  final List<Attachment> attachments;

  const RoomDetails({
    required this.id,
    required this.type,
    this.name,
    this.description,
    this.imageUrl,
    this.ownerId,
    required this.createdAt,
    required this.participants,
    required this.attachments,
  });

  factory RoomDetails.fromJson(Map<String, dynamic> json) {
    final room = RoomDetails(
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
      attachments: (json['attachments'] as List)
          .map((attachment) => Attachment.fromJson(attachment))
          .toList(),
    );

    return room;
  }
}
