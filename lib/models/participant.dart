class Participant {
  final String id;
  final String roomId;
  final String userId;

  const Participant({
    required this.id,
    required this.roomId,
    required this.userId,
  });

  set id(String id) {
    this.id = id;
  }

  set roomId(String roomId) {
    this.roomId = roomId;
  }

  set userId(String userId) {
    this.userId = userId;
  }

  factory Participant.fromJson(Map<String, dynamic> json) {
    final participant = Participant(
      id: json['id'],
      roomId: json['room_id'],
      userId: json['user_id'],
    );

    return participant;
  }

  @override
  String toString() {
    return 'Participant(id: $id, roomId: $roomId, userId: $userId)';
  }
}
