import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/empolyee_dash_board_controller.dart';

class EmpolyeeDashBoardView extends GetView<EmpolyeeDashBoardController> {
  const EmpolyeeDashBoardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EmpolyeeDashBoardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EmpolyeeDashBoardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
