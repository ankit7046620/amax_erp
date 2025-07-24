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

  RxString selectedYear = '2025'.obs;

  static List<String> yearOptions = [
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
  ];

  void onYearChanged(String? year) {
    if (year != null) {
      selectedYear.value = year;
      updateAll();
    }
  }

  void updateAll() {
    final type = ChartFilterType.monthly;
    logger.d("🔄 Updating All with Year: ${selectedYear.value}");

    totalPurchaseAmount.value = calculateTotalPurchase(purchaseOrders, type);
    pOrdersToReceive.value = countOrdersToReceive(
      purchaseOrders,
      ChartFilterType.monthly,
      selectedYear,
    );
    pOrdersToBill.value = countOrdersToBill(
      purchaseOrders,
      ChartFilterType.monthly,
      selectedYear,
    );

    update(); // for GetBuilder UI
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args.containsKey('model')) {
      final List<PurchaseOrderDataList> receivedList =
          List<PurchaseOrderDataList>.from(args['model']);

      purchaseOrders = receivedList;
      purchaseOrdersData = receivedList.map((e) => e.toJson()).toList();

      updateAll();

      logger.d('✅ Loaded ${purchaseOrders.length} purchase items.');
    } else {
      logger.e('❌ Invalid or missing purchase data');
    }
  }

  DateTime getStartDate({
    required String selectedType,
    required RxString selectedYear,
  }) {
    int year = int.tryParse(selectedYear.value) ?? 2025;
    DateTime today = DateTime.now();
    DateTime baseDate = DateTime(year, today.month, today.day);

    switch (selectedType.toLowerCase()) {
      case 'daily':
        return baseDate;
      case 'weekly':
        return baseDate.subtract(Duration(days: baseDate.weekday - 1));
      case 'monthly':
        return DateTime(baseDate.year, baseDate.month, 1);
      case 'quarterly':
        int startMonth = (((baseDate.month - 1) ~/ 3) * 3) + 1;
        return DateTime(baseDate.year, startMonth, 1);
      case 'yearly':
        return DateTime(baseDate.year, 1, 1);
      default:
        return DateTime(2000);
    }
  }

  double calculateTotalPurchase(
    List<PurchaseOrderDataList> orders,
    String filterType,
  ) {
    double total = 0.0;
    DateTime startDate = getStartDate(
      selectedType: filterType,
      selectedYear: selectedYear,
    );

    for (var order in orders) {
      final date = order.transactionDate;
      final baseNetTotal = order.baseNetTotal;

      if (date == null || baseNetTotal == null || date.isBefore(startDate)) {
        continue;
      }

      switch (filterType.toLowerCase()) {
        case 'daily':
          if (date.year == startDate.year &&
              date.month == startDate.month &&
              date.day == startDate.day) {
            total += baseNetTotal;
          }
          break;
        case 'weekly':
          final endOfWeek = startDate.add(const Duration(days: 6));
          if (!date.isBefore(startDate) && !date.isAfter(endOfWeek)) {
            total += baseNetTotal;
          }
          break;
        case 'monthly':
          if (date.year == startDate.year && date.month == startDate.month) {
            total += baseNetTotal;
          }
          break;
        case 'quarterly':
          int orderQuarter = ((date.month - 1) ~/ 3) + 1;
          int startQuarter = ((startDate.month - 1) ~/ 3) + 1;
          if (date.year == startDate.year && orderQuarter == startQuarter) {
            total += baseNetTotal;
          }
          break;
        case 'yearly':
          if (date.year == startDate.year) {
            total += baseNetTotal;
          }
          break;
      }
    }

    logger.d(
      "💰 Total Purchase for [$filterType]: ₹${total.toStringAsFixed(2)}",
    );
    return total;
  }

  int countOrdersToReceive(
    List<PurchaseOrderDataList> orders,
    String filterType,
    RxString selectedYear,
  ) {
    int year = int.tryParse(selectedYear.value) ?? DateTime.now().year;
    DateTime today = DateTime.now();
    DateTime base = DateTime(year, today.month, today.day);

    late DateTime start;
    late DateTime end;

    // Determine the date range based on filter type
    switch (filterType.toLowerCase()) {
      case 'daily':
        start = DateTime(base.year, base.month, base.day);
        end = start
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        break;

      case 'weekly':
        start = base.subtract(Duration(days: base.weekday - 1));
        end = start.add(const Duration(days: 6));
        break;

      case 'monthly':
        start = DateTime(base.year, base.month, 1);
        end = DateTime(base.year, base.month + 1, 0);
        break;

      case 'quarterly':
        int startMonth = ((base.month - 1) ~/ 3) * 3 + 1;
        start = DateTime(base.year, startMonth, 1);
        end = DateTime(base.year, startMonth + 3, 0);
        break;

      case 'yearly':
        start = DateTime(base.year, 1, 1);
        end = DateTime(base.year, 12, 31);
        break;

      default:
        start = DateTime(2000, 1, 1);
        end = DateTime(2099, 12, 31);
    }

    // Count orders that match date range and status
    int count = orders.where((order) {
      final date = order.creation;
      final status = order.status?.toLowerCase().trim();

      return date != null &&
          !date.isBefore(start) &&
          !date.isAfter(end) &&
          (status == "to bill" || status == "to receive and bill");
    }).length;

    logger.d("📦 Orders to Receive [$filterType]: $count from $start to $end");
    return count;
  }

  int countOrdersToBill(
    List<PurchaseOrderDataList> orders,
    String filterType,
    RxString selectedYear,
  ) {
    int year = int.tryParse(selectedYear.value) ?? DateTime.now().year;
    DateTime today = DateTime.now();
    DateTime base = DateTime(year, today.month, today.day);

    late DateTime start;
    late DateTime end;

    // Determine the date range based on filter type
    switch (filterType.toLowerCase()) {
      case 'daily':
        start = DateTime(base.year, base.month, base.day);
        end = start
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1));
        break;

      case 'weekly':
        start = base.subtract(Duration(days: base.weekday - 1));
        end = start.add(const Duration(days: 6));
        break;

      case 'monthly':
        start = DateTime(base.year, base.month, 1);
        end = DateTime(base.year, base.month + 1, 0);
        break;

      case 'quarterly':
        int startMonth = ((base.month - 1) ~/ 3) * 3 + 1;
        start = DateTime(base.year, startMonth, 1);
        end = DateTime(base.year, startMonth + 3, 0);
        break;

      case 'yearly':
        start = DateTime(base.year, 1, 1);
        end = DateTime(base.year, 12, 31);
        break;

      default:
        start = DateTime(2000, 1, 1);
        end = DateTime(2099, 12, 31);
    }

    // Count orders that match date range and status
    int count = orders.where((order) {
      final date = order.creation;
      final status = order.status?.toLowerCase().trim();

      return date != null &&
          !date.isBefore(start) &&
          !date.isAfter(end) &&
          (status == "to bill");
    }).length;

    logger.d("📦 Orders to Receive [$filterType]: $count from $start to $end");
    return count;
  }

  void updateChartTypeFor(String tileName, String selectedType) {
    if (!filterTypeMap.containsKey(tileName)) {
      logger.e('⚠️ Unknown chart name: $tileName');
      return;
    }

    filterTypeMap[tileName]!.value = selectedType;
    logger.d('📊 Updated Chart Filter: $tileName -> $selectedType');

    switch (tileName) {
      case 'PURCHASES':
        totalPurchaseAmount.value = calculateTotalPurchase(
          purchaseOrders,
          selectedType,
        );
        break;
      case 'Purchase Orders to Receive':
      pOrdersToReceive.value=  countOrdersToReceive(
          purchaseOrders,
        selectedType,
          selectedYear,
        );
        break;
      case 'Purchase Orders to Bill':
    pOrdersToBill.value=    countOrdersToBill(
          purchaseOrders,
      selectedType,
          selectedYear,
        );
        break;
    }
  }
}
