import 'package:get/get.dart';

import '../controllers/bottam_controller.dart';

class BottamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottamController>(
      () => BottamController(),
    );
  }
}
