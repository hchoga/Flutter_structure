import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';

class DateField extends StatelessWidget {
  final String hint;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final double? height;
  const DateField({
    required this.hint,
    required this.value,
    required this.onTap,
    this.onClear,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 42.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkD3.withOpacity(0.08),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.isEmpty ? hint : value,
              style: context.textTheme.bodySmallRegular.copyWith(
                color: AppColors.darkD3,
              ),
            ),
            if (onClear != null && value.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close, size: 16.sp, color: AppColors.darkD3),
              )
            else
              Icon(
                Icons.calendar_today_outlined,
                size: 18.sp,
                color: AppColors.darkD3,
              ),
          ],
        ),
      ),
    );
  }
}
