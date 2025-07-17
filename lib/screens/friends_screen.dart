import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firefly_chat_mobile/components/app_drawer.dart';
import 'package:firefly_chat_mobile/components/custom_app_bar.dart';
import 'package:firefly_chat_mobile/providers/friendship-provider.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasMore = true;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(infinityScrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadUserFriendships();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  Future<void> _loadUserFriendships() async {
    setState(() => _isLoading = true);

    final friendshipProvider = Provider.of<FriendshipProvider>(
      context,
      listen: false,
    );

    final pagination = friendshipProvider.pagination;
    final (:page, :perPage, :totalOccurrences, :totalPages) = pagination;

    try {
      if (page != null && page == totalPages) {
        print('No more pages to load.');

        setState(() {
          _isLoading = false;
          _hasMore = false;
        });

        return;
      }

      await friendshipProvider.fetchUserFriendships(page: _currentPage);

      setState(() {
        _currentPage++;
        _hasMore = true;
      });
    } catch (e) {
      print('Error loading friendships: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  infinityScrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMore) {
        await _loadUserFriendships();
      }
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
      key: scaffoldKey,
      appBar: CustomAppBar(title: 'Amigos', onOpenDrawer: openDrawer),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<FriendshipProvider>(
          builder: (ctx, friendshipProvider, child) {
            final friendships = friendshipProvider.userFriendships;

            print('Friendships: ${friendships.length}');

            return ListView.builder(
              controller: _scrollController,
              itemCount: friendships.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < friendships.length) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        friendships[index].friend.avatarUrl ??
                            'https://api.dicebear.com/9.x/thumbs/png?seed=${friendships[index].friend.name}',
                      ),
                      radius: 30,
                    ),
                    title: Text(friendships[index].friend.name),
                    subtitle: Text("@${friendships[index].friend.username}"),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_vert),
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
    );
  }
}
