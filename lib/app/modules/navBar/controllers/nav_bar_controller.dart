import 'package:amax_hr/app/modules/homeTab/views/home_tab_view.dart';
import 'package:amax_hr/app/modules/notification/views/notification_view.dart';
import 'package:amax_hr/app/modules/profile/views/profile_view.dart';
import 'package:amax_hr/app/modules/settings/views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavBarController extends GetxController {
  //TODO: Implement NavBarController

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
    HomeTabView(),
    NotificationView(),
    SettingsView(),
    ProfileView(),
  ];

  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
