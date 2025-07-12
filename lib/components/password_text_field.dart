import 'package:firefly_chat_mobile/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;

  const PasswordTextField({
    super.key,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.textInputAction,
    this.onChanged,
    this.onSaved,
    this.onFieldSubmitted,
    this.validator,
    this.enabled = true,
    this.inputFormatters,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool obscurePassword = true;

  onToggleObscurePassword() {
    setState(() {
      obscurePassword = !obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      obscureText: obscurePassword,
      obscuringCharacter: '*',
      inputFormatters: widget.inputFormatters,
      cursorColor: AppColors.foreground,
      style: TextStyle(color: AppColors.foreground),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 10, left: 20),
        filled: true,
        fillColor: AppColors.neutral700,
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: 14, color: AppColors.neutral300),
        errorStyle: TextStyle(fontSize: 12, color: Colors.redAccent),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_rounded : Icons.visibility_off,
            color: AppColors.neutral400,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
