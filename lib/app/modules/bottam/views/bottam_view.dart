import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bottam_controller.dart';

class BottamView extends GetView<BottamController> {
  const BottamView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(BottamController());
    return Scaffold(
      appBar: AppBar(title: Text("Modules")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.moduleNames.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3, // adjust height
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                controller.handleModule(controller.moduleNames[index]);
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    controller.moduleNames[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

