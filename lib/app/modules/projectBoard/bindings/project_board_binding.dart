import 'package:get/get.dart';

import '../controllers/project_board_controller.dart';

class ProjectBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectBoardController>(
      () => ProjectBoardController(),
    );
  }
}
