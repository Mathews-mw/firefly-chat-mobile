import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String obscuringCharacter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.obscuringCharacter = '*',
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.initialValue,
    this.textInputAction,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.validator,
    this.enabled = true,
    this.minLines = 1,
    this.maxLines = 1,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return TextFormField(
      enabled: enabled,
      controller: controller,
      textInputAction: textInputAction,
      initialValue: initialValue,
      onSaved: onSaved,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      minLines: minLines,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      cursorColor: AppColors.foreground,
      style: TextStyle(color: AppColors.foreground),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 10, left: 20),
        filled: true,
        fillColor: AppColors.neutral800,
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: AppColors.neutral500),
        errorStyle: TextStyle(fontSize: 12, color: AppColors.danger),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.transparent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.transparent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Color.fromRGBO(249, 115, 22, 0.4),
            width: 2,
          ),
        ),
      ),
    );
  }
}
