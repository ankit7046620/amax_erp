import 'package:get/get.dart';

import '../controllers/nav_bar_controller.dart';

class NavBarBinding extends Bindings {
  @override
  void dependencies() {
    print('NavBarBinding.dependencies() called');
    Get.lazyPut<NavBarController>(
      () {
        print('Creating NavBarController instance');
        return NavBarController();
      },
    );
  }
}
