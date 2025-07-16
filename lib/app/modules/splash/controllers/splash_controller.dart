import 'package:amax_hr/app/routes/app_pages.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/utils/app_funcation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateBasedOnOnboarding();
  }

  Future<void> _navigateBasedOnOnboarding() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = true;

    if (seen) {

      AppFunction.goToNextScreen(Routes.LOGIN);
    } else {
      AppFunction.goToAndReplace(Routes.ONBOARDING);
    }
  }
}
