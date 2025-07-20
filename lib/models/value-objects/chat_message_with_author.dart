import 'package:firefly_chat_mobile/models/user.dart';
import 'package:firefly_chat_mobile/models/attachment.dart';
import 'package:firefly_chat_mobile/models/read_receipt.dart';

class ChatMessageWithAuthor {
  final String id;
  final String senderId;
  final String content;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final User author;
  final List<ReadReceipt> readReceipts;
  final List<Attachment> attachments;

  const ChatMessageWithAuthor({
    required this.id,
    required this.senderId,
    required this.content,
    required this.isDeleted,
    required this.createdAt,
    this.updatedAt,
    required this.author,
    required this.readReceipts,
    required this.attachments,
  });

  factory ChatMessageWithAuthor.fromJson(Map<String, dynamic> json) {
    final chatMessageWithAuthor = ChatMessageWithAuthor(
      id: json['id'],
      senderId: json['sender_id'],
      content: json['content'],
      isDeleted: json['is_deleted'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['replied_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      author: User.fromJson(json['author']),
      readReceipts: (json['read_receipts'] as List)
          .map((readReceipt) => ReadReceipt.fromJson(readReceipt))
          .toList(),
      attachments: (json['attachments'] as List)
          .map((attachment) => Attachment.fromJson(attachment))
          .toList(),
    );

    return chatMessageWithAuthor;
  }
}
