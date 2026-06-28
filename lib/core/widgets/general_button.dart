import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';
import 'package:touch/generated/locale_keys.g.dart';

class GeneralButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String? label;
  final Color? color;
  final Color? textColor;
  final Widget? icon;
  final double? fontSize;
  const GeneralButton({
    super.key,
    this.isLoading = false,
    this.onPressed,
    this.label,
    this.color,
    this.textColor,
    this.icon,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primaryMain,
          // foregroundColor: AppColors.neutral100,
          disabledBackgroundColor: color ?? AppColors.primaryMain,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    label ?? LocaleKeys.login_sign_in_button.tr(),
                    style: context.textTheme.bodyLargeBold.copyWith(
                      color: textColor ?? Colors.white,
                      fontSize: fontSize,
                      letterSpacing: 0.5,
                    ),
                  ),
                  if (icon != null) SizedBox(width: 11.w),
                  if (icon != null) icon!,
                ],
              ),
      ),
    );
  }
}
