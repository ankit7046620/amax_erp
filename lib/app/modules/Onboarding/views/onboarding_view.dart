import 'package:amax_hr/utils/size_config.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  AnimatedContainer _buildDots({required int index, required int currentPage}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return GetBuilder<OnboardingController>(
      init: OnboardingController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: controller.colors[controller.currentPage.value],
          body: SafeArea(
            child: Column(
              children: [
                _getImage(controller: controller, width: width, height: height),
                _getContent(
                  controller: controller,
                  width: width,
                  height: height,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getImage({
    required OnboardingController controller,
    required double height,
    required double width,
  }) {
    return Expanded(
      flex: 3,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        controller: controller.controller,
        onPageChanged: (value) {
          controller.currentPage.value = value;
          controller.update();
        },
        itemCount: controller.contents.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(child: Image.asset(controller.contents[i].image)),
                SizedBox(height: height >= 840 ? 60 : 30),
                Text(
                  controller.contents[i].title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w600,
                    fontSize: (width <= 550) ? 30 : 35,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  controller.contents[i].desc,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                    fontWeight: FontWeight.w300,
                    fontSize: (width <= 550) ? 17 : 25,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getContent({
    required OnboardingController controller,
    required double height,
    required double width,
  }) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.contents.length,
                  (index) => _buildDots(
                index: index,
                currentPage: controller.currentPage.value,
              ),
            ),
          ),
          controller.currentPage.value == controller.contents.length - 1
              ? Padding(
            padding: const EdgeInsets.all(30),
            child:
            _startButton(controller: controller,width: width),
          )
              : Padding(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _skipButton(controller: controller, width: width),
                _nextButton(controller: controller, width: width)
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _skipButton({required  OnboardingController controller,required double width }){
    return     TextButton(
      onPressed: () => controller.controller.jumpToPage(2),
      style: TextButton.styleFrom(
        textStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: (width <= 550) ? 13 : 17,
        ),
      ),
      child: const Text(
        "SKIP",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
  Widget _nextButton({required  OnboardingController controller,required double width }){
    return
      ElevatedButton(
        onPressed: () {
          controller.controller.nextPage(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        },
        child: const Text("NEXT"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: (width <= 550)
              ? const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          )
              : const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 25,
          ),
          textStyle: TextStyle(
            fontSize: (width <= 550) ? 13 : 17,
          ),
        ),
      );
  }

  Widget _startButton({required  OnboardingController controller,required double width }){
    return
      ElevatedButton(
        onPressed: () => controller.gotoNextScreen(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: (width <= 550)
              ? const EdgeInsets.symmetric(
            horizontal: 100,
            vertical: 20,
          )
              : EdgeInsets.symmetric(
            horizontal: width * 0.2,
            vertical: 25,
          ),
          textStyle: TextStyle(fontSize: (width <= 550) ? 13 : 17),
        ),
        child: const Text("START"),
      );
  }

}
