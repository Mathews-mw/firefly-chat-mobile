import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firefly_chat_mobile/@types/room_type.dart';
import 'package:firefly_chat_mobile/providers/chat_provider.dart';
import 'package:firefly_chat_mobile/models/value-objects/room_with_participants.dart';

class GroupChatList extends StatefulWidget {
  const GroupChatList({super.key});

  @override
  State<GroupChatList> createState() => _GroupChatList();
}

class _GroupChatList extends State<GroupChatList> {
  List<RoomWithParticipants> _userGroupRooms = [];
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
        type: RoomType.group.value,
      );

      setState(() {
        _userGroupRooms = userRooms;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user group rooms: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: _userGroupRooms.isEmpty
          ? const Text('Não há conversas em grupo para mostrar...')
          : ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // impede scroll dentro,
              itemCount: _userGroupRooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Colors.transparent,
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      _userGroupRooms[index].imageUrl ??
                          'https://api.dicebear.com/9.x/thumbs/png?seed=${_userGroupRooms[index].participants[0].user.name}',
                    ),
                    radius: 22,
                  ),
                  title: Text(_userGroupRooms[index].name ?? 'Grupo'),
                  subtitle: _userGroupRooms[index].chatMessages.isEmpty
                      ? null
                      : Text(
                          _userGroupRooms[index].chatMessages[0].content,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                  trailing: _userGroupRooms[index].chatMessages.isEmpty
                      ? null
                      : Text(
                          DateFormat('d MMM', 'pt_BR').format(
                            _userGroupRooms[index].chatMessages[0].createdAt,
                          ),
                        ),
                  onTap: () {},
                );
              },
            ),
    );
  }
}
