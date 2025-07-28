import 'package:get/get.dart';

import '../controllers/hr_dashboar_controller.dart';

class HrDashboarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HrDashboarController>(
      () => HrDashboarController(),
    );
  }
}
