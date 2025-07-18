import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:firefly_chat_mobile/screens/chat_screen.dart';
import 'package:firefly_chat_mobile/components/app_drawer.dart';
import 'package:firefly_chat_mobile/screens/friendships/friends_screen.dart';
import 'package:firefly_chat_mobile/components/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    void openDrawer() {
      scaffoldKey.currentState?.openDrawer();
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: _currentScreenIndex == 0
          ? CustomAppBar(title: 'Home', onOpenDrawer: openDrawer)
          : null,
      drawer: const AppDrawer(),
      body: <Widget>[
        Center(child: Text('Home screen')),
        ChatScreen(),
        FriendsScreen(),
      ][_currentScreenIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.neutral800,
        selectedIndex: _currentScreenIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(PhosphorIconsFill.house),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsFill.chatText),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(PhosphorIconsFill.users),
            label: 'Amigos',
          ),
        ],
      ),
    );
  }
}
