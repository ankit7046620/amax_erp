import 'dart:ui';

import 'package:amax_hr/app/routes/app_pages.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:amax_hr/constant/localel.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/utils/app_funcation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  PageController controller= PageController();

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

  Future<void> gotoNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(LocalKeys.onboardingSeen, true);

    AppFunction.goToAndReplace(Routes.LOGIN);
  }
  List<OnboardingContents> contents = [
    OnboardingContents(
      title: LabelConstants.onboarding1,
      image: AssetsConstant.Onbording1,
      desc: LabelConstants.dec1,
    ),
    OnboardingContents(
      title: LabelConstants.onboarding2,
      image: AssetsConstant.Onbording2,
      desc: LabelConstants.dec2,
    ),
    OnboardingContents(
      title: LabelConstants.onboarding3,
      image: AssetsConstant.Onbording3,
      desc: LabelConstants.dec3,
    ),
  ];
  final RxInt currentPage = 0.obs;
  List colors = const [
    Color(0xffDAD3C8),
    Color(0xffFFE5DE),
    Color(0xffDCF6E6),
  ];
}
class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}
