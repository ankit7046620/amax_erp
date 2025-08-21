import 'package:amax_hr/app/modules/homeTab/views/home_tab_view.dart';
import 'package:amax_hr/app/modules/notification/views/notification_view.dart';
import 'package:amax_hr/app/modules/profile/views/profile_view.dart';
import 'package:amax_hr/app/modules/settings/views/settings_view.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../calendar/views/calendar_view.dart';

class NavBarController extends GetxController {
  //TODO: Implement NavBarController

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // getAllModules();
    // You can also fetch modules here if needed
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
    HomeTabView(),
    CalendarView(),
    //NotificationView(),
    SettingsView(),
    ProfileView(),
  ];

  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  List<String> modules = [];

  Future<void> getAllModules() async {
    final prefs = await SharedPreferences.getInstance();

    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['modules'] != null) {
      modules = args['modules'];
      await prefs.setStringList(LocalKeys.module, modules);
    }
    update();
    logger.d("modulesget>>>>>>>${modules}");
  }
}
