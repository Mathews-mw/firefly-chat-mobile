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
  final IconAlignment? iconAlignment;
  final void Function() onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.variant = Variant.primary,
    this.icon,
    this.iconAlignment,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: variant != null ? variant!.color : AppColors.primary,
        foregroundColor:
            (variant == Variant.muted || variant == Variant.secondary)
            ? AppColors.neutral800
            : AppColors.foreground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      label: Text(label),
      icon: icon,
      iconAlignment: iconAlignment,
      onPressed: onPressed,
    );
  }
}
