import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';

class CustomPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCountryCodeChanged;

  const CustomPhoneField({
    super.key,
    required this.controller,
    required this.hint,
    this.errorText,
    this.onChanged,
    this.onCountryCodeChanged,
  });

  @override
  State<CustomPhoneField> createState() => _CustomPhoneFieldState();
}

class _CustomPhoneFieldState extends State<CustomPhoneField> {
  Country _selectedCountry = Country(
    phoneCode: '20',
    countryCode: 'EG',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Kuwait',
    example: '50123456',
    displayName: 'Kuwait',
    displayNameNoCountryCode: 'Kuwait',
    e164Key: '',
  );

  @override
  Widget build(BuildContext context) {
    final bool hasError =
        widget.errorText != null && widget.errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IntrinsicHeight(
          // ✅ keeps both same height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 📱 Phone Field
              Expanded(
                flex: 9,
                child: Material(
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  color: context.colors.surface,
                  child: TextFormField(
                    controller: widget.controller,
                    keyboardType: TextInputType.phone,
                    style: context.textTheme.bodySmallRegular,
                    onChanged: widget.onChanged,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: widget.hint,
                      hintStyle: context.textTheme.bodySmallRegular.copyWith(
                        color: AppColors.darkD3,
                      ),

                      errorText: null,
                      errorStyle: const TextStyle(height: 0),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: hasError
                              ? AppColors.error
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: hasError
                              ? AppColors.error
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                flex: 3,

                child: Material(
                  /// 🌍 Country Picker
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  color: context.colors.surface,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        onSelect: (Country country) {
                          setState(() => _selectedCountry = country);
                          widget.onCountryCodeChanged?.call(
                            "+${country.phoneCode}",
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      child: Center(
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // ✅ important
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _selectedCountry.flagEmoji,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '+${_selectedCountry.phoneCode}',
                              style: context.textTheme.bodySmallRegular,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// ❌ Error text
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 8),
            child: Text(
              widget.errorText!,
              textAlign: TextAlign.right,
              style: context.textTheme.bodySmallRegular.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}
