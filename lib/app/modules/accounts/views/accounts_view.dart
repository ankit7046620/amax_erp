import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/accounts_controller.dart';

class AccountsView extends GetView<AccountsController> {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AccountsController());

    return Scaffold(
      appBar: AppBar(title: const Text("Accounts Dashboard")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildCard("Total", "₹${controller.total.value.toStringAsFixed(2)}", Icons.savings, Colors.teal),
                  _buildCard("Average", "₹${controller.average.value.toStringAsFixed(2)}", Icons.bar_chart, Colors.orange),
                  _buildCard("Top Month", controller.highestMonth.value, Icons.calendar_today, Colors.purple),
                  _buildCard("Months", "${controller.totalMonths.value}", Icons.date_range, Colors.blue),
                ],
              ),
              const SizedBox(height: 20),
              SfCartesianChart(
                title: ChartTitle(text: "Monthly Accounts Overview"),
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(title: AxisTitle(text: "Amount (₹)")),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                    dataSource: controller.chartDataList,
                    xValueMapper: (ChartData data, _) => data.month,
                    yValueMapper: (ChartData data, _) => data.amount,
                    name: "Accounts",
                    color: Colors.teal,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
