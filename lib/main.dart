import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firefly_chat_mobile/app_routes.dart';
import 'package:firefly_chat_mobile/theme/theme.dart';
import 'package:firefly_chat_mobile/screens/home_screen.dart';
import 'package:firefly_chat_mobile/screens/login_screen.dart';
import 'package:firefly_chat_mobile/providers/user_provider.dart';
import 'package:firefly_chat_mobile/providers/friendship-provider.dart';
import 'package:firefly_chat_mobile/screens/friendships/add_friend_screen.dart';
import 'package:firefly_chat_mobile/screens/friendships/sent_invitations_screen.dart';
import 'package:firefly_chat_mobile/screens/friendships/pending_invitations_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FriendshipProvider()),
      ],
      child: MaterialApp(
        title: 'Firefly Chat',
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (ctx) => LoginScreen(),
          AppRoutes.home: (ctx) => HomeScreen(),
          AppRoutes.addFriend: (ctx) => AddFriendScreen(),
          AppRoutes.pendingInvitations: (ctx) => PendingInvitationsScreen(),
          AppRoutes.sentInvitations: (ctx) => SentInvitationsScreen(),
        },
      ),
    );
  }
}
