import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touch/core/constants/app_assets.dart';
import 'package:touch/features/login/presentation/widgets/biometric_button.dart';
import 'package:touch/generated/locale_keys.g.dart';

class BiometricRow extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onFacePressed;
  final VoidCallback? onFingerprintPressed;

  const BiometricRow({
    super.key,
    this.isLoading = false,
    this.onFacePressed,
    this.onFingerprintPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BiometricButton(
            label: LocaleKeys.login_biometric_fingerprint.tr(),
            icon: SvgPicture.asset(AppAssets.handIcon),
            onTap: isLoading ? null : onFingerprintPressed,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: BiometricButton(
            label: LocaleKeys.login_biometric_face.tr(),
            icon: SvgPicture.asset(AppAssets.faceIcon),
            onTap: isLoading ? null : onFacePressed,
          ),
        ),
      ],
    );
  }
}
