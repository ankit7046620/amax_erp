import 'package:get/get.dart';

import '../controllers/attendance_dashboard_controller.dart';

class AttendanceDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceDashboardController>(
      () => AttendanceDashboardController(),
    );
  }
}
