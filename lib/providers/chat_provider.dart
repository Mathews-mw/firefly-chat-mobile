import 'package:flutter/material.dart';

import 'package:firefly_chat_mobile/services/http_service.dart';
import 'package:firefly_chat_mobile/models/value-objects/room_with_participants.dart';

class ChatProvider with ChangeNotifier {
  final HttpService _httpService = HttpService();

  Future<List<RoomWithParticipants>> fetchUserRooms({
    String? type,
    String? name,
  }) async {
    try {
      String uri = 'chat/room/user';

      if (type != null) {
        uri = '$uri?type=$type';
      }

      print('uri: $uri');

      final response = await _httpService.get(endpoint: uri);

      final userRooms = (response as List)
          .map((item) => RoomWithParticipants.fromJson(item))
          .toList();

      return userRooms;
    } catch (e) {
      rethrow;
    }
  }
}
