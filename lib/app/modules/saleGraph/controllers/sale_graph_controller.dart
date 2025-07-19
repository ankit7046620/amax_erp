import 'package:amax_hr/main.dart';
import 'package:get/get.dart';
import 'package:amax_hr/utils/app.dart';

/// Model class to represent chart data
class ChartDataSales {
  final String label;
  final double value;

  ChartDataSales(this.label, this.value);
}

/// Sales Order model
class SalesOrder {
  String? transaction_date;
  double? base_net_total;

  String? get transactionDate => transaction_date;
  double? get baseNetTotal => base_net_total;

  SalesOrder({this.transaction_date, this.base_net_total});

  factory SalesOrder.fromJson(Map<String, dynamic> json) {
    return SalesOrder(
      transaction_date: json['transaction_date'],
      base_net_total: (json['base_net_total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_date': transaction_date,
      'base_net_total': base_net_total,
    };
  }
}

/// Controller for generating chart data from Sales Orders
class SaleGraphController extends GetxController {
  List<SalesOrder> salesOrderList = [];
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

  @override
  void onInit() {
    super.onInit();
    _loadPassedData();
  }

  void _loadPassedData() {
    final args = Get.arguments;
    if (args is Map && args.containsKey('model')) {
      final rawList = args['model'];
      if (rawList is List) {
        salesOrderList = rawList.map((e) => SalesOrder.fromJson(e)).toList();

        logger.d('📅 Passed Dates: ${salesOrderList.map((e) => e.transactionDate).toList()}');

        salesOrderList.sort((a, b) =>
            DateTime.tryParse(a.transactionDate ?? '')!
                .compareTo(DateTime.tryParse(b.transactionDate ?? '') ?? DateTime(1970)));

        // Default chart data for selected filter
        generateLineChart(filter: ChartFilterType.monthly);
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
  }

  void generateLineChart({required String filter}) {
    final filteredData = _generateFilteredChartData(salesOrderList, filter);
    lineChartData.assignAll(filteredData); // assignAll ensures observable update
    logger.d("📈 Chart Points for [$filter]: ${filteredData.length}");
    update();
  }

  List<ChartDataSales> _generateFilteredChartData(List<SalesOrder> orders, String filterType) {
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
}

/// Constants for chart filter types
class ChartFilterType {
  static const String yearly = 'yearly';
  static const String quarterly = 'quarterly';
  static const String monthly = 'monthly';
  static const String weekly = 'weekly';
  static const String daily = 'daily';
}
