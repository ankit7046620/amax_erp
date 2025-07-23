import 'package:amax_hr/main.dart';
import 'package:amax_hr/vo/purchase_order_model.dart';
import 'package:get/get.dart';

class PurchaseGraphController extends GetxController {
  //TODO: Implement PurchaseGraphController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    _loadPassedData();
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
  List<PurchaseOrderDataList> purchaseOrders = [];
  List<Map<String, dynamic>> purchaseOrdersData = [];

  void _loadPassedData() {
    final args = Get.arguments;
    logger.d('✅ Purchase data args: $args');

    if (args is Map && args.containsKey('model')) {
      final String module = args['module'];
      final List<PurchaseOrderDataList> receivedList =
      List<PurchaseOrderDataList>.from(args['model']);

      purchaseOrders = receivedList;
      purchaseOrdersData = receivedList.map((e) => e.toJson()).toList();





      logger.d('✅ Loaded ${purchaseOrders.length} purchase items for module: $module');
    } else {
      logger.e('❌ Invalid or missing purchase data in arguments');
    }
  }
}
