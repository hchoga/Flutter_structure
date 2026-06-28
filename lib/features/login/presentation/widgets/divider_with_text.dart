import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';
import 'package:touch/generated/locale_keys.g.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.primaryLight, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Text(
            LocaleKeys.login_divider_or.tr(),
            style: context.textTheme.bodySmallRegular.copyWith(
              color: AppColors.darkD3,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.primaryLight, thickness: 1)),
      ],
    );
  }
}
