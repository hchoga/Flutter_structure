import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:touch/core/constants/app_assets.dart';
import 'package:touch/core/constants/app_colors.dart';
import 'package:touch/core/routes/route_names.dart';
import 'package:touch/core/theme/extension/text_style_extension.dart';
import 'package:touch/core/utils/show_toast.dart';
import 'package:touch/features/login/presentation/cubit/login_cubit.dart';
import 'package:touch/features/login/presentation/widgets/login_form.dart';
import 'package:touch/generated/locale_keys.g.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.surface,
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  LocaleKeys.login_welcome_message.tr(args: [state.user.name]),
                ),
                backgroundColor: AppColors.primaryMain,
              ),
            );
            context.go(RoutesName.home.path);
          } else if (state is LoginFailure) {
            ShowToast.showToastError(message: state.message, context: context);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Language Selector
                _buildLanguageSelector(context),

                // FIX: Remove SizedBox(height: 8) — illustration sits closer
                // to the language selector in the design, no extra gap needed

                // Illustration
                // FIX: Constrain image height to match design proportions
                // The image fills the width but doesn't take up too much vertical space
                SizedBox(
                  height: 180,
                  child: Image.asset(AppAssets.loginImage, fit: BoxFit.contain),
                ),

                const SizedBox(height: 24),

                // Welcome text
                _buildWelcomeSection(context),

                const SizedBox(height: 32),

                // Login Form
                 LoginForm(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Row(
        children: [
          PopupMenuButton<Locale>(
            onSelected: (Locale value) {
              context.setLocale(value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: Locale('en'),
                child: Center(
                  child: Text("English", style: context.textTheme.bodyMedium),
                ),
              ),
              PopupMenuItem(
                value: Locale('ar'),
                child: Center(
                  child: Text("العربية", style: context.textTheme.bodyMedium),
                ),
              ),
            ],

            // Optional: position & styling tweaks
            offset: const Offset(0, 40),

            child: Text(
              LocaleKeys.login_language.tr(),
              style: context.textTheme.bodyMediumMedium,
            ),
          ),
          Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.chevron_right,
              color: context.colors.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.login_welcome_back.tr(),
          textAlign: TextAlign.center,
          // FIX: Use h1 bold style — the title is clearly larger and bolder
          // than the subtitle in the design
          style: context.textTheme.h1,
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.login_please_sign_in.tr(),
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMediumRegular.copyWith(
            color: AppColors.darkD3,
          ),
        ),
      ],
    );
  }
}
