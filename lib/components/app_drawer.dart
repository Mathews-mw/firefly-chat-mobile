import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:firefly_chat_mobile/providers/user_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    return Drawer(
      backgroundColor: AppColors.neutral800,
      child: ListView(
        padding: EdgeInsets.only(top: 64, bottom: 16, left: 16, right: 8),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Skeletonizer(
                enabled: user == null,
                ignoreContainers: true,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    user!.avatarUrl ??
                        'https://api.dicebear.com/9.x/thumbs/png?seed=${user.name}',
                  ),
                  radius: 26,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Skeletonizer(
                    enabled: user == null,
                    child: Text(
                      user!.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground,
                      ),
                    ),
                  ),
                  Skeletonizer(
                    enabled: user == null,
                    child: Text(
                      user!.username,
                      style: TextStyle(color: AppColors.neutral400),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Icon(
              PhosphorIconsFill.checkCircle,
              color: AppColors.secondary,
            ),
            title: const Text(
              'Disponível',
              style: TextStyle(color: AppColors.foreground),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.bell()),
            title: const Text(
              'Notificações',
              style: TextStyle(color: AppColors.foreground),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(PhosphorIcons.gear()),
            title: const Text(
              'Configurações',
              style: TextStyle(color: AppColors.foreground),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
