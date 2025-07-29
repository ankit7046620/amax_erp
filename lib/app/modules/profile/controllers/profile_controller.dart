import 'package:amax_hr/main.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/app.dart';

class ProfileController extends GetxController {
  String email = '';
  String name = '';

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString(LocalKeys.userId) ?? 'Not Available';
    name = prefs.getString(LocalKeys.fullName ) ?? 'User';
    update(); // Refresh UI
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Optional: clear all data
    Get.snackbar("Logout", "You have been logged out.");
  }


}