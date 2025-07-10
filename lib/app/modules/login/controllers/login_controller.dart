import 'package:amax_hr/app/routes/app_pages.dart';
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
        // baseUrl: 'https://192.168.1.7:8003/',
        baseUrl: 'https://hims.techcloudamax.ai/',
    );
  }


  // Future<void> login() async {
  //   //if (!formKey.currentState!.validate()) return;
  //   Map<String, dynamic> data={
  //     'usr': "rock@yopmail.com",
  //     'pwd':"rock@123",
  //   };
  //
  //
  //   final response =  ApiService.post("https://ankit.frappehr.com/app", data);
  //
  //   print("object=====>>$response");
  //   AppFunction.goToAndReplace(Routes.BOTTAM);
  //
  //   }

  login() async {

EasyLoading.show();
    print("======##>>>${frappeClient.baseUrl}");
    final authResponse = await frappeClient.login(
      LoginRequest(
        usr: 'bob@yopmail.com',
        pwd: 'Test@123',

        // usr: 'vignesh@amaxconsultancyservices.com',
        // pwd: 'Welcome@123#',
      ),

    );
EasyLoading.dismiss();
    print("====111==##>>>${authResponse.toJson()}");

    print("======##>>>${authResponse.fullName}");
    print("======##>>>${authResponse.homePage}");
    print("======##>>>${authResponse.userId}");
    print("======##>>>${authResponse.userId}");
    print("======##>>>${authResponse.toJson()}");

    final regex = RegExp(r'sid=([a-f0-9]+)');
    final match = regex.firstMatch(authResponse.toJson().toString());

final fullNameMatch = RegExp(r'full_name=([^;]+)').firstMatch(authResponse.toJson().toString());
final fullName = fullNameMatch?.group(1)??'';
String sid='';
    if (match != null) {
      String sessionId = match.group(1)!;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(LocalKeys.onboardingSeen, sid);
      prefs.setString(LocalKeys.fullName, fullName);

      sid= sessionId ;
      print('Session ID: $sessionId');
      AppFunction.setSessionFromLoginResponse(authResponse.toJson().toString());
    } else {
      print('Session ID not found');
    }

    if(sid !=''){
      AppFunction.goToAndReplace(Routes.BOTTAM);
    }


  }

getUserInfo(){
  FrappeV15   frappeClient = FrappeV15(
    baseUrl: ''
        '',
  );
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
