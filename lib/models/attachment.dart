import 'package:firefly_chat_mobile/@types/attachment_type.dart';

class Attachment {
  final String id;
  final String title;
  final String url;
  final String? messageId;
  final String? roomId;
  final AttachmentType type;

  const Attachment({
    required this.id,
    required this.title,
    required this.url,
    required this.type,
    this.messageId,
    this.roomId,
  });

  set id(String id) {
    this.id = id;
  }

  set title(String title) {
    this.title = title;
  }

  set url(String url) {
    this.url = url;
  }

  set type(AttachmentType type) {
    this.type = type;
  }

  set messageId(String? messageId) {
    this.messageId = messageId;
  }

  set roomId(String? roomId) {
    this.roomId = roomId;
  }

  factory Attachment.fromJson(Map<String, dynamic> json) {
    final attachment = Attachment(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      messageId: json['message_id'],
      roomId: json['room_id'],
      type: AttachmentType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => AttachmentType.file,
      ),
    );

    return attachment;
  }

  @override
  String toString() {
    return 'Attachment(id: $id, title: $title, url: $url, messageId: $messageId, roomId: $roomId, type: $type)';
  }
}
