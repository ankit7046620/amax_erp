import 'package:get/get.dart';

import '../controllers/attendence_board_controller.dart';

class AttendenceBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendenceBoardController>(
      () => AttendenceBoardController(),
    );
  }
}
