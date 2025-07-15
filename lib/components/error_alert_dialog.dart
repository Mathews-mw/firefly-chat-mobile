import 'package:flutter/material.dart';

import 'package:firefly_chat_mobile/theme/app_colors.dart';

class ErrorAlertDialog {
  static Future<void> showDialogError({
    required BuildContext context,
    required String title,
    required String code,
    required String message,
    String? description,
  }) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.neutral800,
        contentTextStyle: TextStyle(color: AppColors.foreground),
        title: Text(title, style: TextStyle(color: AppColors.foreground)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Código:',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.foreground,
                    ),
                  ),
                  Text(
                    code,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mensagem:',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.foreground,
                    ),
                  ),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),

              if (description != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descrição:',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.foreground,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.foreground,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
