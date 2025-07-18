// import 'package:amax_hr/main.dart';
// import 'package:amax_hr/utils/app.dart';
// import 'package:amax_hr/vo/customer_list_model.dart';
// import 'package:amax_hr/vo/sales_order.dart';
// import 'package:get/get.dart';
// import '../../../../manager/api_service.dart';
//
// class SaleDashboardController extends GetxController {
//   final isLoading = true.obs;
//   final customerCount = 0.obs;
//   final totalSales = 0.0.obs;
//   int customerListLenth = 0;
//
//   // Sale data extracted from model
//   List<Map<String, dynamic>> saleData = [];
//
//   // Chart filter options
//   static const List<String> chartFilters = [
//     ChartFilterType.yearly,
//     ChartFilterType.quarterly,
//     ChartFilterType.monthly,
//     ChartFilterType.weekly,
//     ChartFilterType.daily,
//   ];
//
//   // Dropdown values for each card
//   final RxMap<String, RxString> chartTypeMap = {
//     'ANNUAL SALES': ChartFilterType.monthly.obs,
//     'SALES ORDERS TO DELIVER': ChartFilterType.monthly.obs,
//     'SALES ORDERS TO BILL': ChartFilterType.monthly.obs,
//     'ACTIVE CUSTOMERS': ChartFilterType.monthly.obs,
//   }.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadPassedData();
//     fetchCustomerData();
//   }
//
//   /// ✅ Load data passed via Get.arguments
//   void _loadPassedData() {
//     final args = Get.arguments;
//     logger.d('✅ Sale data args: $args');
//
//     if (args is Map && args.containsKey('model')) {
//       final salesOrder = args['model'];
//       if (salesOrder is SalesOrder && salesOrder.data != null) {
//         saleData = salesOrder.data!.map((e) => e.toJson()).toList();
//         totalSales.value = calculateFilteredTotal(saleData, ChartFilterType.monthly);
//         logger.d('✅ Loaded ${saleData.length} sale items');
//       } else {
//         logger.e('❌ SalesOrder model is invalid or missing data');
//       }
//     } else {
//       logger.e('❌ Invalid or missing sale data in arguments');
//     }
//   }
//
//   /// Update dropdown filter for a specific card
//   void updateChartType(String key, String? value) {
//     if (value != null && chartTypeMap.containsKey(key)) {
//       chartTypeMap[key]?.value = value;
//     }
//   }
//
//   /// Get filtered total base_net_total for a specific card
//   double getFilteredTotalForCard(String cardTitle) {
//     final filterType = chartTypeMap[cardTitle]?.value ?? ChartFilterType.monthly;
//     return calculateFilteredTotal(saleData, filterType);
//   }
//
//   /// ✅ Calculate total base_net_total by selected filter
//   double calculateFilteredTotal(List<Map<String, dynamic>> salesData, String filterType) {
//     double total = 0.0;
//     final now = DateTime.now();
//
//     for (var item in salesData) {
//       final date = DateTime.tryParse(item['transaction_date'].toString());
//       final baseNetTotal = item['base_net_total'];
//
//       if (date == null || baseNetTotal == null) continue;
//
//       switch (filterType.toLowerCase()) {
//         case 'monthly':
//           if (date.month == now.month && date.year == now.year) total += baseNetTotal;
//           break;
//
//         case 'weekly':
//           final weekStart = now.subtract(Duration(days: now.weekday - 1));
//           final weekEnd = weekStart.add(const Duration(days: 6));
//           if (!date.isBefore(weekStart) && !date.isAfter(weekEnd)) total += baseNetTotal;
//           break;
//
//         case 'quarterly':
//           final quarter = ((now.month - 1) ~/ 3) + 1;
//           final dateQuarter = ((date.month - 1) ~/ 3) + 1;
//           if (date.year == now.year && dateQuarter == quarter) total += baseNetTotal;
//           break;
//
//         case 'yearly':
//           if (date.year == now.year) total += baseNetTotal;
//           break;
//
//         case 'daily':
//           if (date.year == now.year && date.month == now.month && date.day == now.day) {
//             total += baseNetTotal;
//           }
//           break;
//       }
//     }
//
//     logger.d("💰 Filtered Total for [$filterType]: ₹$total");
//     return total;
//   }
//
//   /// ✅ Total sales without any filters
//   double getOverallTotal() {
//     double total = 0.0;
//
//     for (var item in saleData) {
//       final baseNetTotal = item['base_net_total'];
//       if (baseNetTotal != null && baseNetTotal is num) {
//         total += baseNetTotal;
//       }
//     }
//
//     return total;
//   }
//
//   /// ✅ Fetch total active customers
//   Future<void> fetchCustomerData() async {
//     try {
//       final response = await ApiService.get(
//         '/api/resource/Customer?',
//         params: {
//           'fields':
//           '["name","customer_name","customer_type","customer_group","territory","mobile_no","email_id","tax_id","creation","modified"]',
//           'limit_page_length': '1000',
//         },
//       );
//
//       if (response != null && response.statusCode == 200) {
//         final modules = response.data['data'];
//         final customerList = CustomerList.fromJson({'data': modules});
//         customerListLenth = customerList.data?.length ?? 0;
//         print("customerLaenth"+customerListLenth.toString());
//         update();
//       }
//     } catch (e) {
//       logger.e("❌ Error fetching customers: $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
import 'package:amax_hr/main.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/vo/customer_list_model.dart';
import 'package:amax_hr/vo/sales_order.dart';
import 'package:get/get.dart';
import '../../../../manager/api_service.dart';

