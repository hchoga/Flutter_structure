part of 'login_cubit.dart';

sealed class LoginState {
  const LoginState();

  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginFormState extends LoginState {
  final bool obscurePassword;
  final String loginMethod;
  final String? identifierError;
  final String? passwordError;

  const LoginFormState({
    this.obscurePassword = true,
    this.loginMethod = 'phone',
    this.identifierError,
    this.passwordError,
  });

  LoginFormState copyWith({
    bool? obscurePassword,
    String? loginMethod,
    String? identifierError,
    String? passwordError,
  }) {
    return LoginFormState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      loginMethod: loginMethod ?? this.loginMethod,
      identifierError: identifierError,
      passwordError: passwordError,
    );
  }

  @override
  List<Object?> get props => [
    obscurePassword,
    loginMethod,
    identifierError,
    passwordError,
  ];
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  final User user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class LoginFailure extends LoginState {
  final String message;
  final Map<String, String>? fieldErrors;

  const LoginFailure(this.message, {this.fieldErrors});

  @override
  List<Object?> get props => [message, fieldErrors];
}

final class LogoutSuccess extends LoginState {
  const LogoutSuccess();
}
