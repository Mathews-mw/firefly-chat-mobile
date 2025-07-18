import 'package:flutter/widgets.dart';

import 'package:firefly_chat_mobile/screens/home_screen.dart';
import 'package:firefly_chat_mobile/screens/login_screen.dart';
import 'package:firefly_chat_mobile/screens/friendships/add_friend_screen.dart';
import 'package:firefly_chat_mobile/screens/friendships/sent_invitations_screen.dart';
import 'package:firefly_chat_mobile/screens/friendships/pending_invitations_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const addFriend = '/add-friend';
  static const pendingInvitations = '/pending-invitations';
  static const sentInvitations = '/sent-invitations';

  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.login: (ctx) => const LoginScreen(),
    AppRoutes.home: (ctx) => const HomeScreen(),
    AppRoutes.addFriend: (ctx) => const AddFriendScreen(),
    AppRoutes.pendingInvitations: (ctx) => const PendingInvitationsScreen(),
    AppRoutes.sentInvitations: (ctx) => const SentInvitationsScreen(),
  };
}
