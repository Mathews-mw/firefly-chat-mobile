import 'dart:io';
import 'package:firefly_chat_mobile/screens/private_room/share_photos_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ChatActions extends StatefulWidget {
  const ChatActions({super.key});

  @override
  State<ChatActions> createState() => _ChatActionsState();
}

class _ChatActionsState extends State<ChatActions> {
  List<File> _pickedImages = [];

  Future<void> _pickGalleryImages(BuildContext ctx) async {
    _pickedImages.clear();

    try {
      final ImagePicker picker = ImagePicker();

      final imagesFromCamera = await picker.pickMultiImage();

      for (var image in imagesFromCamera) {
        setState(() {
          _pickedImages.add(File(image.path));
        });
      }

      if (ctx.mounted) {
        Navigator.of(ctx).pop();
      }
    } catch (e) {
      print('Pick gallery images error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      style: IconButton.styleFrom(backgroundColor: Colors.transparent),
      icon: Icon(PhosphorIconsFill.plusCircle, color: AppColors.secondary),
      onPressed: () {
        showModalBottomSheet<void>(
          backgroundColor: AppColors.neutral900,
          showDragHandle: true,
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChatActionButton(
                    label: 'Galeria',
                    icon: PhosphorIcons.imagesSquare(),
                    onPress: () async {
                      await _pickGalleryImages(context);

                      if (_pickedImages.isNotEmpty && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => SharePhotsPreviewScreen(
                              pickedImages: _pickedImages,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  ChatActionButton(
                    label: 'Câmera',
                    icon: PhosphorIcons.camera(),
                    onPress: () {},
                  ),
                  ChatActionButton(
                    label: 'Arquivo',
                    icon: PhosphorIcons.fileText(),
                    onPress: () {},
                  ),
                  ChatActionButton(
                    label: 'Audio',
                    icon: PhosphorIcons.musicNote(),
                    onPress: () {},
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ChatActionButton extends StatelessWidget {
  final void Function() onPress;
  final IconData icon;
  final String label;

  const ChatActionButton({
    super.key,
    required this.onPress,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filledTonal(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Color.fromRGBO(38, 38, 38, 0.8),
          ),
          onPressed: onPress,
          icon: Icon(icon, color: AppColors.secondary),
        ),
        Text(label, style: TextStyle(color: AppColors.neutral400)),
      ],
    );
  }
}
