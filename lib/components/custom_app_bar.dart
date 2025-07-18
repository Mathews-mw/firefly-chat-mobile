import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firefly_chat_mobile/providers/user_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final void Function()? onOpenDrawer;
  final bool showAvatar;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onOpenDrawer,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return AppBar(
      backgroundColor: AppColors.neutral800,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.foreground,
        ),
      ),
      leading: showAvatar
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: onOpenDrawer,
                child: Skeletonizer(
                  enabled: user == null,
                  ignoreContainers: true,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      user!.avatarUrl ??
                          'https://api.dicebear.com/9.x/thumbs/png?seed=${user.name}',
                    ),
                  ),
                ),
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
