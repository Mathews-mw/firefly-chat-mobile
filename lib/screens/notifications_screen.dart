import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:firefly_chat_mobile/components/custom_app_bar.dart';
import 'package:firefly_chat_mobile/@exceptions/api_exceptions.dart';
import 'package:firefly_chat_mobile/components/notification_tile.dart';
import 'package:firefly_chat_mobile/components/error_alert_dialog.dart';
import 'package:firefly_chat_mobile/providers/notifications_provider.dart';
import 'package:firefly_chat_mobile/components/notification_filter_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _hasLoadedData = false;
  bool _isLoading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(infinityScrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoadedData) {
      _hasLoadedData = true;

      _loadNotifications();
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    setState(() => _isLoading = true);

    try {
      final notificationsProvider = Provider.of<NotificationsProvider>(
        context,
        listen: false,
      );

      await notificationsProvider.markNotificationAsRead(notificationId);
    } on ApiExceptions catch (error) {
      print('Mark notification as read error: $error');

      if (context.mounted) {
        ErrorAlertDialog.showDialogError(
          context: context,
          title: 'Erro ao tentar marcar notificação como lida',
          code: error.code,
          message: error.message,
        );
      }
    } catch (error) {
      print('Unexpected error: $error');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aconteceu um erro inesperado. Tente novamente'),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _removeNotification(String notificationId) async {
    setState(() => _isLoading = true);

    try {
      final notificationsProvider = Provider.of<NotificationsProvider>(
        context,
        listen: false,
      );

      await notificationsProvider.deleteNotification(notificationId);
    } on ApiExceptions catch (error) {
      print('Delete notification as read error: $error');

      if (context.mounted) {
        ErrorAlertDialog.showDialogError(
          context: context,
          title: 'Erro ao tentar remover notificação',
          code: error.code,
          message: error.message,
        );
      }
    } catch (error) {
      print('Unexpected error: $error');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aconteceu um erro inesperado. Tente novamente'),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadNotifications([bool? isRead]) async {
    setState(() => _isLoading = true);

    final notificationsProvider = Provider.of<NotificationsProvider>(
      context,
      listen: false,
    );

    final cursor = notificationsProvider.cursor;
    final (:nextCursor, :previousCursor, :stillHaveData) = cursor;

    print('current cursor: $cursor');

    try {
      if (stillHaveData == false) {
        print('all data has been fetched!');
        return;
      }

      await notificationsProvider.fetchNotifications(
        cursor: nextCursor,
        isRead: isRead,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  infinityScrollListener() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      print('Reached the end of the list!');

      await _loadNotifications();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Notificações', showAvatar: false),
      body: Column(
        children: [
          Container(
            color: AppColors.neutral800,
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 8,
            ),
            child: NotificationFilterBar(
              onFilterChanged: (bool? isRead) async {
                Provider.of<NotificationsProvider>(
                  context,
                  listen: false,
                ).cursor = (
                  previousCursor: null,
                  nextCursor: null,
                  stillHaveData: null,
                );

                await _loadNotifications(isRead);
              },
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 220,
            child: Consumer<NotificationsProvider>(
              builder: (ctx, notificationsProvider, child) {
                final notifications = notificationsProvider.notifications;

                return ListView.separated(
                  controller: _scrollController,
                  itemCount: notifications.length + (_isLoading ? 1 : 0),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(color: AppColors.neutral700, height: 0),
                  itemBuilder: (context, index) {
                    if (index < notifications.length) {
                      return Slidable(
                        startActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                await _removeNotification(
                                  notifications[index].id,
                                );
                              },
                              icon: Icons.close,
                              label: 'Remover',
                              backgroundColor: Color.fromRGBO(239, 68, 68, 0.2),
                              foregroundColor: AppColors.danger,
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                await _markAsRead(notifications[index].id);
                              },
                              icon: PhosphorIcons.eyeglasses(),
                              label: 'Lido',
                              backgroundColor: Color.fromRGBO(
                                139,
                                92,
                                246,
                                0.2,
                              ),
                              foregroundColor: AppColors.secondary,
                            ),
                          ],
                        ),
                        child: NotificationTile(
                          notification: notifications[index],
                        ),
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
