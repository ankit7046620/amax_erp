import 'package:get/get.dart';

import '../controllers/asset_dashboar_controller.dart';

class AssetDashboarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssetDashboardController>(
      () => AssetDashboardController(),
    );
  }
}
