import 'package:get/get.dart';

import '../controllers/hr_setting_controller.dart';

class HrSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrSettingController>(
      () => HrSettingController(),
    );
  }
}
