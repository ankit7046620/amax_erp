import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/attendence_board_controller.dart';

class AttendenceBoardView extends GetView<AttendenceBoardController> {
  const AttendenceBoardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AttendenceBoardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AttendenceBoardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
