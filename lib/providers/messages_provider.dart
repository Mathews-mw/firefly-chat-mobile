import 'dart:convert';

import 'package:firefly_chat_mobile/@types/attachment_type.dart';
import 'package:firefly_chat_mobile/@types/role.dart';
import 'package:firefly_chat_mobile/models/attachment.dart';
import 'package:firefly_chat_mobile/models/decorated/chat_message_decorated.dart';
import 'package:firefly_chat_mobile/models/user.dart';
import 'package:firefly_chat_mobile/services/websocket_service.dart';
import 'package:flutter/material.dart';

import 'package:firefly_chat_mobile/models/value-objects/chat_message_with_author.dart';

class MessagesProvider with ChangeNotifier {
  final WebSocketService _socketService = WebSocketService();

  MessagesProvider() {
    _initSocket();
  }

  List<ChatMessageWithAuthor> _chatMessages = [];

  List<ChatMessageWithAuthor> get chatMessages {
    return [..._chatMessages];
  }

  set chatMessages(List<ChatMessageWithAuthor> chatMessages) {
    _chatMessages = [..._chatMessages, ...chatMessages];

    notifyListeners();
  }

  List<ChatItem> get groupedChatItems {
    final List<ChatItem> grouped = [];
    DateTime? lastDate;

    for (final msg in _chatMessages) {
      final msgDate = DateTime(
        msg.createdAt.year,
        msg.createdAt.month,
        msg.createdAt.day,
      );

      if (lastDate == null || msgDate != lastDate) {
        grouped.add(ChatDateHeader(msgDate));
        lastDate = msgDate;
      }

      grouped.add(ChatMessageItem(msg));
    }

    return grouped;
  }

  addMessage(ChatMessageWithAuthor message) {
    _chatMessages.insert(0, message);
    notifyListeners();
  }

  void _initSocket() {
    _socketService.connect();

    _socketService.on('message', (payload) {
      try {
        print('Resposta do servidor: $payload');

        final chatMessage = ChatMessageWithAuthor(
          id: payload['message']['id'],
          senderId: payload['message']['senderId'],
          content: payload['message']['content'],
          isDeleted: false,
          createdAt: DateTime.parse(payload['message']['createdAt']),
          updatedAt: payload['updatedAt'] != null
              ? DateTime.parse(payload['updated_at'])
              : null,
          author: User(
            id: payload['message']['author']['id'],
            name: payload['message']['author']['name'],
            username: payload['message']['author']['username'],
            email: payload['message']['author']['email'],
            avatarUrl: payload['message']['author']['avatarUrl'],
            role: Role.values.firstWhere(
              (e) => e.value == payload['message']['author']['role'],
              orElse: () => Role.member,
            ),
            isActive: payload['message']['author']['isActive'],
            createdAt: DateTime.parse(
              payload['message']['author']['createdAt'],
            ),
          ),
          readReceipts: [],
          attachments: (payload['message']['attachments'] as List).map((
            attachment,
          ) {
            return Attachment(
              id: attachment['id'],
              title: attachment['title'],
              url: attachment['url'],
              messageId: attachment['messageId'],
              roomId: attachment['roomId'],
              type: AttachmentType.values.firstWhere(
                (e) => e.value == attachment['type'],
                orElse: () => AttachmentType.file,
              ),
            );
          }).toList(),
        );

        addMessage(chatMessage);
      } catch (e) {
        print('Erro ao processar mensagem recebida via socket: $e');
      }
    });
  }

  void sendMessage({required String roomId, required String message}) {
    // Envia mensagem para o socket
    _socketService.send('sendMessage', {'roomId': roomId, 'content': message});
  }

  void disposeSocket() {
    _socketService.disconnect();
  }

  void joinRoom(String roomId) {
    print('Join room: $roomId');
    _socketService.send('joinRoom', {'roomId': roomId});
  }
}
