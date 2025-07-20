import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firefly_chat_mobile/app_routes.dart';
import 'package:firefly_chat_mobile/theme/theme.dart';
import 'package:firefly_chat_mobile/screens/home_screen.dart';
import 'package:firefly_chat_mobile/screens/login_screen.dart';
import 'package:firefly_chat_mobile/providers/user_provider.dart';
import 'package:firefly_chat_mobile/providers/chat_provider.dart';
import 'package:firefly_chat_mobile/screens/notifications_screen.dart';
import 'package:firefly_chat_mobile/providers/friendship_provider.dart';
import 'package:firefly_chat_mobile/providers/notifications_provider.dart';
import 'package:firefly_chat_mobile/screens/friendships/add_friend_screen.dart';
import 'package:firefly_chat_mobile/screens/friendships/sent_invitations_screen.dart';
import 'package:firefly_chat_mobile/screens/friendships/pending_invitations_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

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
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => FriendshipProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
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
          AppRoutes.notifications: (ctx) => NotificationsScreen(),
        },
      ),
    );
  }
}
