import 'package:local_auth/local_auth.dart';

class AuthService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> canUseBiometrics() async {
    try {
      final isSupported = await auth.isDeviceSupported();
      final canCheck = await auth.canCheckBiometrics;
      final available = await auth.getAvailableBiometrics();

      return isSupported && canCheck && available.isNotEmpty;
    } catch (e) {
      print("Biometric check error: $e");
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      print("Authentication error: $e");
      return false;
    }
  }
}
