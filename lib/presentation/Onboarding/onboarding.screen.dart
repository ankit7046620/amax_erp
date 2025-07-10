import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/onboarding.controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnboardingScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OnboardingScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
