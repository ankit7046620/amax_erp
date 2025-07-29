import 'package:get/get.dart';

import '../controllers/stock_dashboard_controller.dart';

class StockDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StockDashboardController>(
      () => StockDashboardController(),
    );
  }
}
