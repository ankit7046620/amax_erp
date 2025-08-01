import 'package:amax_hr/constant/url.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:get/get.dart';

class AccountsController extends GetxController {
  var isLoading = false.obs;
  final RxList<ChartData> chartDataList = <ChartData>[].obs;

  final RxDouble total = 0.0.obs;
  final RxDouble average = 0.0.obs;
  final RxString highestMonth = ''.obs;
  final RxInt totalMonths = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAccountsChartData();
  }

  Future<void> fetchAccountsChartData() async {
    try {
      isLoading.value = true;

      final response = await ApiService.get(
        ApiUri.getAccounts,
        params: {
          'chart_name': 'Accounts',
        },
      );

      if (response != null && response.statusCode == 200) {
        final msg = response.data['message'];
        final labels = msg['labels'] as List<dynamic>;
        final values = msg['datasets'][0]['values'] as List<dynamic>;

        List<ChartData> temp = [];
        double totalAmount = 0.0;

        for (int i = 0; i < labels.length; i++) {
          final String month = labels[i].toString();
          final double amount = double.tryParse(values[i].toString()) ?? 0.0;
          temp.add(ChartData(month: month, amount: amount));
          totalAmount += amount;
        }

        chartDataList.assignAll(temp);
        total.value = totalAmount;
        average.value = temp.isNotEmpty ? totalAmount / temp.length : 0.0;
        totalMonths.value = temp.length;

        if (temp.isNotEmpty) {
          final top = temp.reduce((a, b) => a.amount > b.amount ? a : b);
          highestMonth.value = top.month;
        }
      } else {
        print('❌ API response failed');
      }
    } catch (e) {
      print('❌ Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class ChartData {
  final String month;
  final double amount;

  ChartData({required this.month, required this.amount});
}