import 'package:amax_hr/main.dart';
import 'package:get/get.dart';
import 'package:amax_hr/vo/sales_order.dart';
import 'package:amax_hr/utils/app.dart';


class ChartDataSales {
  final String label;
  final double value;

  ChartDataSales(this.label, this.value);
}
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



class SaleGraphController extends GetxController {
  List<SalesOrder> salesOrderList = [];
  RxList<ChartDataSales> lineChartData = <ChartDataSales>[].obs;
  RxString selectedFilter = 'yearly'.obs;

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
        salesOrderList = rawList
            .map((e) => SalesOrder.fromJson(e))
            .toList();

        logger.d('📅 Passed Dates: ${salesOrderList.map((e) => e.transactionDate).toList()}');
        salesOrderList.sort((a, b) => DateTime.tryParse(a.transactionDate ?? '')!
            .compareTo(DateTime.tryParse(b.transactionDate ?? '')!));

        generateLineChart();
      }
    }
  }

  void onFilterChanged(String newFilter) {
    selectedFilter.value = newFilter;
    generateLineChart();
  }

  void generateLineChart() {
    final filteredData = _generateFilteredChartData(salesOrderList, selectedFilter.value);
    lineChartData.value = filteredData;
    logger.d("📈 Chart Points for [${selectedFilter.value}]: ${filteredData.length}");
  }

  List<ChartDataSales> _generateFilteredChartData(List<SalesOrder> orders, String filterType) {
    final now = DateTime.now();
    final Map<String, double> grouped = {};

    for (var order in orders) {
      final date = DateTime.tryParse(order.transactionDate ?? '');
      if (date == null) continue;

      final value = order.baseNetTotal ?? 0.0;
      String key = '';

      switch (filterType) {
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
