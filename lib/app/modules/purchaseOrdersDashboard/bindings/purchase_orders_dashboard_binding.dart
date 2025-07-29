import 'package:get/get.dart';

import '../controllers/purchase_orders_dashboard_controller.dart';

class PurchaseOrdersDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseOrdersDashboardController>(
      () => PurchaseOrdersDashboardController(),
    );
  }
}
