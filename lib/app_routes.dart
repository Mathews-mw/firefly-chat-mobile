import 'package:flutter/widgets.dart';

import 'package:firefly_chat_mobile/screens/home_screen.dart';
import 'package:firefly_chat_mobile/screens/login_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const home = '/home';

  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.login: (ctx) => const LoginScreen(),
    AppRoutes.home: (ctx) => const HomeScreen(),
  };
}
