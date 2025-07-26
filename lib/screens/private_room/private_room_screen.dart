import 'dart:math';
import 'package:firefly_chat_mobile/models/decorated/chat_message_decorated.dart';
import 'package:firefly_chat_mobile/screens/private_room/chat_actions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firefly_chat_mobile/@types/room_type.dart';
import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:firefly_chat_mobile/providers/user_provider.dart';
import 'package:firefly_chat_mobile/providers/chat_provider.dart';
import 'package:firefly_chat_mobile/providers/messages_provider.dart';
import 'package:firefly_chat_mobile/components/custom_text_field.dart';
import 'package:firefly_chat_mobile/models/value-objects/chat_message_with_author.dart';

class PrivateRoomScreen extends StatefulWidget {
  final String roomId;

  const PrivateRoomScreen({super.key, required this.roomId});

  @override
  State<PrivateRoomScreen> createState() => _PrivateRoomScreen();
}

class _PrivateRoomScreen extends State<PrivateRoomScreen> {
  bool _hasLoadedData = false;
  bool _isLoading = false;
  bool _canSend = false;
  bool _showScrollToBottomButton = false;

  final ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final Map<String, Object> _formData = <String, Object>{};

  @override
  void initState() {
    super.initState();

    // Garante que o código só execute depois da renderização do frame atual.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      if (user != null) {
        Provider.of<ChatProvider>(context, listen: false).loadRoom(
          roomId: widget.roomId,
          type: RoomType.private,
          userId: user.id,
        );
      }

      Provider.of<MessagesProvider>(
        context,
        listen: false,
      ).joinRoom(widget.roomId);

      _scrollController.addListener(infinityScrollListener);
    });

    _scrollController.addListener(() {
      // Quando o scroll se distancia da última mensagem, mostra o botão
      if (_scrollController.offset > 300) {
        if (!_showScrollToBottomButton) {
          setState(() => _showScrollToBottomButton = true);
        }
      } else {
        if (_showScrollToBottomButton) {
          setState(() => _showScrollToBottomButton = false);
        }
      }
    });

    _messageController.addListener(() {
      final hasText = _messageController.text.trim().isNotEmpty;

      if (hasText != _canSend) {
        setState(() => _canSend = hasText);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoadedData) {
      _hasLoadedData = true;

      _loadChatMessages();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController
          .position
          .minScrollExtent, // pois o scroll está "reverso"
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _loadChatMessages() async {
    setState(() => _isLoading = true);

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    final cursor = chatProvider.cursor;
    final (:nextCursor, :previousCursor, :stillHaveData) = cursor;

    try {
      if (stillHaveData == false) {
        print('all data has been fetched!');
        return;
      }

      await chatProvider.loadUserMessagesByRoom(
        roomId: widget.roomId,
        cursor: nextCursor,
      );
    } catch (e) {
      print('Loading chat messages error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    setState(() => _isLoading = true);

    final bool isValidForm = _formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      setState(() => _isLoading = false);
      return;
    }

    _formKey.currentState?.save();

    try {
      final messagesProvider = Provider.of<MessagesProvider>(
        context,
        listen: false,
      );

      final user = Provider.of<UserProvider>(context, listen: false).user;

      if (user == null) {
        return;
      }

      messagesProvider.sendMessage(
        roomId: widget.roomId,
        message: _formData['message'] as String,
      );

      _messageController.clear();
    } catch (error) {
      print('Send message error: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  infinityScrollListener() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      print('Reached the end of the list!');

      await _loadChatMessages();
    }
  }

  String formatChatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) return "Hoje";
    if (msgDate == yesterday) return "Ontem";
    return DateFormat("dd 'de' MMMM 'de' yyyy", 'pt-BR').format(msgDate);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, _) {
            final room = chatProvider.room;
            final isLoading = chatProvider.isLoading;
            final user = room?.participants[0].user;

            return AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: AppColors.neutral800,
              leadingWidth: 100,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BackButton(),
                  SizedBox(width: 4),
                  Skeletonizer(
                    enabled: isLoading,
                    ignoreContainers: true,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: user?.avatarUrl != null
                          ? CachedNetworkImageProvider(user!.avatarUrl!)
                          : null,
                      child: user?.avatarUrl == null && user != null
                          ? Text(
                              user.name.substring(0, 2).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.foreground,
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
              title: Skeletonizer(
                enabled: isLoading,
                child: Text(
                  user?.name ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Consumer<MessagesProvider>(
                  builder: (ctx, messagesProvider, child) {
                    // final messages = messagesProvider.chatMessages;

                    final chatItems = messagesProvider.groupedChatItems;

                    final user = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).user;

                    return ListView.builder(
                      padding: EdgeInsets.only(top: 8),
                      controller: _scrollController,
                      reverse: true,
                      itemCount: chatItems.length + (_isLoading ? 1 : 0),
                      itemBuilder: (ctx, index) {
                        if (index < chatItems.length) {
                          final item = chatItems[index];

                          if (item is ChatDateHeader) {
                            final formattedDate = formatChatDate(item.date);

                            return Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(38, 38, 38, 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  formattedDate,
                                  style: TextStyle(
                                    color: AppColors.neutral400,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          } else if (item is ChatMessageItem) {
                            final bool isSentByMe =
                                user?.id == item.message.senderId;

                            return Align(
                              alignment: isSentByMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 250,
                                  minWidth: 80,
                                ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 10,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSentByMe
                                        ? Color.fromRGBO(249, 115, 22, 0.2)
                                        : AppColors.neutral800,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                      bottomLeft: isSentByMe
                                          ? Radius.circular(15)
                                          : Radius.zero,
                                      bottomRight: isSentByMe
                                          ? Radius.zero
                                          : Radius.circular(15),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 18,
                                        ),
                                        child: Text(
                                          item.message.content,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: isSentByMe ? null : 0,
                                        left: isSentByMe ? 0 : null,
                                        child: Row(
                                          children: [
                                            Text(
                                              '11:45',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: AppColors.neutral400,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              PhosphorIcons.check(),
                                              size: 12,
                                              color: AppColors.neutral400,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return SizedBox.shrink(); // fallback
                          }
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
              Container(
                padding: EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 16,
                  bottom: 32,
                ),
                child: Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ChatActions(),
                      const SizedBox(width: 4),
                      Flexible(
                        child: CustomTextField(
                          minLines: 1,
                          maxLines: 6,
                          hintText: 'Mensagem...',
                          textInputAction: TextInputAction.newline,
                          controller: _messageController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'A mensagem não pode estar vazia';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _formData['message'] = value ?? '';
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton.filledTonal(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: _canSend ? _sendMessage : null,
                        icon: Icon(PhosphorIconsFill.paperPlaneRight),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_showScrollToBottomButton)
            Positioned(
              right: 16,
              bottom: 80,
              child: FloatingActionButton(
                mini: true,
                onPressed: _scrollToBottom,
                backgroundColor: Colors.black38,
                child: Icon(
                  PhosphorIcons.caretDoubleDown(),
                  color: AppColors.foreground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
