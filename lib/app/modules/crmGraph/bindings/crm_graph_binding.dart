import 'package:get/get.dart';

import '../controllers/crm_graph_controller.dart';

class CrmGraphBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrmGraphController>(
      () => CrmGraphController(),
    );
  }
}
