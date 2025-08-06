import 'package:get/get.dart';

import '../controllers/employee_checkin_controller.dart';

class EmployeeCheckinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeCheckinController>(
      () => EmployeeCheckinController(),
    );
  }
}
