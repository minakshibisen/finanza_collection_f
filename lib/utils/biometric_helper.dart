import 'package:finanza_collection_f/utils/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../common/common_toast.dart';
import '../ui/auth/pin/check_pin_screen.dart';
import '../ui/home/home_screen.dart';

enum BiometricState {
  unknown,
  available,
  unavailable,
  authenticated,
  failed,
  unsupported
}

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<BiometricState> checkBiometricSupport() async {
    try {
      final isDeviceSupported = await _auth.isDeviceSupported();
      if (!isDeviceSupported) {
        return BiometricState.unsupported;
      }

      final canCheckBiometrics = await _auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        return BiometricState.unavailable;
      }

      return BiometricState.available;
    } catch (e) {
      debugPrint('Error checking biometric support: $e');
      return BiometricState.unknown;
    }
  }

  // Authenticate using biometrics
  static Future<BiometricState> authenticate({
    String localizedReason = 'Please authenticate to continue',
  }) async {
    try {
      final biometricState = await checkBiometricSupport();
      if (biometricState != BiometricState.available) {
        return biometricState;
      }

      final authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      return authenticated
          ? BiometricState.authenticated
          : BiometricState.failed;
    } catch (e) {
      debugPrint('Error during biometric authentication: $e');
      return BiometricState.failed;
    }
  }
}

extension BiometricAuthHandler on State<CheckPinScreen> {
  Future<void> handleBiometricAuth(BuildContext context) async {
    final biometricEnabled = await SessionHelper.getBioEnabled();
    if (!biometricEnabled) return;

    if (!mounted) return;

    final result = await BiometricService.authenticate();

    if (!context.mounted) return;
    switch (result) {
      case BiometricState.authenticated:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;

      case BiometricState.unsupported:
      case BiometricState.unavailable:
        CommonToast.showToast(
          context: context,
          title: "Biometric Unavailable",
          description: "Biometric verification unavailable!",
        );
        break;

      case BiometricState.failed:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Biometric Validation Failed!")),
        );
        break;

      default:
        // Handle unknown states if needed
        break;
    }
  }
}
