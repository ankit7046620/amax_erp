import 'package:get/get.dart';

import '../controllers/hr_admin_controller.dart';

class HrAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrAdminController>(
      () => HrAdminController(),
    );
  }
}
