import 'package:amax_hr/app/modules/AttendanceDashboard/views/attendance_dashboard_view.dart';
import 'package:amax_hr/app/modules/hrAdmin/views/hr_admin_view.dart';
import 'package:amax_hr/app/modules/hrReqirement/views/hr_reqirement_view.dart';
import 'package:amax_hr/app/modules/hrSetting/views/hr_setting_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HrViewController extends GetxController {
  //TODO: Implement HrViewController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  final List<Widget> pages = [
    HrAdminView(),
    HrReqirementView(),
    AttendanceDashboardView(),
    HrSettingView(),
  ];

  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
