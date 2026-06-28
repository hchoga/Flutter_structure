import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:touch/generated/locale_keys.g.dart';

final class ShowToast {
  static final FToast _fToast = FToast();

  /// MUST be called once inside a widget with context
  static void init(BuildContext context) {
    _fToast.init(context);
  }

  static void _showCustomToast({
    required Widget child,
    required ToastGravity gravity,
    required int seconds,
  }) {
    _fToast.showToast(
      child: child,
      gravity: gravity,
      toastDuration: Duration(seconds: seconds),
      // Position from the overlay's own context so the toast is lifted above
      // the on-screen keyboard (its `viewInsets.bottom`) instead of being
      // hidden behind it.
      positionedToastBuilder: (context, child, gravity) {
        final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
        switch (gravity) {
          case ToastGravity.TOP:
          case ToastGravity.TOP_LEFT:
          case ToastGravity.TOP_RIGHT:
            return Positioned(top: 100, left: 24, right: 24, child: child);
          case ToastGravity.CENTER:
          case ToastGravity.CENTER_LEFT:
          case ToastGravity.CENTER_RIGHT:
            return Positioned(
              top: 50,
              bottom: 50,
              left: 24,
              right: 24,
              child: child,
            );
          case ToastGravity.BOTTOM:
          default:
            return Positioned(
              bottom: 50 + keyboardInset,
              left: 24,
              right: 24,
              child: child,
            );
        }
      },
    );
  }

  // -----------------------------
  //        ERROR TOAST
  // -----------------------------
  static void showToastError({
    required String message,
    int? seconds,
    ToastGravity gravity = ToastGravity.BOTTOM,
    required BuildContext context,
  }) {
    init(context);
    final toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(14), // border radius
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    _showCustomToast(child: toast, gravity: gravity, seconds: seconds ?? 2);
  }

  // -----------------------------
  //        LOADING TOAST
  // -----------------------------
  static void showToastLoading({
    String? message,
    int? seconds,
    ToastGravity gravity = ToastGravity.BOTTOM,
    required BuildContext context,
  }) {
    init(context);
    final toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(14), // border radius
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message ?? '${LocaleKeys.loading.tr()}...',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );

    _showCustomToast(child: toast, gravity: gravity, seconds: seconds ?? 2);
  }

  // -----------------------------
  //        SUCCESS TOAST
  // -----------------------------
  static void showToastSuccess({
    required String message,
    int? seconds,
    ToastGravity gravity = ToastGravity.BOTTOM,
    required BuildContext context,
  }) {
    init(context);
    final toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(14), // border radius
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );

    _showCustomToast(child: toast, gravity: gravity, seconds: seconds ?? 2);
  }
}
