import 'package:amax_hr/app/modules/navBar/views/nav_bar_view.dart';
import 'package:amax_hr/app/routes/app_pages.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/manager/auth_manager.dart';
import 'package:amax_hr/manager/shared_pref_service.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/utils/app_funcation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:frappe_dart/frappe_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  final RxBool obscurePassword = true.obs;

  final LocalAuthentication _localAuth = LocalAuthentication();
  final RxBool isBiometricAvailable = false.obs;

  var frappeClient;

  @override
  void onInit() {
    setData();
    checkBiometricSupport();
    super.onInit();
    frappeClient = FrappeV15(baseUrl: 'https://plastic.techcloudamax.ai/');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  setData() {
    emailController.text = "vignesh@amaxconsultancyservices.com";
    passwordController.text = "Welcome@@123#";
    //
    // emailController.text = "ankit22@yopmail.com";
    // passwordController.text = "Test@123";
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void checkBiometricSupport() async {
    try {
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final biometrics = await _localAuth.getAvailableBiometrics();
      isBiometricAvailable.value = isDeviceSupported;
      update();
    } catch (e) {
      isBiometricAvailable.value = false;
    }
  }

  void biometricLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final cookieHeader = prefs.getString(LocalKeys.cookieHeader) ?? '';

    // 🔒 Step 1: Check if cookie is stored
    if (cookieHeader.isEmpty) {
      Get.snackbar(
        "Login Required",
        "Please login using email and password first.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // ✅ Step 2: Proceed with biometric auth
    if (!isBiometricAvailable.value) {
      Get.snackbar(
        "Unavailable",
        "Biometric authentication not available on this device.",
        backgroundColor: Colors.grey,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        ApiService.dio.options.headers['cookie'] = cookieHeader;
        Get.offAll(() => NavBarView());
      } else {
        Get.snackbar(
          "Authentication Failed",
          "Biometric not recognized",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Biometric authentication error: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  login() async {
    EasyLoading.show();

    final authResponse = await frappeClient.login(
      LoginRequest(
        usr: emailController.text.trim(),
        pwd: passwordController.text.trim(),
      ),
    );

    EasyLoading.dismiss();

    final cookieString = authResponse.toJson().toString();

    final cookieRegex = RegExp(
      r'(full_name|sid|system_user|user_id|user_image)=([^;]+)',
    );
    final matches = cookieRegex.allMatches(cookieString);

    Map<String, String> cookieMap = {};
    for (final match in matches) {
      cookieMap[match.group(1)!] = match.group(2)!;
    }

    final cookieHeader = cookieMap.entries
        .map((e) => '${e.key}=${e.value}')
        .join('; ');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LocalKeys.cookieHeader, cookieHeader);

    print('✅ Stored Cookie: $cookieHeader');
    extractAndStoreUserInfo(cookieHeader);
    ApiService.dio.options.headers['cookie'] = cookieHeader;
    Get.offAll(() => NavBarView());
    print('✅ Dio cookie set!');
  }

  Future<void> extractAndStoreUserInfo(String cookieHeader) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LocalKeys.cookieHeader, cookieHeader);

    final parts = cookieHeader.split(';');
    String? sid, fullName, email;

    for (var part in parts) {
      final trimmed = part.trim();
      if (trimmed.startsWith("sid=")) {
        sid = trimmed.substring(4);
      } else if (trimmed.startsWith("full_name=")) {
        fullName = trimmed.substring(10);
      } else if (trimmed.startsWith("user_id=")) {
        email = Uri.decodeComponent(trimmed.substring(8));
      }
    }
    logger.d("get email>>>>${email}");

    if (sid != null) await prefs.setString(LocalKeys.sid, sid);
    if (fullName != null) await prefs.setString(LocalKeys.fullName, fullName);
    if (email != null) await prefs.setString(LocalKeys.userId, email);
  }

  void forgotPassword() {
    Get.snackbar(
      'Info',
      'Forgot password functionality not implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void goToSignUp() {
    Get.snackbar(
      'Info',
      'Sign up functionality not implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
