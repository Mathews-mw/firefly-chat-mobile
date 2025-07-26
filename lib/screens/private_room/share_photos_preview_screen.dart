import 'dart:io';

import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SharePhotsPreviewScreen extends StatefulWidget {
  List<File> pickedImages = [];

  SharePhotsPreviewScreen({super.key, required this.pickedImages});

  @override
  State<SharePhotsPreviewScreen> createState() =>
      _SharePhotsPreviewScreenState();
}

class _SharePhotsPreviewScreenState extends State<SharePhotsPreviewScreen> {
  File? _selectImage;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectImage = widget.pickedImages[0];
    });
  }

  handleSelectImage(File image) {
    setState(() {
      _selectImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight =
        MediaQuery.of(context).size.height - kToolbarHeight - 60;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              height: screenHeight,
              width: double.infinity,
              child: Image.file(
                _selectImage ?? widget.pickedImages[0],
                // fit: BoxFit.fitHeight,
                width: double.infinity,
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  height: 70,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: ListView.separated(
                    separatorBuilder: (BuildContext ctx, int index) =>
                        const SizedBox(width: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.pickedImages.length,
                    itemBuilder: (ctx, index) {
                      final isSelected =
                          widget.pickedImages[index] == _selectImage;

                      return InkWell(
                        child: Container(
                          height: 70,
                          width: 70,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? BoxBorder.all(
                                    color: AppColors.foreground,
                                    width: 3,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Image.file(
                              widget.pickedImages[index],
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectImage = widget.pickedImages[index];
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton.filledTonal(
                      style: IconButton.styleFrom(
                        backgroundColor: Color.fromRGBO(36, 36, 36, 0.8),
                      ),
                      onPressed: () {},
                      icon: Badge.count(
                        count: widget.pickedImages.length,
                        backgroundColor: AppColors.secondary,
                        textColor: AppColors.foreground,
                        child: Icon(PhosphorIconsFill.paperPlaneRight),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton.filledTonal(
              style: IconButton.styleFrom(
                backgroundColor: Color.fromRGBO(36, 36, 36, 0.8),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(PhosphorIcons.x(), color: AppColors.foreground),
            ),
          ),
        ],
      ),
    );
  }
}
