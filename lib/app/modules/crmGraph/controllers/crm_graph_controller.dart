import 'package:amax_hr/main.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:get/get.dart';
import 'package:amax_hr/vo/crm_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CrmGraphController extends GetxController {
  List<Data> allLeads = [];

  RxMap<String, int> monthWiseLeadCounts = <String, int>{}.obs;
  RxList<ChartData> territoryChartData = <ChartData>[].obs;
  RxList<ChartData> sourceChartData = <ChartData>[].obs;

  RxList<ChartData> wonChartData = <ChartData>[].obs;

  RxList<SalesChart> barChartData = <SalesChart>[].obs;
  // Observable count: total won leads
  RxInt wonLeadCount = 0.obs;

  // List of only won leads
  List<Data> wonLeads = [];

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
    'Line Chart':ChartFilterType.monthly.obs,
    'Territory Chart':ChartFilterType.monthly.obs,
    'Source Chart':ChartFilterType.monthly.obs,
    'Sales Performance':ChartFilterType.monthly.obs,
  }.obs;

  @override
  void onInit() {
    super.onInit();

    allLeads = Get.arguments as List<Data>;

    _categorizeLeads(); // 1. Separate won leads
    _generateMonthWiseLeadCounts(ChartFilterType.monthly); // 2. All leads month-wise (line chart)
    _generateWonChartData(ChartFilterType.monthly); // 3. Won leads month-wise (bar chart)
    generateTerritoryChartData(ChartFilterType.monthly);
    generateSourceChartData(ChartFilterType.monthly);
    generateLeadTypeBarChartData(ChartFilterType.monthly);
  }

  /// Filter and store 'Won' leads ==>converted means won
  void _categorizeLeads() {
    wonLeads.clear();

    for (var lead in allLeads) {
      final status = (lead.status ?? '').trim().toLowerCase();

      if (status == CrmLeadStatus.converted) {
        wonLeads.add(lead);
      }
    }


    wonLeadCount.value = wonLeads.length;


    print("🏆 Total Won Leads: ${wonLeadCount.value}");
  }

  /// Generate total leads grouped by month (for line chart)
  void _generateMonthWiseLeadCounts(String chartType) {
    final Map<String, int> counts = {};

    for (var lead in allLeads) {
      final creation = lead.creation;
      if (creation != null && creation.isNotEmpty) {
        final date = DateTime.tryParse(creation);
        if (date != null) {
          String key;

          switch (chartType.toLowerCase()) {
            case 'yearly':
              key = "${date.year}";
              break;
            case 'quarterly':
              final quarter = ((date.month - 1) ~/ 3) + 1;
              key = "Q$quarter ${date.year}";
              break;
            case 'monthly':
              key = "${_getMonthName(date.month)} ${date.year}";
              break;
            case 'weekly':
              final week = ((date.day - 1) ~/ 7) + 1;
              key = "Week $week ${_getMonthName(date.month)} ${date.year}";
              break;
            case 'daily':
              key = "${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}";
              break;
            default:
              key = "${_getMonthName(date.month)} ${date.year}"; // Default: Monthly
          }

          counts[key] = (counts[key] ?? 0) + 1;
        }
      }
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    monthWiseLeadCounts.value = Map.fromEntries(sorted);

    print("📊 Lead counts for '$chartType':");
    for (var entry in sorted) {
      print(" ➤ ${entry.key}: ${entry.value}");
    }
  }


  /// Generate won leads grouped by month (for bar chart)
  void _generateWonChartData(String chartType) {
    final Map<String, int> counts = {};

    for (var lead in wonLeads) {
      final creation = lead.creation;
      if (creation.isNotEmpty) {
        final date = DateTime.tryParse(creation);
        if (date != null) {
          String key;

          switch (chartType.toLowerCase()) {
            case 'yearly':
              key = "${date.year}";
              break;
            case 'quarterly':
              final quarter = ((date.month - 1) ~/ 3) + 1;
              key = "Q$quarter ${date.year}";
              break;
            case 'weekly':
              final week = ((date.day - 1) ~/ 7) + 1;
              key = "Week $week ${_getMonthName(date.month)} ${date.year}";
              break;
            case 'daily':
              key = "${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}";
              break;
            case 'monthly':
            default:
              key = "${_getMonthName(date.month)} ${date.year}";
          }

          counts[key] = (counts[key] ?? 0) + 1;
        }
      }
    }

    final sorted = counts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    wonChartData.value = sorted.map((e) => ChartData(e.key, e.value)).toList();

    update();

    // ✅ Log output
    print("📊 Won Leads Breakdown for $chartType:");
    for (var entry in wonChartData) {
      print("   ➤ ${entry.month}: ${entry.count}");
    }
  }

  void generateTerritoryChartData(String chartType) {
    final Map<String, int> territoryCounts = {};

    for (var lead in allLeads) {
      final territory = (lead.territory ?? 'Unknown').trim();
      final creation = lead.creation;

      if (creation != null && creation.isNotEmpty) {
        final date = DateTime.tryParse(creation);
        if (date != null) {
          bool include = false;

          switch (chartType.toLowerCase()) {
            case ChartFilterType.yearly:
              include = true; // Optionally filter by year
              break;
            case ChartFilterType.quarterly:
              include = true;
              break;
            case ChartFilterType.monthly:
              include = true;
              break;
            case ChartFilterType.weekly:
              include = true;
              break;
            case ChartFilterType.daily:
              include = true;
              break;
            default:
              include = true;
          }

          if (include) {
            territoryCounts[territory] = (territoryCounts[territory] ?? 0) + 1;
          }
        }
      }
    }

    final sorted = territoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // sort by count
    territoryChartData.value =
        sorted.map((e) => ChartData(e.key, e.value)).toList();

    print("🌍 Territory Breakdown for $chartType:");
    for (var entry in territoryChartData) {
      print(" ➤ ${entry.month}: ${entry.count}");
    }
  }

  void generateSourceChartData(String chartType) {
    logger.d("fillter call111111");
    final Map<String, int> sourceCounts = {};

    for (var lead in allLeads) {
      final source = (lead.source ?? 'Unknown').trim();
      final creation = lead.creation;

      if (creation != null && creation.isNotEmpty) {
        final date = DateTime.tryParse(creation);
        if (date != null) {
          bool include = false;

          switch (chartType.toLowerCase()) {
            case  'yearly':
              include = date.year == DateTime.now().year;
              break;
            case 'quarterly':
              final nowQuarter = ((DateTime.now().month - 1) ~/ 3) + 1;
              final leadQuarter = ((date.month - 1) ~/ 3) + 1;
              include = (date.year == DateTime.now().year && leadQuarter == nowQuarter);
              break;
            case 'monthly':
              include = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month;
              break;
            case 'weekly':
              final now = DateTime.now();
              final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
              final endOfWeek = startOfWeek.add(const Duration(days: 6));
              include = date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
                  date.isBefore(endOfWeek.add(const Duration(days: 1)));
              break;
            case 'daily':
              final now = DateTime.now();
              include = date.day == now.day &&
                  date.month == now.month &&
                  date.year == now.year;
              break;
            default:
              include = true;
          }

          if (include) {
            sourceCounts[source] = (sourceCounts[source] ?? 0) + 1;
          }
        }
      }
    }

    final sorted = sourceCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // sort descending

    sourceChartData.value =
        sorted.map((e) => ChartData(e.key, e.value)).toList();

    print("🔍 Source Breakdown for $chartType:");
    for (var entry in sourceChartData) {
      print(" ➤ ${entry.month}: ${entry.count}");
    }

    update();
  }



  /// Helper to convert month number to name (e.g., 1 -> Jan)
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
  void updateChartTypeFor(String chartName, String selectedType) {
    if (!chartTypeMap.containsKey(chartName)) return;

    chartTypeMap[chartName]!.value = selectedType;

    print('📊 Updated Chart: $chartName - $selectedType');

    switch (chartName) {
      case 'Line Chart':
        _generateMonthWiseLeadCounts(selectedType);
        break;

      case 'Bar Chart':
        _generateWonChartData(selectedType);
        break;

      case 'Territory Chart':
        generateTerritoryChartData(selectedType);
        break;

      case 'Source Chart':
        generateSourceChartData(selectedType);
        break;

      case 'Sales Performance':
        generateLeadTypeBarChartData(selectedType);
        break;


      default:
        print('⚠️ Unknown chart name: $chartName');
    }
  }

  void generateLeadTypeBarChartData(String chartType) {
    final Map<String, Map<String, int>> periodWiseLeadTypeCounts = {};

    for (var lead in allLeads) {
      final creation = lead.creation;
      final leadType = (lead.leadName ?? 'Unknown').trim();

      if (creation != null && creation.isNotEmpty) {
        final date = DateTime.tryParse(creation);
        if (date != null) {
          String periodKey;

          switch (chartType.toLowerCase()) {
            case 'yearly':
              periodKey = "${date.year}";
              break;
            case 'quarterly':
              final quarter = ((date.month - 1) ~/ 3) + 1;
              periodKey = "Q$quarter ${date.year}";
              break;
            case 'monthly':
              periodKey = "${_getMonthName(date.month)} ${date.year}";
              break;
            case 'weekly':
              final week = ((date.day - 1) ~/ 7) + 1;
              periodKey = "Week $week ${_getMonthName(date.month)} ${date.year}";
              break;
            case 'daily':
              periodKey = "${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}";
              break;
            default:
              periodKey = "${_getMonthName(date.month)} ${date.year}";
          }

          // Create nested map entry
          if (!periodWiseLeadTypeCounts.containsKey(periodKey)) {
            periodWiseLeadTypeCounts[periodKey] = {};
          }

          periodWiseLeadTypeCounts[periodKey]![leadType] =
              (periodWiseLeadTypeCounts[periodKey]![leadType] ?? 0) + 1;
        }
      }
    }

    final List<SalesChart> tempList = [];

    // Flatten map into SalesChart list
    periodWiseLeadTypeCounts.forEach((period, leadTypeMap) {
      leadTypeMap.forEach((leadType, count) {
        tempList.add(SalesChart(period, leadType, count));
      });
    });

    // Sort by period
    tempList.sort((a, b) => a.month.compareTo(b.month));

    barChartData.value = tempList;

    print("📊 Lead Type Bar Chart ($chartType):");
    for (var entry in barChartData) {
      print(" ➤ ${entry.month} | ${entry.leadType}: ${entry.count}");
    }

    update();
  }


  List<CartesianSeries<SalesChart, String>> buildSalesBarSeries() {
    final Map<String, List<SalesChart>> grouped = {};

    for (var item in barChartData) {
      grouped.putIfAbsent(item.leadType, () => []).add(item);
    }

    return grouped.entries.map((entry) {
      return ColumnSeries<SalesChart, String>(
        name: entry.key,
        dataSource: entry.value,
        xValueMapper: (SalesChart data, _) => data.month,
        yValueMapper: (SalesChart data, _) => data.count,
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      );
    }).toList();
  }


}

/// Shared chart data model
class ChartData {
  final String month;
  final int count;

  ChartData(this.month, this.count);
}

class SalesChart {
  final String month;
  final String leadType;
  final int count;

  SalesChart(this.month,this.leadType ,this.count);
}
