import 'package:get/get.dart';

import '../controllers/sale_graph_controller.dart';

class SaleGraphBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaleGraphController>(
      () => SaleGraphController(),
    );
  }
}
