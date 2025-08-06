import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/hr_reqirement_controller.dart';

class HrReqirementView extends GetView<HrReqirementController> {
  const HrReqirementView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HrReqirementView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HrReqirementView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
