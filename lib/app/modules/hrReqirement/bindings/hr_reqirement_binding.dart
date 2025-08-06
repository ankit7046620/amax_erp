import 'package:get/get.dart';

import '../controllers/hr_reqirement_controller.dart';

class HrReqirementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrReqirementController>(
      () => HrReqirementController(),
    );
  }
}
