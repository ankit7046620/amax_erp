import 'package:amax_hr/main.dart';
import 'package:amax_hr/vo/sell_order_list.dart';
import 'package:get/get.dart';
import 'package:amax_hr/utils/app.dart';

/// Model class to represent chart data
class ChartDataSales {
  final String label;
  final double value;

  ChartDataSales(this.label, this.value);
}


/// Controller for generating chart data from Sales Orders
class SaleGraphController extends GetxController {

  RxList<ChartDataSales> lineChartData = <ChartDataSales>[].obs;

  List<String> chartTypes = [
    ChartFilterType.yearly,
    ChartFilterType.quarterly,
    ChartFilterType.monthly,
    ChartFilterType.weekly,
    ChartFilterType.daily,
  ];

  var selectedChartType = ChartFilterType.monthly.obs;

  var chartTypeMap = <String, RxString>{
    'Bar Chart': ChartFilterType.monthly.obs,
    'Line Chart': ChartFilterType.monthly.obs,
    'Territory Chart': ChartFilterType.monthly.obs,
    'Source Chart': ChartFilterType.monthly.obs,
    'Sales Performance': ChartFilterType.monthly.obs,
  }.obs;

    List<SellOrderDataList> receivedList=[];
  @override
  void onInit() {
    super.onInit();
    _loadPassedData();
  }

  void _loadPassedData() {
    final args = Get.arguments;
    if (args is Map && args.containsKey('model')) {
      final args = Get.arguments;
      logger.d('✅ Sale data args: $args');

      if (args is Map && args.containsKey('model')) {
        final List receivedRaw = args['model'] as List;
       receivedList = receivedRaw
            .map((e) => SellOrderDataList.fromJson(e as Map<String, dynamic>))
            .toList();

        generateLineChart(filter: ChartFilterType.monthly);
        generateCustomerSalesChartData(receivedList,ChartFilterType.monthly);

        logger.d("receivedList>>>${receivedList.length}");

      }
    }
  }

  void updateChartTypeFor(String chartName, String selectedType) {
    if (!chartTypeMap.containsKey(chartName)) return;

    chartTypeMap[chartName]!.value = selectedType;
    logger.d('📊 Updated Chart: $chartName - $selectedType');

    if (chartName == 'Line Chart') {
      generateLineChart(filter: selectedType);
    }
    if (chartName == 'Bar Chart') {
      generateCustomerSalesChartData(receivedList,selectedType);
    }
  }

  void generateLineChart({required String filter}) {
    final filteredData = _generateFilteredChartData(receivedList, filter);
    lineChartData.assignAll(filteredData); // assignAll ensures observable update
    logger.d("📈 Chart Points for [$filter]: ${filteredData.length}");
    update();
  }

  List<ChartDataSales> _generateFilteredChartData(List<SellOrderDataList> orders, String filterType) {
    final now = DateTime.now();
    final Map<String, double> grouped = {};

    for (var order in orders) {
      final date = DateTime.tryParse(order.transactionDate ?? '');
      if (date == null) continue;

      final value = order.baseNetTotal ?? 0.0;
      String key = '';

      switch (filterType.toLowerCase()) {
        case 'daily':
          if (date.year == now.year && date.month == now.month && date.day == now.day) {
            key = '${date.year}-${date.month}-${date.day}';
          }
          break;

        case 'weekly':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(Duration(days: 6));
          if (!date.isBefore(weekStart) && !date.isAfter(weekEnd)) {
            key = '${date.year}-${date.month}-${date.day}';
          }
          break;

        case 'monthly':
          if (date.year == now.year && date.month == now.month) {
            key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          }
          break;

        case 'quarterly':
          final quarter = ((date.month - 1) ~/ 3) + 1;
          key = '${date.year}-Q$quarter';
          break;

        case 'yearly':
          key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
          break;
      }

      if (key.isNotEmpty) {
        grouped.update(key, (val) => val + value, ifAbsent: () => value);
      }
    }

    final sorted = grouped.entries.toList()
      ..sort((a, b) => _parseKeyToDate(a.key).compareTo(_parseKeyToDate(b.key)));

    return sorted.map((e) => ChartDataSales(e.key, e.value)).toList();
  }

  DateTime _parseKeyToDate(String key) {
    try {
      if (key.contains('Q')) {
        final parts = key.split('-Q');
        final year = int.parse(parts[0]);
        final quarter = int.parse(parts[1]);
        return DateTime(year, (quarter - 1) * 3 + 1);
      }
      final parts = key.split('-');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      } else if (parts.length == 2) {
        return DateTime(int.parse(parts[0]), int.parse(parts[1]));
      }
    } catch (_) {}
    return DateTime(1970);
  }


  RxList<CustomerChartData> customerSalesChartData = <CustomerChartData>[].obs;

  // void generateCustomerSalesChartData(List<SellOrderDataList> orders) {
  //   final Map<String, double> salesMap = {};
  //
  //   for (var order in orders) {
  //     final name = order.customerName ?? 'Unknown';
  //     final amount = order.baseNetTotal ?? 0.0;
  //
  //     salesMap[name] = (salesMap[name] ?? 0) + amount;
  //   }
  //
  //   customerSalesChartData.value = salesMap.entries
  //       .map((entry) => CustomerChartData(entry.key, entry.value))
  //       .toList();
  // }
  void generateCustomerSalesChartData(List<SellOrderDataList> orders, String filterType) {
    final now = DateTime.now();
    final Map<String, double> salesMap = {};

    for (var order in orders) {
      final date = DateTime.tryParse(order.transactionDate ?? '');
      if (date == null) continue;

      bool include = false;

      switch (filterType.toLowerCase()) {
        case 'daily':
          include = date.year == now.year &&
              date.month == now.month &&
              date.day == now.day;
          break;

        case 'weekly':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          include = !date.isBefore(weekStart) && !date.isAfter(weekEnd);
          break;

        case 'monthly':
          include = date.year == now.year && date.month == now.month;
          break;

        case 'quarterly':
          final quarter = ((now.month - 1) ~/ 3) + 1;
          final orderQuarter = ((date.month - 1) ~/ 3) + 1;
          include = date.year == now.year && orderQuarter == quarter;
          break;

        case 'yearly':
          include = date.year == now.year;
          break;

        default:
          include = true;
      }

      if (include) {
        final name = order.customerName ?? 'Unknown';
        final amount = order.baseNetTotal ?? 0.0;
        salesMap[name] = (salesMap[name] ?? 0) + amount;
      }
    }

    customerSalesChartData.value = salesMap.entries
        .map((entry) => CustomerChartData(entry.key, entry.value))
        .toList();

    update();
  }


}




/// Constants for chart filter types
class ChartFilterType {
  static const String yearly = 'yearly';
  static const String quarterly = 'quarterly';
  static const String monthly = 'monthly';
  static const String weekly = 'weekly';
  static const String daily = 'daily';
}

class CustomerChartData {
  final String customerName;
  final double totalSales;

  CustomerChartData(this.customerName, this.totalSales);
}



