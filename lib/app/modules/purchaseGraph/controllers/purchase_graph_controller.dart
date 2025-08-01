import 'package:amax_hr/app/modules/crmGraph/controllers/crm_graph_controller.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/vo/pinvoice.dart';
import 'package:amax_hr/vo/purchase_order_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../purchaseOrdersDashboard/controllers/purchase_orders_dashboard_controller.dart';

class PurchaseGraphController extends GetxController {
  //TODO: Implement PurchaseGraphController
  RxList<ChartData> pOrderChartData = <ChartData>[].obs;

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPurchaseData();
    // _loadPassedData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  List<PurchaseOrderDataList> purchaseOrders = [];
  List<Pinvoice> pinvoce = [];
  List<Map<String, dynamic>> purchaseOrdersData = [];

  Future<void> fetchPurchaseData() async {
    EasyLoading.show();
    try {
      final response = await ApiService.get(
        '/api/resource/Purchase Invoice?',
        params: {'fields': '["*"]', 'limit_page_length': '1000'},
      );

      if (response != null && response.statusCode == 200) {
        final List<Pinvoice> list = (response.data['data'] as List)
            .map((e) => Pinvoice.fromJson(e))
            .toList();

        EasyLoading.dismiss();

     pinvoce= list;
        calculatePurchaseInvoiceStats(ChartFilterType.yearly,list);


        logger.d("✅ Purchases loaded: ${list.length}");
      } else {
        EasyLoading.dismiss();

        logger.e("❌ Failed to fetch purchases");
      }
    } catch (e) {
      EasyLoading.dismiss();

      logger.e("❌ Error fetching purchases: $e");
    } finally {

      EasyLoading.dismiss();

    }
  }
  void calculatePurchaseInvoiceStats(String chartType, List<Pinvoice> invoices) {
    int count = 0;
    double totalBilled = 0.0;
    double totalOutstanding = 0.0;

    final Map<String, int> statusCounts = {};
    final now = DateTime.now();

    print("📦 Filter: $chartType");
    print("📋 Matching Invoices:");

    for (var invoice in invoices) {
      if (invoice.docstatus == 1) continue; // Only process docstatus == 1

      final dateStr = invoice.postingDate;
      final date = DateTime.tryParse(dateStr ?? '');
      if (date == null) continue;

      bool include = false;
      switch (chartType.toLowerCase()) {
        case 'daily':
          include = date.year == now.year && date.month == now.month && date.day == now.day;
          break;
        case 'weekly':
          include = now.difference(date).inDays <= 7;
          break;
        case 'monthly':
          include = date.year == now.year && date.month == now.month;
          break;
        case 'quarterly':
          final currentQuarter = ((now.month - 1) ~/ 3) + 1;
          final invoiceQuarter = ((date.month - 1) ~/ 3) + 1;
          include = date.year == now.year && currentQuarter == invoiceQuarter;
          break;
        case 'yearly':
          include = date.year == now.year;
          break;
        default:
          include = true;
      }

      if (!include) continue; // Skip if outside date range

      count++;

      final base = invoice.baseGrandTotal ?? 0.0;
      final outstanding = invoice.outstandingAmount ?? 0.0;
      final billed = base - outstanding;

      totalBilled += billed;
      totalOutstanding += outstanding;

      final status = invoice.status?.trim() ?? 'Unknown';

      statusCounts.update(status, (value) => value + 1, ifAbsent: () => 1);

      print(" ➤ ${invoice.name ?? 'N/A'} | ➤ ${invoice.docstatus ?? 'N/A'} | Status: $status | Date: ${invoice.creation} | Billed: ₹${billed.toStringAsFixed(2)} | Outstanding: ₹${outstanding.toStringAsFixed(2)}");
    }

    print("🔢 Total Invoices (docstatus == 1): $count");
    print("💰 Total Billed: ₹${totalBilled.toStringAsFixed(2)}");
    print("🧾 Total Outstanding: ₹${totalOutstanding.toStringAsFixed(2)}");

    print("\n📊 Status-wise Invoice Counts:");
    for (var entry in statusCounts.entries) {
      print(" • ${entry.key}: ${entry.value}");
    }
  }







  void _loadPassedData() {
    final args = Get.arguments;
    logger.d('✅ Purchase data args: $args');

    if (args is Map && args.containsKey('model')) {
      final String module = args['module'];
      final List<PurchaseOrderDataList> receivedList =
      List<PurchaseOrderDataList>.from(args['model']);

      purchaseOrders = receivedList;
      purchaseOrdersData = receivedList.map((e) => e.toJson()).toList();



      logger.d(
        '✅ Loaded ${purchaseOrders.length} purchase items for module: $module',
      );
    } else {
      logger.e('❌ Invalid or missing purchase data in arguments');
    }
  }}
