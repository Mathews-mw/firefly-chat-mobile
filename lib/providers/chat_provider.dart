import 'package:firefly_chat_mobile/@exceptions/api_exceptions.dart';
import 'package:firefly_chat_mobile/models/value-objects/chat_message_with_author.dart';
import 'package:firefly_chat_mobile/providers/messages_provider.dart';
import 'package:flutter/material.dart';

import 'package:firefly_chat_mobile/@types/room_type.dart';
import 'package:firefly_chat_mobile/services/http_service.dart';
import 'package:firefly_chat_mobile/models/value-objects/room_with_participants.dart';

class ChatProvider with ChangeNotifier {
  final HttpService _httpService = HttpService();

  late MessagesProvider _messagesProvider;

  set messagesProvider(MessagesProvider provider) {
    _messagesProvider = provider;
  }

  RoomWithParticipants? _room;
  RoomWithParticipants? get room => _room;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  ApiExceptions? _apiExceptions;
  ApiExceptions? get apiExceptions => _apiExceptions;

  ({String? previousCursor, String? nextCursor, bool? stillHaveData}) _cursor =
      (previousCursor: null, nextCursor: null, stillHaveData: null);

  ({String? previousCursor, String? nextCursor, bool? stillHaveData})
  get cursor {
    return _cursor;
  }

  set cursor(
    ({String? previousCursor, String? nextCursor, bool? stillHaveData}) cursor,
  ) {
    _cursor = (
      previousCursor: cursor.previousCursor,
      nextCursor: cursor.nextCursor,
      stillHaveData: cursor.stillHaveData,
    );
  }

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

  Future<void> loadRoom({
    required String roomId,
    RoomType? type,
    String? userId,
  }) async {
    _isLoading = true;
    _error = null;
    _apiExceptions = null;
    notifyListeners();

    String uri = 'chat/room/$roomId?';

    try {
      if (type != null) {
        uri += 'type=${type.value}';
      }

      if (userId != null) {
        uri += '&user_id=$userId';
      }

      final response = await _httpService.get(endpoint: uri);

      final room = RoomWithParticipants.fromJson(response);

      _room = room;
    } on ApiExceptions catch (error) {
      _apiExceptions = error;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserMessagesByRoom({
    required String roomId,
    String? cursor,
  }) async {
    String uri = 'chat/room/$roomId/messages?limit=10';

    try {
      if (cursor != null) {
        uri = '$uri&cursor=$cursor';
      }

      final response = await _httpService.get(endpoint: uri);

      print('Response chat messages: $response');

      final chatMessages = (response['chat_messages'] as List)
          .map((message) => ChatMessageWithAuthor.fromJson(message))
          .toList();

      _cursor = (
        previousCursor: response['cursor']['previous_cursor'] as String?,
        nextCursor: response['cursor']['next_cursor'] as String?,
        stillHaveData: response['cursor']['has_more'] as bool,
      );

      _messagesProvider.chatMessages = chatMessages;
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
