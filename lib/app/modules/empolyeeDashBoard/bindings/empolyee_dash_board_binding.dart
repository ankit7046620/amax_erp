import 'package:get/get.dart';

import '../controllers/empolyee_dash_board_controller.dart';

class EmpolyeeDashBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmpolyeeDashBoardController>(
      () => EmpolyeeDashBoardController(),
    );
  }
}
