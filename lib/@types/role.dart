enum Role {
  admin,
  member;

  String get value {
    switch (this) {
      case Role.admin:
        return 'ADMIN';
      case Role.member:
        return 'MEMBER';
    }
  }

  String get label {
    switch (this) {
      case Role.admin:
        return 'Administrator';
      case Role.member:
        return 'Membro';
    }
  }
}
