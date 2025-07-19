import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum NotificationType {
  friendRequest,
  friendAccepted,
  reminder,
  news,
  others;

  String get value {
    switch (this) {
      case NotificationType.friendRequest:
        return 'FRIEND_REQUEST';
      case NotificationType.friendAccepted:
        return 'FRIEND_ACCEPTED';
      case NotificationType.reminder:
        return 'REMINDER';
      case NotificationType.news:
        return 'NEWS';
      case NotificationType.others:
        return 'OTHERS';
    }
  }

  String get label {
    switch (this) {
      case NotificationType.friendRequest:
        return 'Pedido de amizade';
      case NotificationType.friendAccepted:
        return 'Pedido de amizade aceito';
      case NotificationType.reminder:
        return 'Lembrete';
      case NotificationType.news:
        return 'Novidade';
      case NotificationType.others:
        return 'Outros';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.friendRequest:
        return PhosphorIcons.userPlus();
      case NotificationType.friendAccepted:
        return Icons.add_reaction;
      case NotificationType.reminder:
        return PhosphorIcons.note();
      case NotificationType.news:
        return PhosphorIcons.megaphone();
      case NotificationType.others:
        return PhosphorIcons.megaphone();
    }
  }
}
