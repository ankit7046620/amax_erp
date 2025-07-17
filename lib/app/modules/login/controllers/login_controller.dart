import 'package:amax_hr/app/routes/app_pages.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/manager/shared_pref_service.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/utils/app_funcation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:frappe_dart/frappe_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
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

  var frappeClient;
  void onInit() {
    super.onInit();
      frappeClient = FrappeV15(
        // baseUrl: 'https://192.168.1.7:8003/',  //local
        baseUrl: 'https://plastic.techcloudamax.ai/',
    );
      setData();
  }




  void setData(){
    emailController.text="vignesh@amaxconsultancyservices.com";
    passwordController.text="Welcome@@123#";
    update();
  }

  login() async {
    EasyLoading.show();

    final authResponse = await frappeClient.login(
      LoginRequest(
        usr: 'vignesh@amaxconsultancyservices.com',
        pwd: 'Welcome@@123#',
      ),
    );

    EasyLoading.dismiss();

    final cookieString = authResponse.toJson().toString();

    final cookieRegex = RegExp(r'(full_name|sid|system_user|user_id|user_image)=([^;]+)');
    final matches = cookieRegex.allMatches(cookieString);

    Map<String, String> cookieMap = {};
    for (final match in matches) {
      cookieMap[match.group(1)!] = match.group(2)!;
    }

    // Build cookie header
    final cookieHeader = cookieMap.entries.map((e) => '${e.key}=${e.value}').join('; ');

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LocalKeys.cookieHeader, cookieHeader);

    print('✅ Stored Cookie: $cookieHeader');

    ApiService.dio.options.headers['cookie'] = cookieHeader;



    print('✅ Dio cookie set!');

    if (cookieMap['sid']?.isNotEmpty ?? false) {
      AppFunction.goToAndReplace(Routes.BOTTAM);
    } else {
      print('❌ Session ID not found');
    }
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
