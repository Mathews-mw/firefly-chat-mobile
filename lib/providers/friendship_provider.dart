import 'package:flutter/material.dart';

import 'package:firefly_chat_mobile/services/http_service.dart';
import 'package:firefly_chat_mobile/models/value-objects/invitation_with_sender.dart';
import 'package:firefly_chat_mobile/models/value-objects/friendship_with_friend.dart';
import 'package:firefly_chat_mobile/models/value-objects/invitation_with_receiver.dart';

class FriendshipProvider with ChangeNotifier {
  final HttpService _httpService = HttpService();

  List<FriendshipWithFriend> _friendships = [];

  ({int? page, int? perPage, int? totalOccurrences, int? totalPages})
  _pagination = (
    page: null,
    perPage: null,
    totalOccurrences: null,
    totalPages: null,
  );

  set pagination(
    ({int? page, int? perPage, int? totalOccurrences, int? totalPages}) value,
  ) {
    _pagination = (
      page: value.page ?? _pagination.page,
      perPage: value.perPage ?? _pagination.perPage,
      totalOccurrences: value.totalOccurrences ?? _pagination.totalOccurrences,
      totalPages: value.totalPages ?? _pagination.totalPages,
    );

    notifyListeners();
  }

  ({int? page, int? perPage, int? totalOccurrences, int? totalPages})
  get pagination {
    return _pagination;
  }

  List<FriendshipWithFriend> get userFriendships {
    return [..._friendships];
  }

  Future<void> sendFriendshipRequest(Map<String, dynamic> data) async {
    try {
      await _httpService.post(endpoint: 'friendships/invitation', data: data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchUserFriendships({int? page}) async {
    String uri = 'friendships/user?per_page=10';

    try {
      if (page != null) {
        uri += '&page=$page';
      }

      final response = await _httpService.get(endpoint: uri);

      final friendshipsData = (response['friends'] as List)
          .map((item) => FriendshipWithFriend.fromJson(item))
          .toList();

      _pagination = (
        page: response['pagination']['page'],
        perPage: response['pagination']['per_page'],
        totalOccurrences: response['pagination']['total_occurrences'],
        totalPages: response['pagination']['total_pages'],
      );

      _friendships = [..._friendships, ...friendshipsData];
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<List<InvitationWithSender>> fetchUserPendingInvitations() async {
    try {
      final response = await _httpService.get(
        endpoint: 'friendships/invitation/user/pending',
      );

      final pendingInvitationsData = (response as List)
          .map((item) => InvitationWithSender.fromJson(item))
          .toList();

      return pendingInvitationsData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<InvitationWithReceiver>> fetchUserSentInvitations() async {
    try {
      final response = await _httpService.get(
        endpoint: 'friendships/invitation/user/sent',
      );

      final sentInvitationsData = (response as List)
          .map((item) => InvitationWithReceiver.fromJson(item))
          .toList();

      return sentInvitationsData;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptInvitation(String invitationId) async {
    try {
      await _httpService.patch('friendships/invitation/$invitationId/accept');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectInvitation(String invitationId) async {
    try {
      await _httpService.delete('friendships/invitation/$invitationId/delete');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteInvitation(String invitationId) async {
    try {
      await _httpService.patch('friendships/invitation/$invitationId/reject');
    } catch (e) {
      rethrow;
    }
  }
}
