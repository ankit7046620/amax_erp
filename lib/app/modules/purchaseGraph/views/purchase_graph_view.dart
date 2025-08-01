import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/purchase_graph_controller.dart';

class PurchaseGraphView extends GetView<PurchaseGraphController> {
  const PurchaseGraphView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(PurchaseGraphController());
    return Scaffold(
        appBar:CommonAppBar(imagePath: AssetsConstant.tech_logo,showBack: true,),

      body: const Center(
        child: Text(
          'PurchaseGraphView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
