import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  final Color? textColor;
  final bool overrideBackButton;
  final VoidCallback? onBackClicked;
  final bool hideBackButton;
  // pass this manually

  const AppBarWidget({
    super.key,
    required this.title,
    this.textColor,
    this.overrideBackButton = false,
    this.onBackClicked,
    this.hideBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = InkWell(
      onTap: () {
        if (overrideBackButton == false) {
          context.pop();
        } else {
          onBackClicked!();
        }
      },
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Icon(Icons.chevron_right, size: 26.r, color: AppColors.darkD900),
      ),
    );

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).viewPadding.top + 35,
        bottom: 28,
      ),
      child: Row(
        children: [
          // Left side
          // if (!isArabic) iconWidget,
          SizedBox(width: 15),
          // Center title
          Expanded(
            child: Center(
              child: Text(
                title,
                style: context.textTheme.bodyLargeBold.copyWith(
                  color: textColor,
                ),
              ),
            ),
          ),
          if (!hideBackButton)
            // Right side
            iconWidget,
        ],
      ),
    );
  }
}
