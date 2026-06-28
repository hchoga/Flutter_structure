import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/features/login/domain/entities/user.dart';
import 'package:touch/features/login/domain/usecases/login_usecase.dart';
import 'package:touch/features/login/domain/usecases/logout_usecase.dart';
import 'package:touch/features/login/presentation/widgets/login_validation.dart';
import 'package:touch/generated/locale_keys.g.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  String _currentLoginMethod = 'phone'; // Track selected method separately
  String _currentCountryCode = 'EG'; // Track selected country code

  LoginCubit({required this.loginUseCase, required this.logoutUseCase})
    : super(const LoginFormState());

  String get currentLoginMethod => _currentLoginMethod;
  String get currentCountryCode => _currentCountryCode;

  void setCountryCode(String countryCode) {
    _currentCountryCode = countryCode;
  }

  void initializeForm() {
    _currentLoginMethod = 'phone';
    _currentCountryCode = 'EG';
    emit(const LoginFormState());
  }

  void togglePasswordVisibility() {
    if (state is LoginFormState) {
      final formState = state as LoginFormState;
      emit(formState.copyWith(obscurePassword: !formState.obscurePassword));
    }
  }

  void changeLoginMethod(String newMethod) {
    _currentLoginMethod = newMethod;

    if (state is LoginFormState) {
      final formState = state as LoginFormState;
      emit(formState.copyWith(identifierError: null));
    } else if (state is LoginFailure) {
      // If in failure state, return to form state
      emit(const LoginFormState());
    }
    // If loading, just update the property, don't emit
  }

  void clearIdentifierError() {
    if (state is LoginFormState) {
      final formState = state as LoginFormState;
      if (formState.identifierError != null) {
        emit(formState.copyWith(identifierError: null));
      }
    }
  }

  void clearPasswordError() {
    if (state is LoginFormState) {
      final formState = state as LoginFormState;
      if (formState.passwordError != null) {
        emit(formState.copyWith(passwordError: null));
      }
    }
  }

  String getHintText(String loginMethod) {
    switch (loginMethod) {
      case 'phone':
        return LocaleKeys.login_hint_phone.tr();
      case 'email':
        return LocaleKeys.login_hint_email.tr();
      case 'civil_id':
        return LocaleKeys.login_hint_civil_id.tr();
      default:
        return LocaleKeys.login_hint_identifier_default.tr();
    }
  }

  bool validateInput(String identifier, String password, String loginMethod) {
    bool isValid = true;
    String? identifierError;
    String? passwordError;

    if (identifier.isEmpty) {
      identifierError = LoginValidation.getIdentifierErrorMessage(loginMethod);
      isValid = false;
    } else if (!LoginValidation.isValidIdentifier(identifier, loginMethod)) {
      identifierError = LoginValidation.getIdentifierFormatErrorMessage(
        loginMethod,
      );
      isValid = false;
    }

    if (password.isEmpty) {
      passwordError = LocaleKeys.login_error_password_required.tr();
      isValid = false;
    } else if (password.length < 6) {
      passwordError = LocaleKeys.login_error_password_too_short.tr();
      isValid = false;
    }

    if (state is LoginFormState) {
      final formState = state as LoginFormState;
      emit(
        formState.copyWith(
          identifierError: identifierError,
          passwordError: passwordError,
        ),
      );
    }

    return isValid;
  }

  Future<void> validateAndLogin(
    String identifier,
    String password, {
    String loginMethod = 'phone',
  }) async {
    if (!validateInput(identifier, password, loginMethod)) {
      return;
    }

    await login(identifier, password, loginMethod: loginMethod);
  }

  Future<void> login(
    String identifier,
    String password, {
    String loginMethod = 'email',
  }) async {
    _currentLoginMethod = loginMethod;
    emit(const LoginLoading());
    final result = await loginUseCase(
      LoginParams(
        email: identifier,
        password: password,
        loginMethod: loginMethod,
        countryCode: loginMethod == 'phone' ? _currentCountryCode : null,
      ),
    );
    result.fold((failure) {
      final message = failure is ServerFailure
          ? failure
                .displayMessage // Shows the specific Arabic validation error
          : failure.message;

      emit(LoginFailure(message));
    }, (user) => emit(LoginSuccess(user)));
  }

  Future<void> logout() async {
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (_) => emit(const LogoutSuccess()),
    );
  }
}
