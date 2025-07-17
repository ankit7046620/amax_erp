import 'package:amax_hr/app/modules/leadDetails/views/lead_details_view.dart';
import 'package:get/get.dart';
import 'package:amax_hr/vo/crm_model.dart';

class CrmController extends GetxController {
  late CrmModel crmModel;
  late String selectedModule;

  List<Data> allLeads = [];

  /// Grouped leads by fixed status order
  Map<String, List<Data>> leadsGroupedByStatus = {};

  /// Counts per lead type (observable for UI if needed)
  RxMap<String, int> leadTypeCounts = <String, int>{}.obs;

  /// Formatted lead type + count (like "Open 5", etc.)
  RxList<String> leadStatusList = <String>[].obs;

  /// Used in detail screen
  RxList<Data> filteredLeads = <Data>[].obs;

  int totalLeads = 0;

  /// Fixed order of lead types (used for indexing and display)
  final List<String> fixedLeadTypes = [
    'Open',
    'Lead',
    'Opportunity',
    'Quotation',
    'Converted',
    'Do Not Contact',
    'Interested',
    'Won',
    'Lost',
  ];

  /// Indexed list of counts in fixedLeadTypes order
  List<int> leadCountsArray = [];

  /// Indexed list of lead lists in fixedLeadTypes order
  RxList<List<Data>> leadListArray = <List<Data>>[].obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args is Map && args.containsKey('model')) {
      crmModel = args['model'] as CrmModel;
      selectedModule = args['module'] ?? 'Unknown';
      processLeads();
    } else {
      print('❌ Invalid or missing arguments in CrmController');
    }
  }

  void processLeads() {
    allLeads = crmModel.data;
    totalLeads = allLeads.length;

    // Prepare empty structure
    final Map<String, List<Data>> grouped = {
      for (var type in fixedLeadTypes) type: [],
    };

    final Map<String, int> counts = {
      for (var type in fixedLeadTypes) type: 0,
    };

    // Group leads by status
    for (final lead in allLeads) {
      final status = (lead.status ?? 'Unknown').trim();
      if (grouped.containsKey(status)) {
        grouped[status]!.add(lead);
        counts[status] = (counts[status] ?? 0) + 1;
      }
    }

    leadsGroupedByStatus = grouped;
    leadTypeCounts.value = counts;

    leadStatusList.value = counts.entries
        .where((e) => e.value > 0)
        .map((e) => '${e.key} ${e.value}')
        .toList();

    leadCountsArray = fixedLeadTypes.map((type) => counts[type] ?? 0).toList();
    leadListArray.value = fixedLeadTypes.map((type) => grouped[type] ?? []).toList();

    print("📥 leadCountsArray: $leadCountsArray");
    print("📂 leadListArray: ${leadListArray.length} types");
  }

  void filterLeadsByStatus(String status) {
    final trimmedStatus = status.trim();
    final leads = leadsGroupedByStatus[trimmedStatus] ?? [];

    filteredLeads.value = leads;

    Get.to(() => const LeadDetailsView(), arguments: {
      'status': trimmedStatus,
      'leads': leads, // not RxList, just raw List<Data>
    });
  }

  void clearFilter() {
    filteredLeads.value = allLeads;
  }
}
