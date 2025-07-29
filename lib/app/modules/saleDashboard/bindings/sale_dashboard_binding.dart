import 'package:get/get.dart';

import '../controllers/sale_dashboard_controller.dart';

class SaleDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaleDashboardController>(
      () => SaleDashboardController(),
    );
  }
}
