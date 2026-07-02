import 'package:flutter/material.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int? maxLines;

  /// Shows a red * next to the hint text
  final bool isRequired;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.onChanged,
    this.keyboardType,
    this.maxLines,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          color: context.colors.surface,
          child: TextFormField(
            maxLines: maxLines ?? 1,
            controller: controller,
            obscureText: obscureText,
            enabled: enabled,
            keyboardType: keyboardType,
            style: context.textTheme.bodySmallRegular,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface,

              // Custom hint with optional red star
              hint: RichText(
                text: TextSpan(
                  text: hint,
                  style: context.textTheme.bodySmallRegular.copyWith(
                    color: AppColors.darkD3,
                  ),
                  children: [
                    if (isRequired)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: AppColors.error,
                        ),
                      ),
                  ],
                ),
              ),

              // Remove default error UI
              errorText: null,
              errorStyle: const TextStyle(height: 0),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: hasError
                      ? AppColors.error
                      : Colors.transparent,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: hasError
                      ? AppColors.error
                      : Colors.transparent,
                ),
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),

              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
          ),
        ),

        if (hasError)
          Padding(
            padding: const EdgeInsets.only(
              top: 6,
              right: 8,
            ),
            child: Text(
              errorText!,
              textAlign: TextAlign.right,
              style: context.textTheme.bodySmallRegular.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}
