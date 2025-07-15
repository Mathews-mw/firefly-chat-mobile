import 'package:firefly_chat_mobile/@types/role.dart';

class User {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? avatarUrl;
  final Role role;
  final bool isActive;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });

  set id(String id) {
    this.id = id;
  }

  set name(String name) {
    this.name = name;
  }

  set username(String username) {
    this.username = username;
  }

  set email(String email) {
    this.email = email;
  }

  set avatarUrl(String? avatarUrl) {
    this.avatarUrl = avatarUrl;
  }

  set role(Role role) {
    this.role = role;
  }

  set isActive(bool isActive) {
    this.isActive = isActive;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      role: Role.values.firstWhere(
        (e) => e.value == json['role'],
        orElse: () => Role.member,
      ),
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
    );

    return user;
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, username: $username, email: $email, role: $role, avatarUrl: $avatarUrl, isActive: $isActive, createdAt: $createdAt)';
  }
}
