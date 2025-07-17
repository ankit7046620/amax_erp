import 'package:amax_hr/main.dart';
import 'package:get/get.dart';
import 'package:amax_hr/vo/crm_model.dart';

class CrmGraphController extends GetxController {
  // All leads passed from the previous screen
  List<Data> allLeads = [];

  // Observable map: total leads grouped by month
  RxMap<String, int> monthWiseLeadCounts = <String, int>{}.obs;

  // Observable chart data: won leads per month
  RxList<ChartData> wonChartData = <ChartData>[].obs;

  // Observable count: total won leads
  RxInt wonLeadCount = 0.obs;

  // List of only won leads
  List<Data> wonLeads = [];

  @override
  void onInit() {
    super.onInit();
    // Get the list of leads from Get.arguments
    allLeads = Get.arguments as List<Data>;

    _categorizeLeads();               // 1. Separate won leads
    _generateMonthWiseLeadCounts();   // 2. All leads month-wise (line chart)
    _generateWonChartData();          // 3. Won leads month-wise (bar chart)
  }

  /// Filter and store 'Won' leads
  void _categorizeLeads() {
    wonLeads.clear();

    for (var lead in allLeads) {
      final status = (lead.status ?? '').trim().toLowerCase();
      if (status == 'won') {
        wonLeads.add(lead);
      }
    }

    // Update total count of won leads
    wonLeadCount.value = wonLeads.length;

    // ✅ Print total count
    print("🏆 Total Won Leads: ${wonLeadCount.value}");
  }

  /// Generate total leads grouped by month (for line chart)
  void _generateMonthWiseLeadCounts() {
    final Map<String, int> counts = {};

    for (var lead in allLeads) {
      final creation = lead.creation;
      if (creation != null && creation.isNotEmpty) {
        final date = DateTime.tryParse(creation);
        if (date != null) {
          final key = "${_getMonthName(date.month)} ${date.year}";
          counts[key] = (counts[key] ?? 0) + 1;
        }
      }
    }

    final sorted = counts.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    monthWiseLeadCounts.value = Map.fromEntries(sorted);
  }

  /// Generate won leads grouped by month (for bar chart)
  void _generateWonChartData() {
    logger.d("won leades:>");
    logger.d(wonLeads);

    final Map<String, int> counts = {};

    for (var lead in allLeads) {
      final creation = lead.creation;
      if (creation.isNotEmpty) {
        final date = DateTime.tryParse(creation);
        if (date != null) {
          final key = "${_getMonthName(date.month)} ${date.year}";
          counts[key] = (counts[key] ?? 0) + 1;
        }
      }
    }

    final sorted = counts.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    wonChartData.value = sorted.map((e) => ChartData(e.key, e.value)).toList();

    // ✅ Print month-wise won lead data
    print("📊 Won Leads Monthly Breakdown:");
    for (var entry in wonChartData) {
      print("   ➤ ${entry.month}: ${entry.count}");
    }
  }

  /// Helper to convert month number to name (e.g., 1 -> Jan)
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

/// Shared chart data model
class ChartData {
  final String month;
  final int count;

  ChartData(this.month, this.count);
}
