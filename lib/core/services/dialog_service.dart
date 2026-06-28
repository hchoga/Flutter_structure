import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
              color: Colors.white,
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
                backgroundColor: Colors.white,
                child: Icon(Icons.accessible),
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
