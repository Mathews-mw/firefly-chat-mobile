enum RoomType {
  private,
  group;

  String get value {
    switch (this) {
      case RoomType.private:
        return 'PRIVATE';
      case RoomType.group:
        return 'GROUP';
    }
  }

  String get label {
    switch (this) {
      case RoomType.private:
        return 'Privado';
      case RoomType.group:
        return 'Grupo';
    }
  }
}
