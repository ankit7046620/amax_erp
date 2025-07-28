import 'package:amax_hr/common/component/custom_image_widget.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: controller.scaleAnimation,
          child: CustomImageWidget(
            imagePath: AssetsConstant.tech_logo,
            fit: BoxFit.contain,
            height: 100,
            width: 100,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
