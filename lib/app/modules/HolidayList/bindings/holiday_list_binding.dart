import 'package:get/get.dart';

import '../controllers/holiday_list_controller.dart';

class HolidayListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HolidayListController>(
      () => HolidayListController(),
    );
  }
}
