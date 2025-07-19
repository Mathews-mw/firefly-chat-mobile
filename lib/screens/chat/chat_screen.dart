import 'package:cached_network_image/cached_network_image.dart';
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
      expandedValue: ChatFavoriteSection(),
      icon: PhosphorIconsFill.star,
    ),
    Item(
      headerValue: 'Chats',
      expandedValue: ChatFavoriteSection(),
      icon: PhosphorIconsFill.chat,
    ),
    Item(
      headerValue: 'Canais',
      expandedValue: ChatFavoriteSection(),
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

class ChatFavoriteSection extends StatelessWidget {
  const ChatFavoriteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // impede scroll dentro,
        itemCount: 3,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Colors.transparent,
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                'https://api.dicebear.com/9.x/thumbs/png?seed=Mathews',
              ),
              radius: 22,
            ),
            title: Text('Mathews Araujo'),
            subtitle: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: Text('7 jul'),
            onTap: () {},
          );
        },
      ),
    );
  }
}