class SaleDashboardController extends GetxController {
  final isLoading = true.obs;
  final customerCount = 0.obs;
  final totalSales = 0.0.obs;
  int customerListLenth = 0;

  // Sale data extracted from model
  List<Map<String, dynamic>> saleData = [];

  // Chart filter options
  static const List<String> chartFilters = [
    ChartFilterType.yearly,
    ChartFilterType.quarterly,
    ChartFilterType.monthly,
    ChartFilterType.weekly,
    ChartFilterType.daily,
  ];

  // Dropdown values for each card
  final RxMap<String, RxString> chartTypeMap = {
    'ANNUAL SALES': ChartFilterType.monthly.obs,
    'SALES ORDERS TO DELIVER': ChartFilterType.monthly.obs,
    'SALES ORDERS TO BILL': ChartFilterType.monthly.obs,
    'ACTIVE CUSTOMERS': ChartFilterType.monthly.obs,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPassedData();
    fetchCustomerData();
  }

  /// ✅ Load data passed via Get.arguments
  void _loadPassedData() {
    final args = Get.arguments;
    logger.d('✅ Sale data args: $args');

    if (args is Map && args.containsKey('model')) {
      final salesOrder = args['model'];
      if (salesOrder is SalesOrder && salesOrder.data != null) {
        saleData = salesOrder.data!.map((e) => e.toJson()).toList();
        totalSales.value = calculateFilteredTotal(saleData, ChartFilterType.monthly);
        logger.d('✅ Loaded ${saleData.length} sale items');
      } else {
        logger.e('❌ SalesOrder model is invalid or missing data');
      }
    } else {
      logger.e('❌ Invalid or missing sale data in arguments');
    }
  }

  /// Update dropdown filter for a specific card
  void updateChartType(String key, String? value) {
    if (value != null && chartTypeMap.containsKey(key)) {
      chartTypeMap[key]?.value = value;

      // ✅ Update totalSales when ANNUAL SALES filter changes
      if (key == 'ANNUAL SALES') {
        totalSales.value = calculateFilteredTotal(saleData, value);
      }
    }
  }

  /// Get filtered total base_net_total for a specific card
  double getFilteredTotalForCard(String cardTitle) {
    final filterType = chartTypeMap[cardTitle]?.value ?? ChartFilterType.monthly;
    return calculateFilteredTotal(saleData, filterType);
  }

  /// ✅ Calculate total base_net_total by selected filter
  double calculateFilteredTotal(List<Map<String, dynamic>> salesData, String filterType) {
    double total = 0.0;
    final now = DateTime.now();

    for (var item in salesData) {
      final date = DateTime.tryParse(item['transaction_date'].toString());
      final baseNetTotal = item['base_net_total'];

      if (date == null || baseNetTotal == null) continue;

      switch (filterType.toLowerCase()) {
        case 'monthly':
          if (date.month == now.month && date.year == now.year) total += baseNetTotal;
          break;

        case 'weekly':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          if (!date.isBefore(weekStart) && !date.isAfter(weekEnd)) total += baseNetTotal;
          break;

        case 'quarterly':
          final quarter = ((now.month - 1) ~/ 3) + 1;
          final dateQuarter = ((date.month - 1) ~/ 3) + 1;
          if (date.year == now.year && dateQuarter == quarter) total += baseNetTotal;
          break;

        case 'yearly':
          if (date.year == now.year) total += baseNetTotal;
          break;

        case 'daily':
          if (date.year == now.year && date.month == now.month && date.day == now.day) {
            total += baseNetTotal;
          }
          break;
      }
    }

    logger.d("💰 Filtered Total for [$filterType]: ₹$total");
    return total;
  }

  /// ✅ Total sales without any filters
  double getOverallTotal() {
    double total = 0.0;

    for (var item in saleData) {
      final baseNetTotal = item['base_net_total'];
      if (baseNetTotal != null && baseNetTotal is num) {
        total += baseNetTotal;
      }
    }

    return total;
  }

  /// ✅ Fetch total active customers
  Future<void> fetchCustomerData() async {
    try {
      final response = await ApiService.get(
        '/api/resource/Customer?',
        params: {
          'fields':
          '["name","customer_name","customer_type","customer_group","territory","mobile_no","email_id","tax_id","creation","modified"]',
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.statusCode == 200) {
        final modules = response.data['data'];
        final customerList = CustomerList.fromJson({'data': modules});
        customerListLenth = customerList.data?.length ?? 0;

        // ✅ Update the observable customerCount
        customerCount.value = customerListLenth;

        print("customerLength: $customerListLenth");
        update();
      }
    } catch (e) {
      logger.e("❌ Error fetching customers: $e");
    } finally {
      isLoading.value = false;
    }
  }
}