import 'package:firefly_chat_mobile/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:firefly_chat_mobile/models/notification_app.dart';
import 'package:firefly_chat_mobile/@types/notification_type.dart';

class NotificationTile extends StatelessWidget {
  final NotificationApp notification;

  const NotificationTile({super.key, required this.notification});

  _showNotificationDetails(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.neutral800,
        contentTextStyle: TextStyle(color: AppColors.foreground),
        title: Text(
          notification.data.title,
          style: TextStyle(
            color: AppColors.foreground,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.data.content,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.foreground),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${notification.type.label} - ",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    DateFormat(
                      'd MMMM',
                      'pt_BR',
                    ).format(notification.createdAt),
                    style: TextStyle(color: AppColors.neutral400),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
          if (notification.type == NotificationType.friendRequest)
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Accept');
                Navigator.of(context).pushNamed(AppRoutes.pendingInvitations);
              },
              child: const Text('Conferir'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      textColor: AppColors.foreground,
      onTap: () => _showNotificationDetails(context),
      leading: Badge(
        isLabelVisible: !notification.isRead,
        alignment: Alignment(-1, -0.9),
        largeSize: 10,
        smallSize: 10,
        backgroundColor: Colors.blueAccent,
        child: CircleAvatar(
          backgroundColor: AppColors.neutral800,
          backgroundImage: notification.type == NotificationType.friendRequest
              ? CachedNetworkImageProvider(
                  'https://api.dicebear.com/9.x/thumbs/png?seed=Mathews',
                )
              : null,
          radius: 25,
          child: notification.type != NotificationType.friendRequest
              ? Icon(notification.type.icon, color: AppColors.foreground)
              : null,
        ),
      ),
      title: Text(
        notification.data.title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(overflow: TextOverflow.ellipsis, notification.data.content),
          Row(
            children: [
              Text(
                "${notification.type.label} - ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                DateFormat('d MMMM', 'pt_BR').format(notification.createdAt),
                style: TextStyle(color: AppColors.neutral400),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
