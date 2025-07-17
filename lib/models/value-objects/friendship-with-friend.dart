import 'package:firefly_chat_mobile/models/user.dart';

class FriendshipWithFriend {
  final String id;
  final String userId;
  final String friendId;
  final DateTime createdAt;
  final User friend;

  const FriendshipWithFriend({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.createdAt,
    required this.friend,
  });

  factory FriendshipWithFriend.fromJson(Map<String, dynamic> json) {
    final friendshipWithFriend = FriendshipWithFriend(
      id: json['id'],
      userId: json['user_id'],
      friendId: json['friend_id'],
      createdAt: DateTime.parse(json['created_at']),
      friend: User.fromJson(json['friend']),
    );

    return friendshipWithFriend;
  }
}
