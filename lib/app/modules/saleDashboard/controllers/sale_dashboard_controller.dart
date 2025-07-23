import 'package:amax_hr/main.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/vo/customer_list_model.dart';
import 'package:amax_hr/vo/sales_order.dart'; // Only use SalesOrder here
import 'package:amax_hr/vo/sell_order_list.dart' hide SalesOrder; // Hide conflict
import 'package:get/get.dart';
import '../../../../manager/api_service.dart';

class SaleDashboardController extends GetxController {
  final isLoading = true.obs;
  final customerCount = 0.obs;
  final totalSales = 0.0.obs;
  int customerListLenth = 0;
  int toOrdersToDeliver = 0;
  int todeliverandbill = 0;


  List<SellOrderDataList> sellOrderDataList = [];

  List<Map<String, dynamic>> saleData = [];

  static const List<String> chartFilters = [
    ChartFilterType.yearly,
    ChartFilterType.quarterly,
    ChartFilterType.monthly,
    ChartFilterType.weekly,
    ChartFilterType.daily,
  ];

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
    fetchSellOrderData();
  }

  void _loadPassedData() {
    final args = Get.arguments;
    logger.d('✅ Sale data args: $args');

    if (args is Map && args.containsKey('model')) {
      final String module = args['module'];
      final List<SellOrderDataList> receivedList = List<SellOrderDataList>.from(args['model']);

      // Convert SellOrderDataList to List<Map<String, dynamic>> for chart/total use
      saleData = receivedList.map((e) => e.toJson()).toList();

      totalSales.value = calculateFilteredTotal(saleData, ChartFilterType.monthly);

      logger.d('✅ Loaded ${saleData.length} sale items for module: $module');
    } else {
      logger.e('❌ Invalid or missing sale data in arguments');
    }
  }


  void updateChartType(String key, String? value) {
    if (value != null && chartTypeMap.containsKey(key)) {
      chartTypeMap[key]?.value = value;

      if (key == 'ANNUA saleData = receivedList.map((e) => e.toJson()).toList();SALES') {
        totalSales.value = calculateFilteredTotal(saleData, value);
      }
    }
  }

  double getFilteredTotalForCard(String cardTitle) {
    final filterType = chartTypeMap[cardTitle]?.value ?? ChartFilterType.monthly;
    return calculateFilteredTotal(saleData, filterType);
  }

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

  double getOverallTotal() {
    return saleData.fold(0.0, (total, item) {
      final baseNetTotal = item['base_net_total'];
      if (baseNetTotal != null && baseNetTotal is num) {
        return total + baseNetTotal;
      }
      return total;
    });
  }

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
        customerCount.value = customerListLenth;
        update();
      }
    } catch (e) {
      logger.e("❌ Error fetching customers: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSellOrderData() async {
    try {
      final response = await ApiService.get(
        '/api/resource/Sales Order?',
        params: {
          'fields': '["*"]',
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.statusCode == 200) {
        final modules = response.data['data'] as List;

        // Convert each item to SellOrderDataList
        sellOrderDataList = modules
            .map((e) => SellOrderDataList.fromJson(e as Map<String, dynamic>))
            .toList();
        _getCount();
        logger.d("✅ Orders fetched: ${sellOrderDataList.length}");
        update();
      }
    } catch (e) {
      logger.e("❌ Error fetching sales orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _getCount() {
    // Count "To Deliver"
    toOrdersToDeliver = sellOrderDataList
        .where((order) => order.status == "To Deliver")
        .length;

    // Count "To Deliver and Bill"
      todeliverandbill = sellOrderDataList
        .where((order) => order.status == "To Deliver and Bill")
        .length;




    update();
  }


}
