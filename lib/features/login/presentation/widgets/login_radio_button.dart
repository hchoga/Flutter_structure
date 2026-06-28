import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';
import 'package:touch/generated/locale_keys.g.dart';

class LoginRadioButton extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;
  final bool isLoading;

  const LoginRadioButton({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4, // 👈 shadow here
      shadowColor: Colors.black.withOpacity(0.2),
      borderRadius: BorderRadius.circular(15),
      color: context.colors.surface,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 1.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: _RadioOption(
                label: LocaleKeys.login_method_phone.tr(),
                value: 'phone',
                selectedValue: selectedMethod,
                enabled: true,
                onChanged: onMethodChanged,
              ),
            ),
            Expanded(
              child: _RadioOption(
                label: LocaleKeys.login_method_email.tr(),
                value: 'email',
                selectedValue: selectedMethod,
                enabled: true,
                onChanged: onMethodChanged,
              ),
            ),
            Expanded(
              child: _RadioOption(
                label: LocaleKeys.login_method_civil_id.tr(),
                value: 'civil_id',
                selectedValue: selectedMethod,
                enabled: true,
                onChanged: onMethodChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final bool enabled;
  final ValueChanged<String> onChanged;

  const _RadioOption({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedValue,
          onChanged: enabled
              ? (newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                }
              : null,
          activeColor: AppColors.primaryMain,
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
        Expanded(
          child: Text(
            label,
            style: context.textTheme.bodySmallRegular.copyWith(
              color: enabled ? null : AppColors.darkD3.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
