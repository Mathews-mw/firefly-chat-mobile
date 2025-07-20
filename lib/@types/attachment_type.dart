enum AttachmentType {
  image,
  video,
  document,
  file,
  audio;

  String get value {
    switch (this) {
      case AttachmentType.image:
        return 'IMAGE';
      case AttachmentType.video:
        return 'VIDEO';
      case AttachmentType.document:
        return 'DOCUMENT';
      case AttachmentType.file:
        return 'FILE';
      case AttachmentType.audio:
        return 'AUDIO';
    }
  }

  String get label {
    switch (this) {
      case AttachmentType.image:
        return 'Imagem';
      case AttachmentType.video:
        return 'Vídeo';
      case AttachmentType.document:
        return 'Documento';
      case AttachmentType.file:
        return 'Arquivo';
      case AttachmentType.audio:
        return 'Audio';
    }
  }
}
