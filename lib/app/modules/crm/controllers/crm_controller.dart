import 'package:amax_hr/app/modules/leadDetails/views/lead_details_view.dart';
import 'package:get/get.dart';
import 'package:amax_hr/vo/crm_model.dart';

class CrmController extends GetxController {
  late CrmModel crmModel;
  late String selectedModule;

  List<Data> allLeads = [];

  Map<String, List<Data>> leadsGroupedByStatus = {};
  RxMap<String, int> leadTypeCounts = <String, int>{}.obs;
  RxList<String> leadStatusList = <String>[].obs;
  RxList<Data> filteredLeads = <Data>[].obs;

  int totalLeads = 0;

  /// ✅ Counts by fixed lead type order
  List<int> leadCountsArray = [];

  /// ✅ Leads grouped in same order as fixedLeadTypes
  RxList<List<Data>> leadListArray = <List<Data>>[].obs;

  /// ✅ Fixed order to maintain mapping
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

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
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

    Map<String, int> counts = { for (var type in fixedLeadTypes) type: 0 };
    leadsGroupedByStatus = { for (var type in fixedLeadTypes) type: [] };
    Map<String, List<Data>> tempGrouped = { for (var type in fixedLeadTypes) type: [] };

    for (final lead in allLeads) {
      final status = (lead.status ?? 'Unknown').trim();

      if (counts.containsKey(status)) {
        counts[status] = counts[status]! + 1;
        leadsGroupedByStatus[status]?.add(lead);
        tempGrouped[status]?.add(lead);
      }
    }

    // Observable values
    leadTypeCounts.value = counts;

    leadStatusList.value = counts.entries
        .where((e) => e.value > 0)
        .map((e) => '${e.key} ${e.value}')
        .toList();

    // Array of counts
    leadCountsArray = fixedLeadTypes.map((type) => counts[type] ?? 0).toList();

    // Array of leads by type
    leadListArray.value = fixedLeadTypes.map((type) => tempGrouped[type] ?? []).toList();

    print("📥 leadCountsArray: $leadCountsArray");
    print("📂 leadListArray: ${leadListArray.length} types");
  }

  void filterLeadsByStatus(String status) {
    final trimmed = status.trim();
    filteredLeads.value = leadsGroupedByStatus[trimmed] ?? [];

    Get.to(() => LeadDetailsView(), arguments: {
      'status': trimmed,
      'leads': filteredLeads,
    });

    update();
  }

  void clearFilter() {
    filteredLeads.value = allLeads;
    update();
  }
}
