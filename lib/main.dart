import 'package:firefly_chat_mobile/providers/friendship-provider.dart';
import 'package:firefly_chat_mobile/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firefly_chat_mobile/app_routes.dart';
import 'package:firefly_chat_mobile/screens/home_screen.dart';
import 'package:firefly_chat_mobile/screens/login_screen.dart';
import 'package:firefly_chat_mobile/providers/user_provider.dart';

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
        },
      ),
    );
  }
}
