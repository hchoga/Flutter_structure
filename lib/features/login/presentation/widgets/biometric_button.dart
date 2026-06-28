import 'package:flutter/material.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';

class BiometricButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  const BiometricButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryLight, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: context.textTheme.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
