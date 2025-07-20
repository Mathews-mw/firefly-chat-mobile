import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firefly_chat_mobile/@types/room_type.dart';
import 'package:firefly_chat_mobile/providers/chat_provider.dart';
import 'package:firefly_chat_mobile/models/value-objects/room_with_participants.dart';

class PrivateChatList extends StatefulWidget {
  const PrivateChatList({super.key});

  @override
  State<PrivateChatList> createState() => _PrivateChatListState();
}

class _PrivateChatListState extends State<PrivateChatList> {
  List<RoomWithParticipants> _userPrivateRooms = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserPrivateRooms();
  }

  Future<void> _loadUserPrivateRooms() async {
    setState(() => _isLoading = true);

    try {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      final userRooms = await chatProvider.fetchUserRooms(
        type: RoomType.private.value,
      );

      setState(() {
        _userPrivateRooms = userRooms;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user private rooms: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: _userPrivateRooms.isEmpty
          ? const Text('Não há conversas para mostrar...')
          : ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // impede scroll dentro,
              itemCount: _userPrivateRooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Colors.transparent,
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      _userPrivateRooms[index].participants[0].user.avatarUrl ??
                          'https://api.dicebear.com/9.x/thumbs/png?seed=${_userPrivateRooms[index].participants[0].user.name}',
                    ),
                    radius: 22,
                  ),
                  title: Text(
                    _userPrivateRooms[index].participants[0].user.name,
                  ),
                  subtitle: _userPrivateRooms[index].chatMessages.isEmpty
                      ? null
                      : Text(
                          _userPrivateRooms[index].chatMessages[0].content,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                  trailing: _userPrivateRooms[index].chatMessages.isEmpty
                      ? null
                      : Text(
                          DateFormat('d MMM', 'pt_BR').format(
                            _userPrivateRooms[index].chatMessages[0].createdAt,
                          ),
                        ),
                  onTap: () {},
                );
              },
            ),
    );
  }
}
