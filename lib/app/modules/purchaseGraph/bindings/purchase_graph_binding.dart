import 'package:get/get.dart';

import '../controllers/purchase_graph_controller.dart';

class PurchaseGraphBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseGraphController>(
      () => PurchaseGraphController(),
    );
  }
}
