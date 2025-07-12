import 'package:firefly_chat_mobile/screens/chat_screen.dart';
import 'package:firefly_chat_mobile/screens/friends_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentScreenIndex == 0
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Home'),
            )
          : null,
      body: <Widget>[
        Center(child: Text('Home screen')),
        ChatScreen(),
        FriendsScreen(),
      ][_currentScreenIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentScreenIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.chat_rounded), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Amigos'),
        ],
      ),
    );
  }
}
