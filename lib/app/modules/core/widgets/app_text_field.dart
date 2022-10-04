import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/typography.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;

  final String? errorText;

  const AppTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: AppTypography.textField(),
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        hintText: hintText,
        errorText: errorText,
        errorStyle: AppTypography.textField(color: AppColors.red),
        hintStyle: AppTypography.textField(),
        fillColor: AppColors.lightGray,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGrayBorder),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.red),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGrayBorder),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.lightGrayBorder),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
      ),
    );
  }
}
