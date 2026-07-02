import 'package:local_auth/local_auth.dart';

abstract class BiometricService {
  Future<bool> canAuthenticate();
  Future<bool> authenticate();
  Future<List<BiometricType>> getAvailableBiometrics();
}

class BiometricServiceImpl implements BiometricService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  Future<bool> canAuthenticate() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: "reason",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }
}
