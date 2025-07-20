import 'package:cached_network_image/cached_network_image.dart';
import 'package:firefly_chat_mobile/screens/chat/favorite_chat_list.dart';
import 'package:firefly_chat_mobile/screens/chat/group_chat_list.dart';
import 'package:firefly_chat_mobile/screens/chat/private_chat_list.dart';
import 'package:flutter/material.dart';

import 'package:firefly_chat_mobile/components/app_drawer.dart';
import 'package:firefly_chat_mobile/components/custom_app_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    required this.icon,
    this.isExpanded = false,
  });

  Widget expandedValue;
  String headerValue;
  bool isExpanded;
  IconData icon;
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Item> _data = <Item>[
    Item(
      headerValue: 'Favoritos',
      expandedValue: FavoriteChatList(),
      icon: PhosphorIconsFill.star,
      isExpanded: true,
    ),
    Item(
      headerValue: 'Chats',
      expandedValue: PrivateChatList(),
      icon: PhosphorIconsFill.chat,
      isExpanded: true,
    ),
    Item(
      headerValue: 'Canais',
      expandedValue: GroupChatList(),
      icon: PhosphorIconsFill.chats,
    ),
  ];

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(title: 'Chat', onOpenDrawer: openDrawer),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionPanelList(
              materialGapSize: 0,
              dividerColor: Colors.transparent,
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _data[index].isExpanded = isExpanded;
                });
              },
              children: _data.map<ExpansionPanel>((Item item) {
                return ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: Colors.transparent,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(item.headerValue),
                      leading: Icon(item.icon, size: 18),
                    );
                  },
                  body: item.expandedValue,
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
