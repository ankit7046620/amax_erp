import 'package:get/get.dart';

import '../controllers/hr_view_controller.dart';

class HrViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrViewController>(
      () => HrViewController(),
    );
  }
}
