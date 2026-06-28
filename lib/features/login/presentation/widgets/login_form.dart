import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/routes/route_names.dart';
import 'package:touch/core/widgets/custom_text_field.dart';
import 'package:touch/core/widgets/general_button.dart';
import 'package:touch/core/widgets/mobile_text_form.dart';
import 'package:touch/features/login/presentation/cubit/login_cubit.dart';
import 'package:touch/features/login/presentation/widgets/biometric_row.dart';
import 'package:touch/features/login/presentation/widgets/divider_with_text.dart';
import 'package:touch/features/login/presentation/widgets/forgot_password_button.dart';
import 'package:touch/features/login/presentation/widgets/login_radio_button.dart';
import 'package:touch/generated/locale_keys.g.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _identifierController = TextEditingController();
    final _passwordController = TextEditingController();
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final isFormState = state is LoginFormState;
        final isLoading = state is LoginLoading;
        final isFailure = state is LoginFailure;

        if (!isFormState && !isLoading && !isFailure) {
          return const SizedBox.shrink();
        }

        final formState = state is LoginFormState ? state : null;
        final obscurePassword = formState?.obscurePassword ?? true;
        final loginMethod = cubit.currentLoginMethod;
        final identifierError = formState?.identifierError;
        final passwordError = formState?.passwordError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LoginRadioButton(
              selectedMethod: loginMethod,
              onMethodChanged: (newMethod) {
                _identifierController.clear();
                _passwordController.clear();
                cubit.changeLoginMethod(newMethod);
              },
              isLoading: isLoading,
            ),
            const SizedBox(height: 16),
            if (loginMethod == "phone")
              CustomPhoneField(
                controller: _identifierController,
                errorText: identifierError,
                onChanged: (_) => cubit.clearIdentifierError(),
                onCountryCodeChanged: (countryCode) =>
                    cubit.setCountryCode(countryCode),
                hint: LocaleKeys.login_hint_phone.tr(),
              )
            else
              CustomTextField(
                controller: _identifierController,
                hint: cubit.getHintText(loginMethod),
                enabled: !isLoading,
                errorText: identifierError,
                onChanged: (_) => cubit.clearIdentifierError(),
              ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              hint: LocaleKeys.login_hint_password.tr(),
              obscureText: obscurePassword,
              enabled: !isLoading,
              errorText: passwordError,
              onChanged: (_) => cubit.clearPasswordError(),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.darkD3,
                  size: 20,
                ),
                onPressed: () => cubit.togglePasswordVisibility(),
              ),
            ),
            const SizedBox(height: 10),
            ForgotPasswordButton(
              isLoading: isLoading,
              onPressed: () => context.push(RoutesName.forgotPassword.path),
            ),
            const SizedBox(height: 50),
            GeneralButton(
              isLoading: isLoading,
              onPressed: () {
                final identifier = _identifierController.text.trim();
                final password = _passwordController.text;
                cubit.validateAndLogin(
                  identifier,
                  password,
                  loginMethod: loginMethod,
                );
              },
            ),
            const SizedBox(height: 28),
            const DividerWithText(),
            const SizedBox(height: 20),
            BiometricRow(
              isLoading: isLoading,
              onFacePressed: () {},
              onFingerprintPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
