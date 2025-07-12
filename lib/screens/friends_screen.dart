import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lista de amigos'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.people_alt_rounded)),
          IconButton(onPressed: () {}, icon: Icon(Icons.person_add_alt_1)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://plus.unsplash.com/premium_photo-1690407617542-2f210cf20d7e?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                ),
                radius: 30,
              ),
              title: Text('Lula Caldwell'),
              subtitle: Text('@lula_caldwell'),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
            );
          },
        ),
      ),
    );
  }
}
