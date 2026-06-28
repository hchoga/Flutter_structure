import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';
import 'package:touch/generated/locale_keys.g.dart';

class ForgotPasswordButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const ForgotPasswordButton({
    super.key,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            LocaleKeys.login_forgot_password.tr(),
            style: context.textTheme.bodySmallMedium.copyWith(
              color: AppColors.primaryMain,
            ),
          ),
        ),
      ],
    );
  }
}
