import 'package:amax_hr/main.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/vo/purchase_order_model.dart';
import 'package:get/get.dart';

class ChartFilterType {
  static const String yearly = 'Yearly';
  static const String quarterly = 'Quarterly';
  static const String monthly = 'Monthly';
  static const String weekly = 'Weekly';
  static const String daily = 'Daily';
}

class PurchaseOrdersDashboardController extends GetxController {
  // Observables
  final RxInt count = 0.obs;
  final RxDouble totalPurchaseAmount = 0.0.obs;

  final RxInt pOrdersToReceive = 0.obs;
  final RxInt pOrdersToBill = 0.obs;
  final RxInt activeSuppliers = 0.obs;

  List<PurchaseOrderDataList> purchaseOrders = [];
  List<Map<String, dynamic>> purchaseOrdersData = [];

  static const List<String> chartFilters = [
    ChartFilterType.yearly,
    ChartFilterType.quarterly,
    ChartFilterType.monthly,
    ChartFilterType.weekly,
    ChartFilterType.daily,
  ];

  final RxMap<String, RxString> filterTypeMap = {
    'PURCHASES': ChartFilterType.monthly.obs,
    'Purchase Orders to Receive': ChartFilterType.monthly.obs,
    'Purchase Orders to Bill': ChartFilterType.monthly.obs,
    'Active Suppliers': ChartFilterType.monthly.obs,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPassedData();
  }

  void _loadPassedData() {
    final args = Get.arguments;
    logger.d('✅ Purchase data args: $args');

    if (args is Map && args.containsKey('model')) {
      final String module = args['module'];
      final List<PurchaseOrderDataList> receivedList =
      List<PurchaseOrderDataList>.from(args['model']);

      purchaseOrders = receivedList;
      purchaseOrdersData = receivedList.map((e) => e.toJson()).toList();

      totalPurchaseAmount.value = calculateTotalPurchase(
        purchaseOrders,
        ChartFilterType.monthly,
      );

      // calculateCounts( ChartFilterType.monthly);
      calculateOrdersToReceive(ChartFilterType.monthly); // default
      calculateOrdersToBill(ChartFilterType.monthly);

      logger.d('✅ Loaded ${purchaseOrders.length} purchase items for module: $module');
    } else {
      logger.e('❌ Invalid or missing purchase data in arguments');
    }
  }

  double calculateTotalPurchase(List<PurchaseOrderDataList> orders, String filterType) {
    double total = 0.0; 
    final now = DateTime.now();

    for (var order in orders) {
      final date = order.transactionDate;
      final baseNetTotal = order.baseNetTotal;

      if (date == null || baseNetTotal == null) continue;

      switch (filterType.toLowerCase()) {
        case 'daily':
          if (date.year == now.year && date.month == now.month && date.day == now.day) {
            total += baseNetTotal;
          }
          break;
        case 'weekly':
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          if (!date.isBefore(startOfWeek) && !date.isAfter(endOfWeek)) {
            total += baseNetTotal;
          }
          break;
        case 'monthly':
          if (date.year == now.year && date.month == now.month) {
            total += baseNetTotal;
          }
          break;
        case 'quarterly':
          final currentQuarter = ((now.month - 1) ~/ 3) + 1;
          final orderQuarter = ((date.month - 1) ~/ 3) + 1;
          if (date.year == now.year && orderQuarter == currentQuarter) {
            total += baseNetTotal;
          }
          break;
        case 'yearly':
          if (date.year == now.year) {
            total += baseNetTotal;
          }
          break;
        default:
          print("⚠️ Unsupported filter type: $filterType");
          break;
      }
    }

    logger.d("💰 Total Purchase for [$filterType]: ₹${total.toStringAsFixed(2)}");
    return total;
  }

  // void _calculateCounts() {
  //   pOrdersToReceive.value = 0;
  //   pOrdersToBill.value = 0;
  //
  //   for (var item in purchaseOrdersData) {
  //     final status = item['status']?.toString().toLowerCase().trim();
  //     if (status == "to receive and bill") {
  //       pOrdersToReceive.value++;
  //     }
  //     if (status == "to bill") {
  //       pOrdersToBill.value++;
  //     }
  //   }
  //
  //   logger.d("📦 Orders to Receive: ${pOrdersToReceive.value}");
  //   logger.d("🧾 Orders to Bill: ${pOrdersToBill.value}");
  // }

  DateTime getStartDate(String selectedType) {
    DateTime now = DateTime.now();
    switch (selectedType.toLowerCase()) {
      case 'daily':
        return DateTime(now.year, now.month, now.day);
      case 'weekly':
        return now.subtract(Duration(days: now.weekday - 1));
      case 'monthly':
        return DateTime(now.year, now.month, 1);
      case 'quarterly':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        int startMonth = (currentQuarter - 1) * 3 + 1;
        return DateTime(now.year, startMonth, 1);
      case 'yearly':
        return DateTime(now.year, 1, 1);
      default:
        return DateTime(2000);
    }
  }

  void calculateOrdersToReceive(String selectedType) {
    pOrdersToReceive.value = 0;
    final startDate = getStartDate(selectedType);

    for (var item in purchaseOrdersData) {
      final status = item['status']?.toString().toLowerCase().trim();
      final dateStr = item['creation'] ?? item['transaction_date'];
      if (dateStr == null) continue;

      final creationDate = DateTime.tryParse(dateStr);
      if (creationDate == null || creationDate.isBefore(startDate)) continue;

      if (status == "to receive and bill") {
        pOrdersToReceive.value++;
      }
    }
update();
    logger.d("📦 Orders to Receive ($selectedType): ${pOrdersToReceive.value}");
  }

  void calculateOrdersToBill(String selectedType) {
    pOrdersToBill.value = 0;
    final startDate = getStartDate(selectedType);

    for (var item in purchaseOrdersData) {
      final status = item['status']?.toString().toLowerCase().trim();
      final dateStr = item['creation'] ?? item['transaction_date'];
      if (dateStr == null) continue;

      final creationDate = DateTime.tryParse(dateStr);
      if (creationDate == null || creationDate.isBefore(startDate)) continue;

      if (status == "to bill") {
        pOrdersToBill.value++;
      }
    }
    update();

    logger.d("🧾 Orders to Bill ($selectedType): ${pOrdersToBill.value}");
  }



  void updateChartTypeFor(String tileName, String selectedType) {
    if (!filterTypeMap.containsKey(tileName)) {
      logger.e('⚠️ Unknown chart name: $tileName');
      return;
    }

    filterTypeMap[tileName]!.value = selectedType;
    logger.d('📊 Updated Chart Filter: $tileName -> $selectedType');

    if (tileName == 'PURCHASES') {
      totalPurchaseAmount.value = calculateTotalPurchase(purchaseOrders, selectedType);
    }
    if (tileName == 'Purchase Orders to Receive') {
   calculateOrdersToReceive(selectedType);
    }
    if (tileName == 'Purchase Orders to Bill') {
      calculateOrdersToBill(selectedType);
    }
  }

  void increment() => count.value++;
}
