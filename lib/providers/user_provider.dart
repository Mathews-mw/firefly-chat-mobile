import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firefly_chat_mobile/models/user.dart';
import 'package:firefly_chat_mobile/services/auth_service.dart';
import 'package:firefly_chat_mobile/services/http_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  final HttpService _httpService = HttpService();
  final AuthService _authService = AuthService();

  static const String _userKey = "user_data";

  User? get user {
    return _user;
  }

  bool get isAuthenticated {
    return _user != null;
  }

  Future<void> _saveUserToLocalStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();

    final userJson = jsonEncode({
      'id': user.id,
      'name': user.name,
      'username': user.username,
      'email': user.email,
      'role': user.role.value,
      'avatarUrl': user.avatarUrl,
      'isActive': user.isActive,
      'createdAt': user.createdAt.toString(),
    });

    await prefs.setString(_userKey, userJson);
  }

  Future<void> _loadUserFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      final userData = jsonDecode(userJson);

      final user = User.fromJson(userData);

      _user = user;
    }
  }

  Future<void> initializerUser() async {
    await _loadUserFromLocalStorage();
  }

  Future<void> loadUserData() async {
    try {
      final response = await _httpService.get(endpoint: 'users/me');

      print("User data loaded: $response");

      final user = User.fromJson(response);

      _user = user;

      await _saveUserToLocalStorage(user);

      notifyListeners();
    } catch (error) {
      print("Erro ao buscar usuário: $error");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userKey);
    await _authService.removeToken();

    _user = null;
    notifyListeners();
  }
}
