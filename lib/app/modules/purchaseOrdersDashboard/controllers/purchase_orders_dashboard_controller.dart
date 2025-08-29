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
  final RxBool isLoading = true.obs;
  RxDouble totalPurchaseAmount = 0.0.obs;

    RxInt pOrdersToReceive = 0.obs;
  final RxInt pOrdersToBill = 0.obs;
  final RxInt activeSuppliers = 0.obs;

  List<PurchaseOrderDataList> purchaseOrders = [];
  List<PurchaseOrderDataList> filterPurchaseOrders = [];
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

        logger.d("✅ Purchases loaded: ${list.length}");

        filterCountData(data: list,filterType:ChartFilterType.yearly.obs );


      } else {
        logger.e("❌ Failed to fetch purchases");
      }
    } catch (e) {
      logger.e("❌ Error fetching purchases: $e");
    } finally {
      isLoading.value = false;
      EasyLoading.dismiss();
    }
  }
    void filterCountData({
      required List<PurchaseOrderDataList> data,
      required RxString filterType, // "daily", "weekly", "monthly", "quarterly", "yea
      // rly"
    }) {
      filterPurchaseOrders.clear();
      final now = DateTime.now();

      for (var e in data) {
        const excludedStatuses = ["Draft", "Cancelled", "Closed"];

        if (!excludedStatuses.contains(e.status) &&
            e.docstatus == 1 &&
            e.company == GlobalCompany.acd) {

          // ✅ make sure we always parse safely
          final date = DateTime.tryParse(e.transactionDate.toString());
          if (date == null) continue; // skip if invalid date

          bool matches = false;

          switch (filterType.toLowerCase()) {
            case "daily":
              matches = date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;
              break;

            case "weekly":
              final startOfWeek = DateTime(now.year, now.month, now.day)
                  .subtract(Duration(days: now.weekday - 1));
              final endOfWeek = startOfWeek.add(const Duration(days: 6));
              matches = !date.isBefore(startOfWeek) && !date.isAfter(endOfWeek);
              break;

            case "monthly":
              matches = date.year == now.year && date.month == now.month;
              break;

            case "quarterly":
              final currentQuarter = ((now.month - 1) ~/ 3) + 1;
              final dateQuarter = ((date.month - 1) ~/ 3) + 1;
              matches = date.year == now.year && dateQuarter == currentQuarter;
              break;

            case "yearly":
            default: // fallback to yearly
              matches = date.year == now.year;
              break;
          }

          if (matches) {
            filterPurchaseOrders.add(e);
          }
        }
      }

      totalPurchaseAmount.value = filterPurchaseOrders.fold(
        0.0,
            (sum, e) => sum + e.baseNetTotal,
      );


      logger.d("FilterType=$filterType | Count=${filterPurchaseOrders.length} |"
          " Total=$totalPurchaseAmount");
      _gettoRecevideBillCount() ;

      update();
    }

  _gettoRecevideBillCount() {
    pOrdersToReceive.value = filterPurchaseOrders.where((e) =>
    // combine all conditions with &&
    (e.status == "Bill,To Bill" || e.status == "To Receive") &&

        e.docstatus == 1
    ).length;

    logger.d("Closed Orders Count: ${pOrdersToReceive.value}");
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
      ChartFilterType.monthly,
      selectedYear: selectedYear,
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

  DateTime getStartDate({
    required String selectedType,
    required RxString selectedYear,
  }) {
    int year = int.tryParse(selectedYear.value) ?? DateTime.now().year;
    final today = DateTime.now();

    switch (selectedType.toLowerCase()) {
      case 'daily':
        return DateTime(year, today.month, today.day);
      case 'weekly':
        return DateTime(year, today.month, today.day - today.weekday + 1);
      case 'monthly':
        return DateTime(year, today.month, 1);
      case 'quarterly':
        int startMonth = (((today.month - 1) ~/ 3) * 3) + 1;
        return DateTime(year, startMonth, 1);
      case 'yearly':
        return DateTime(year, 1, 1);
      default:
        return DateTime(2000);
    }
  }

  void printAllPurchaseTotals(List<PurchaseOrderDataList> orders) {
    final now = DateTime.now();

    final Map<String, Map<String, DateTime>> filterRanges = {
      'Daily': {
        'start': DateTime(now.year, now.month, now.day),
        'end': DateTime(now.year, now.month, now.day),
      },
      'Weekly': {
        'start': now.subtract(Duration(days: now.weekday - 1)),
        'end': now
            .subtract(Duration(days: now.weekday - 1))
            .add(Duration(days: 6)),
      },
      'Monthly': {
        'start': DateTime(now.year, now.month, 1),
        'end': DateTime(now.year, now.month + 1, 0),
      },
      'Quarterly': () {
        int quarter = ((now.month - 1) ~/ 3) + 1;
        int startMonth = (quarter - 1) * 3 + 1;
        return {
          'start': DateTime(now.year, startMonth, 1),
          'end': DateTime(now.year, startMonth + 3, 0),
        };
      }(),
      'Yearly': {
        'start': DateTime(now.year, 1, 1),
        'end': DateTime(now.year, 12, 31),
      },
    };

    for (var entry in filterRanges.entries) {
      final filter = entry.key;
      final start = entry.value['start']!;
      final end = entry.value['end']!;
      double total = 0.0;

      for (var order in orders) {
        final date = order.transactionDate;
        final amount = order.baseNetTotal;
        final status = order.status?.toLowerCase().trim();

        if (date == null || amount == null) continue;
        if (status == 'draft' || status == 'cancelled' || status == 'closed')
          continue;
        if (date.isBefore(start) || date.isAfter(end)) continue;

        total += amount;
      }

      print("💰 Total Purchase [$filter]: ₹${total.toStringAsFixed(2)}");
    }
  }

  double calculateTotalPurchase(
    List<PurchaseOrderDataList> orders,
    String filterType, {
    required RxString selectedYear,
  }) {
    double total = 0.0;
    int year = int.tryParse(selectedYear.value) ?? DateTime.now().year;
    DateTime baseStart = getStartDate(
      selectedType: filterType,
      selectedYear: selectedYear,
    );

    for (var order in orders) {
      final date = order.transactionDate;
      final baseNetTotal = order.baseNetTotal;
      final status = order.status?.toLowerCase().trim();

      if (date == null || baseNetTotal == null) continue;
      if (status == 'draft' || status == 'cancelled' || status == 'closed')
        continue;

      bool withinRange = switch (filterType.toLowerCase()) {
        'daily' =>
          date.year == baseStart.year &&
              date.month == baseStart.month &&
              date.day == baseStart.day,
        'weekly' =>
          date.isAfter(baseStart.subtract(const Duration(days: 1))) &&
              date.isBefore(baseStart.add(const Duration(days: 7))),
        'monthly' =>
          date.year == baseStart.year && date.month == baseStart.month,
        'quarterly' =>
          date.year == baseStart.year &&
              ((date.month - 1) ~/ 3) == ((baseStart.month - 1) ~/ 3),
        'yearly' => date.year == year,
        _ => false,
      };

      if (withinRange) {
        total += baseNetTotal;
      }
    }

    logger.d("💰 Total Purchase [$filterType]: ₹\${total.toStringAsFixed(2)}");
    return total;
  }

  int countOrdersToReceive(
    List<PurchaseOrderDataList> orders,
    String filterType,
    RxString selectedYear,
  ) {
    return _countOrdersByStatus(orders, filterType, selectedYear, [
      "to receive",
    ]);
  }

  int countOrdersToBill(
    List<PurchaseOrderDataList> orders,
    String filterType,
    RxString selectedYear,
  ) {
    return _countOrdersByStatus(orders, filterType, selectedYear, ["to bill"]);
  }

  int getActiveSuppliers(
    List<PurchaseOrderDataList> orders,
    String filterType,
    RxString selectedYear,
  ) {
    final suppliers = <String>{};
    DateTime start = getStartDate(
      selectedType: filterType,
      selectedYear: selectedYear,
    );
    DateTime end = _getEndDate(start, filterType);

    for (var order in orders) {
      final date = order.creation;
      if (date != null && !date.isBefore(start) && !date.isAfter(end)) {
        suppliers.add(order.supplier ?? '');
      }
    }

    return suppliers.length;
  }

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
