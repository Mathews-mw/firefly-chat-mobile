import 'package:firefly_chat_mobile/models/value-objects/chat_message_with_author.dart';

abstract class ChatItem {}

class ChatDateHeader extends ChatItem {
  final DateTime date;

  ChatDateHeader(this.date);
}

class ChatMessageItem extends ChatItem {
  final ChatMessageWithAuthor message;

  ChatMessageItem(this.message);
}
