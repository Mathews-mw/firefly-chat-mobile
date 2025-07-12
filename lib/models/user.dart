import 'package:firefly_chat_mobile/@types/role.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final Role role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  set id(String id) {
    this.id = id;
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

  set updatedAt(DateTime? updatedAt) {
    this.updatedAt = updatedAt;
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, avatarUrl: $avatarUrl, role: $role, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
