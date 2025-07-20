import 'package:firefly_chat_mobile/@types/room_type.dart';

class Room {
  final String id;
  final RoomType type;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? ownerId;
  final DateTime createdAt;

  const Room({
    required this.id,
    required this.type,
    this.name,
    this.description,
    this.imageUrl,
    this.ownerId,
    required this.createdAt,
  });

  set id(String id) {
    this.id = id;
  }

  set type(RoomType type) {
    this.type = type;
  }

  set name(String? name) {
    this.name = name;
  }

  set description(String? description) {
    this.description = description;
  }

  set imageUrl(String? imageUrl) {
    this.imageUrl = imageUrl;
  }

  set ownerId(String? ownerId) {
    this.ownerId = ownerId;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    final room = Room(
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
    );

    return room;
  }

  @override
  String toString() {
    return 'Room(id: $id, type: $type, name: $name, description: $description, imageUrl: $imageUrl, ownerId: $ownerId, createdAt: $createdAt)';
  }
}
