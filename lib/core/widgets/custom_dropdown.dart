import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';

import '../models/drop_down_item_model.dart';

class CustomDropDownButton extends StatefulWidget {
  final String hint;
  final List<DropdownItemModel> items;
  final Function(DropdownItemModel?)? onChanged;
  final DropdownItemModel? selectedItem;

  /// When true, a spinner replaces the dropdown content (e.g. while the items
  /// are being fetched).
  final bool isLoading;

  const CustomDropDownButton({
    Key? key,
    required this.hint,
    required this.items,
    this.onChanged,
    this.selectedItem,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  late DropdownItemModel? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  @override
  void didUpdateWidget(CustomDropDownButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      _selectedItem = widget.selectedItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
      child: widget.isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.hint,
                  style: context.textTheme.bodySmallRegular.copyWith(
                    color: AppColors.darkD3,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primaryMain,
                  ),
                ),
              ],
            )
          : DropdownButton<DropdownItemModel>(
              value: _selectedItem,
              isExpanded: true,
              underline: const SizedBox(),
              icon: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(Icons.arrow_drop_down, color: AppColors.darkD3),
              ),
              hint: Text(
                widget.hint,
                style: context.textTheme.bodySmallRegular.copyWith(
                  color: AppColors.darkD3,
                ),
                textDirection: TextDirection.rtl,
              ),
              items: widget.items.map((item) {
                return DropdownMenuItem<DropdownItemModel>(
                  value: item,
                  enabled: item.enabled,
                  child: Text(
                    item.label,
                    style: context.textTheme.bodySmallRegular.copyWith(
                      color: item.enabled ? AppColors.darkD3 : AppColors.darkD2,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (DropdownItemModel? newValue) {
                setState(() {
                  _selectedItem = newValue;
                });
                widget.onChanged?.call(newValue);
              },
            ),
    );
  }
}
