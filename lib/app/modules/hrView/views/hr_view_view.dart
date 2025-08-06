import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/hr_view_controller.dart';

class HrViewView extends GetView<HrViewController> {
  const HrViewView({super.key});
  @override
  Widget build(BuildContext context) {
Get.put(HrViewController());
    return Obx(() => Scaffold(
      appBar:CommonAppBar(imagePath: AssetsConstant.tech_logo,showBack: true,),
      body: controller.pages[controller.currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTab,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    ));
  }
}