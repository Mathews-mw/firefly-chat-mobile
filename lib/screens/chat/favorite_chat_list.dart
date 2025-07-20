import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoriteChatList extends StatefulWidget {
  const FavoriteChatList({super.key});

  @override
  State<FavoriteChatList> createState() => _FavoriteChatListState();
}

class _FavoriteChatListState extends State<FavoriteChatList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // impede scroll dentro,
        itemCount: 2,
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
