import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum Variant {
  primary,
  secondary,
  muted,
  danger;

  Color get color {
    switch (this) {
      case Variant.primary:
        return AppColors.primary;
      case Variant.secondary:
        return AppColors.secondary;
      case Variant.muted:
        return AppColors.neutral300;
      case Variant.danger:
        return Colors.redAccent;
    }
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final Variant? variant;
  final Widget? icon;
  final bool isLoading;
  final bool disabled;
  final IconAlignment? iconAlignment;
  final void Function() onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.variant = Variant.primary,
    this.icon,
    this.isLoading = false,
    this.disabled = false,
    this.iconAlignment,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        disabledBackgroundColor: Color.fromRGBO(251, 146, 60, 0.4),
        disabledForegroundColor: AppColors.neutral300,
        backgroundColor: variant != null ? variant!.color : AppColors.primary,
        foregroundColor: AppColors.neutral800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      label: Text(isLoading ? 'Carregando...' : label),
      icon: isLoading
          ? CircularProgressIndicator(
              backgroundColor: AppColors.primary,
              constraints: BoxConstraints(minHeight: 22, minWidth: 22),
            )
          : icon,
      iconAlignment: iconAlignment,
      onPressed: isLoading || disabled ? null : onPressed,
    );
  }
}
