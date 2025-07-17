class Friendship {
  final String id;
  final String userId;
  final String friendId;
  final DateTime createdAt;

  const Friendship({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.createdAt,
  });

  set id(String id) {
    this.id = id;
  }

  set userId(String userId) {
    this.userId = userId;
  }

  set friendId(String friendId) {
    this.friendId = friendId;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  factory Friendship.fromJson(Map<String, dynamic> json) {
    final friendship = Friendship(
      id: json['id'],
      userId: json['user_id'],
      friendId: json['friend_id'],
      createdAt: DateTime.parse(json['created_at']),
    );

    return friendship;
  }

  @override
  String toString() {
    return 'Friendship(id: $id, userId: $userId, friendId: $friendId, createdAt: $createdAt)';
  }
}
