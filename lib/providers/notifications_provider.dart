import 'package:flutter/foundation.dart';

import 'package:firefly_chat_mobile/models/notification_app.dart';
import 'package:firefly_chat_mobile/services/http_service.dart';

class NotificationsProvider with ChangeNotifier {
  final HttpService _httpService = HttpService();

  List<NotificationApp> _notifications = [];

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

  List<NotificationApp> get notifications {
    return _notifications;
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _httpService.patch('notifications/read', {
        'notification_ids': [notificationId],
      });

      _notifications = _notifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _httpService.delete('notifications/$notificationId');

      _notifications.removeWhere((item) => item.id == notificationId);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchNotifications({String? cursor, bool? isRead}) async {
    String uri = 'notifications/cursor?limit=10';

    try {
      if (cursor != null) {
        uri = '$uri&cursor=$cursor';
      }

      if (isRead != null) {
        _notifications = [];
        uri = '$uri&is_read=$isRead';
      }

      print('notification uri: $uri');

      final response = await _httpService.get(endpoint: uri);

      final notifications = (response['notifications'] as List)
          .map((notification) => NotificationApp.fromJson(notification))
          .toList();

      _cursor = (
        previousCursor: response['cursor']['previous_cursor'] as String?,
        nextCursor: response['cursor']['next_cursor'] as String?,
        stillHaveData: response['cursor']['has_more'] as bool,
      );

      _notifications = [..._notifications, ...notifications];
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
