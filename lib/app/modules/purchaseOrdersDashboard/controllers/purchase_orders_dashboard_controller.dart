import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/vo/purchase_order_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ChartFilterType {
  static const String yearly = 'Yearly';
  static const String quarterly = 'Quarterly';
  static const String monthly = 'Monthly';
  static const String weekly = 'Weekly';
  static const String daily = 'Daily';
}

class PurchaseOrdersDashboardController extends GetxController {
  // Reactive states
  final RxBool isLoading = true.obs;
  final RxDouble totalPurchaseAmount = 0.0.obs;
  final RxInt pOrdersToReceive = 0.obs;
  final RxInt pOrdersToBill = 0.obs;
  final RxInt activeSuppliers = 0.obs;

  // Raw and mapped data
  List<PurchaseOrderDataList> purchaseOrders = [];
  List<Map<String, dynamic>> purchaseOrdersData = [];

  // Filter config
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

  // Year selection
  RxString selectedYear = '2025'.obs;

  static List<String> yearOptions = [
    '2022', '2023', '2024', '2025', '2026', '2027', '2028',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchPurchaseData();
  }

  Future<void> fetchPurchaseData() async {
 EasyLoading.show();
    try {
      final response = await ApiService.get(
        '/api/resource/Purchase Order?',
        params: {'fields': '["*"]', 'limit_page_length': '1000'},
      );

      if (response != null && response.statusCode == 200) {
        final List<PurchaseOrderDataList> list = (response.data['data'] as List)
            .map((e) => PurchaseOrderDataList.fromJson(e))
            .toList();

        EasyLoading.dismiss();

        purchaseOrders = list;
        purchaseOrdersData = list.map((e) => e.toJson()).toList();

        updateAll();
        logger.d("✅ Purchases loaded: ${list.length}");
      } else {
        EasyLoading.dismiss();

        logger.e("❌ Failed to fetch purchases");
      }
    } catch (e) {
      EasyLoading.dismiss();

      logger.e("❌ Error fetching purchases: $e");
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();

    }
  }

  void onYearChanged(String? year) {
    if (year != null) {
      selectedYear.value = year;
      updateAll();
    }
  }

  void updateAll() {
    totalPurchaseAmount.value = calculateTotalPurchase(
      purchaseOrders,
      filterTypeMap['PURCHASES']!.value,
    );

    pOrdersToReceive.value = countOrdersToReceive(
      purchaseOrders,
      filterTypeMap['Purchase Orders to Receive']!.value,
      selectedYear,
    );

    pOrdersToBill.value = countOrdersToBill(
      purchaseOrders,
      filterTypeMap['Purchase Orders to Bill']!.value,
      selectedYear,
    );

    activeSuppliers.value = getActiveSuppliers(
      purchaseOrders,
      filterTypeMap['Active Suppliers']!.value,
      selectedYear,
    );

    isLoading.value = false;
    update();
  }

  void updateChartTypeFor(String tileName, String selectedType) {
    if (!filterTypeMap.containsKey(tileName)) {
      logger.e('⚠️ Unknown chart name: $tileName');
      return;
    }

    filterTypeMap[tileName]!.value = selectedType;
    logger.d('📊 Updated Chart Filter: $tileName -> $selectedType');
    updateAll();
  }

  // 🕒 Filtering Date Logic
  DateTime getStartDate({
    required String selectedType,
    required RxString selectedYear,
  }) {
    int year = int.tryParse(selectedYear.value) ?? DateTime.now().year;
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

  // 💰 Purchase Total Calculation
  double calculateTotalPurchase(List<PurchaseOrderDataList> orders, String filterType) {
    double total = 0.0;
    DateTime startDate = getStartDate(
      selectedType: filterType,
      selectedYear: selectedYear,
    );

    for (var order in orders) {
      final date = order.transactionDate;
      final baseNetTotal = order.baseNetTotal;

      if (date == null || baseNetTotal == null || date.isBefore(startDate)) continue;

      bool withinRange = switch (filterType.toLowerCase()) {
        'daily' => date.year == startDate.year && date.month == startDate.month && date.day == startDate.day,
        'weekly' => !date.isBefore(startDate) && !date.isAfter(startDate.add(const Duration(days: 6))),
        'monthly' => date.year == startDate.year && date.month == startDate.month,
        'quarterly' => date.year == startDate.year &&
            ((date.month - 1) ~/ 3) + 1 == ((startDate.month - 1) ~/ 3) + 1,
        'yearly' => date.year == startDate.year,
        _ => false,
      };

      if (withinRange) total += baseNetTotal;
    }

    logger.d("💰 Total Purchase [$filterType]: ₹${total.toStringAsFixed(2)}");
    return total;
  }

  // 📦 Orders to Receive
  int countOrdersToReceive(
      List<PurchaseOrderDataList> orders,
      String filterType,
      RxString selectedYear,
      ) {
    return _countOrdersByStatus(orders, filterType, selectedYear, ["to receive"]);
  }

  // 🧾 Orders to Bill
  int countOrdersToBill(
      List<PurchaseOrderDataList> orders,
      String filterType,
      RxString selectedYear,
      ) {
    return _countOrdersByStatus(orders, filterType, selectedYear, ["to bill"]);
  }

  // 🧍‍♂️ Active Suppliers
  int getActiveSuppliers(
      List<PurchaseOrderDataList> orders,
      String filterType,
      RxString selectedYear,
      ) {
    final suppliers = <String>{};
    DateTime start = getStartDate(selectedType: filterType, selectedYear: selectedYear);
    DateTime end = _getEndDate(start, filterType);

    for (var order in orders) {
      final date = order.creation;
      if (date != null && !date.isBefore(start) && !date.isAfter(end)) {
        suppliers.add(order.supplier ?? '');
      }
    }

    return suppliers.length;
  }

  // 🔄 Helper - End date calculation
  DateTime _getEndDate(DateTime start, String filterType) {
    switch (filterType.toLowerCase()) {
      case 'daily':
        return start;
      case 'weekly':
        return start.add(const Duration(days: 6));
      case 'monthly':
        return DateTime(start.year, start.month + 1, 0);
      case 'quarterly':
        return DateTime(start.year, start.month + 3, 0);
      case 'yearly':
        return DateTime(start.year, 12, 31);
      default:
        return DateTime(2099, 12, 31);
    }
  }

  // ✅ Shared Counter by Status
  int _countOrdersByStatus(
      List<PurchaseOrderDataList> orders,
      String filterType,
      RxString selectedYear,
      List<String> statuses,
      ) {
    DateTime start = getStartDate(
      selectedType: filterType,
      selectedYear: selectedYear,
    );
    DateTime end = _getEndDate(start, filterType);

    return orders.where((order) {
      final date = order.creation;
      final status = order.status?.toLowerCase().trim();
      return date != null &&
          !date.isBefore(start) &&
          !date.isAfter(end) &&
          statuses.contains(status);
    }).length;
  }
}
