import 'dart:io';

import 'package:get/get.dart';

class TaskController extends GetxController {
  //TODO: Implement TaskController

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

  var date = DateTime.now().obs;
  var assignedTo = ''.obs;
  var description = ''.obs;
  var file = Rx<File?>(null);
}
