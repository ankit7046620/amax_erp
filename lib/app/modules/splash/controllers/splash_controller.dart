import 'package:amax_hr/app/routes/app_pages.dart';
import 'package:amax_hr/utils/app_funcation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();

    // Set up zoom animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    _navigateBasedOnOnboarding();
  }

  Future<void> _navigateBasedOnOnboarding() async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = true; // your logic for onboarding screen

    if (seen) {
      AppFunction.goToNextScreen(Routes.LOGIN);
    } else {
      AppFunction.goToAndReplace(Routes.ONBOARDING);
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
