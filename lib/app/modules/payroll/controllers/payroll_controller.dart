import 'package:amax_hr/constant/url.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/vo/payroll_model.dart';
import 'package:get/get.dart';

class PayrollController extends GetxController {
  var isLoading = false.obs;

  /// List of full salary records (optional, if showing table or list)
  final RxList<PayrollModel> payrollData = <PayrollModel>[].obs;

  /// Raw month-wise salary totals (optional)
  final RxMap<String, double> monthlyTotals = <String, double>{}.obs;

  /// Chart data for Syncfusion bar/line chart
  final RxList<ChartData> chartDataList = <ChartData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPayrollSalarySlipData();
  }

  Future<void> fetchPayrollSalarySlipData() async {
    try {
      isLoading.value = true;

      final response = await ApiService.get(
        ApiUri.getSalaryData, // e.g., '/api/resource/Salary Slip'
        params: {
          'fields': '["*"]',
          'filters': '[["docstatus","=",1]]',
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.statusCode == 200) {
        final List<dynamic> salarySlips = response.data['data'] ?? [];

        final parsedList = salarySlips
            .map((e) => PayrollModel.fromJson(e as Map<String, dynamic>))
            .toList();

        payrollData.assignAll(parsedList);

        processPayrollData(parsedList);
      } else {
        print('❌ Failed to fetch Salary Slips');
      }
    } catch (e) {
      print('❌ Error fetching Payroll data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void processPayrollData(List<PayrollModel> data) {
    final Map<String, double> groupedData = {};

    for (var record in data) {
      final dateStr = record.startDate;
      final netPay = double.tryParse(record.netPay.toString()) ?? 0.0;

      final date = DateTime.tryParse(dateStr!);
      if (date != null) {
        final key = '${date.year}-${date.month.toString().padLeft(2, '0')}';
        groupedData[key] = (groupedData[key] ?? 0.0) + netPay;
      }
    }

    monthlyTotals.value = groupedData;

    final chartList = groupedData.entries
        .map((e) => ChartData(month: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => a.month.compareTo(b.month));

    chartDataList.assignAll(chartList);
  }
}

/// Chart data model for Syncfusion chart
class ChartData {
  final String month;
  final double amount;

  ChartData({required this.month, required this.amount});
}
