import 'package:amax_hr/main.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:amax_hr/vo/sales_order.dart';
import 'package:get/get.dart';

class ChartDataSales {
  final String label;
  final double value;

  ChartDataSales(this.label, this.value);
}

class SaleGraphController extends GetxController {
  List<SalesOrder> salesOrderList = [];
  RxList<ChartDataSales> lineChartData = <ChartDataSales>[].obs;
  RxString selectedFilter = ChartFilterType.yearly.obs;

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
            .map((e) => SalesOrder.fromJson(e as Map<String, dynamic>))
            .where((e) => e.transactionDate != null)
            .toList();

        logger.d('📅 Passed Dates: ${salesOrderList.map((e) => e.transactionDate).toList()}');

        salesOrderList.sort((a, b) =>
            DateTime.tryParse(a.transactionDate ?? '')?.compareTo(
                DateTime.tryParse(b.transactionDate ?? '') ?? DateTime(1970)) ??
            0);

        generateLineChart();
      } else {
        logger.e('❌ Provided model is not a valid List');
      }
    }
  }

  void onFilterChanged(String newFilter) {
    selectedFilter.value = newFilter;
    generateLineChart();
  }

  void generateLineChart() {
    logger.d('📊 Generating chart for filter: ${selectedFilter.value}');
    final filteredData = generateFilteredLineChartData(salesOrderList, selectedFilter.value);
    lineChartData.value = filteredData;
    logger.d("📈 Generated ${filteredData.length} chart points for [${selectedFilter.value}]");
  }

  List<ChartDataSales> generateFilteredLineChartData(
      List<SalesOrder> orders, String filterType) {
    final now = DateTime.now();
    final Map<String, double> grouped = {};

    for (var order in orders) {
      final dateStr = order.transactionDate;
      final baseNetTotal = order.baseNetTotal ?? 0.0;

      final date = DateTime.tryParse(dateStr ?? '');
      if (date == null) continue;

      String key = '';

      switch (filterType.toLowerCase()) {
        case 'daily':
          if (date.year == now.year &&
              date.month == now.month &&
              date.day == now.day) {
            key = '${date.year}-${date.month}-${date.day}';
          }
          break;

        case 'weekly':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));
          if (!date.isBefore(weekStart) && !date.isAfter(weekEnd)) {
            key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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
        grouped.update(key, (val) => val + baseNetTotal, ifAbsent: () => baseNetTotal);
      }
    }

    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) {
        final dateA = _parseKeyToDateTime(a.key);
        final dateB = _parseKeyToDateTime(b.key);
        return dateA.compareTo(dateB);
      });

    return sortedEntries
        .map((entry) => ChartDataSales(entry.key, entry.value))
        .toList();
  }

  DateTime _parseKeyToDateTime(String key) {
    try {
      if (key.contains('Q')) {
        final parts = key.split('-Q');
        final year = int.parse(parts[0]);
        final quarter = int.parse(parts[1]);
        return DateTime(year, (quarter - 1) * 3 + 1);
      }

      final parts = key.split('-');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      } else if (parts.length == 2) {
        return DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }
    } catch (_) {
      logger.e('⚠️ Failed to parse date from key: $key');
    }
    return DateTime(1970);
  }

  List<ChartDataSales> getChartData() => lineChartData.toList();
}
