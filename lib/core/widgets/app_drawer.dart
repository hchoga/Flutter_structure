import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Padding(
        padding: EdgeInsets.symmetric(
          // horizontal: AppSizes.horizontalPadding,
          vertical: 15.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // â”€â”€ User Profile Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // DrawerItem(
                  //   appAsset: AppAssets.languageIcon,
                  //   title: LocaleKeys.language.tr(),
                  //   height: 22,
                  //   width: 22,
                  // ),
                  // Divider(color: AppColors.borderColor, height: 22.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final VoidCallback onTap;
  final String appAsset;
  final String title;
  final double? height;
  final double? width;
  const DrawerItem({
    super.key,
    required this.onTap,
    required this.appAsset,
    required this.title,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            appAsset,
            color: AppColors.primary,
            height: height,
            width: width,
          ),
          SizedBox(width: 9.w),
          Text(title, style: context.textTheme.bodySmallBold),
        ],
      ),
    );
  }
}
