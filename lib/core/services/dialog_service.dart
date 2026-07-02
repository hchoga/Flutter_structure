import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:touch/core/constants/app_assets.dart';
import 'package:touch/core/constants/app_colors.dart';

class DialogService {
  static Future<bool?> show(BuildContext context, Widget content) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Stack(
        clipBehavior: Clip.none,

        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),

            width: 1000,
            padding: EdgeInsets.all(16.0),
            child: content,
          ),
          Positioned(
            top: -14,
            left: 10,
            child: InkWell(
              onTap: context.pop,
              child: CircleAvatar(
                radius: 15.r,
                backgroundColor: AppColors.surface,
                child: SvgPicture.asset(
                  AppAssets.rejectedIcon,
                  color: AppColors.primary,
                  height: 22.h,
                  width: 22.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool> showCustomDialog({
    required Widget? widget,
    double? padding,
    BuildContext? context,
  }) async {
    try {
      return await showDialog(
            barrierDismissible: false,
            context: context!,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: 1000,
                  padding: EdgeInsets.all(padding ?? 16.0),
                  child: widget,
                ),
              );
            },
          ) ??
          false;
    } catch (ex) {
      debugPrint(ex.toString());
      return false;
    }
  }
}
