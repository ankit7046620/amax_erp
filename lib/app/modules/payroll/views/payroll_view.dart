import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/payroll_controller.dart';

class PayrollChartView extends GetView<PayrollController> {
  const PayrollChartView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PayrollController());

    return Scaffold(
    appBar:CommonAppBar(imagePath: AssetsConstant.tech_logo,showBack: true,),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final chartData = controller.chartDataList;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // ✅ 2x2 Summary Cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildCard('Total Employees', '${controller.payrollData.length}', Icons.people, Colors.indigo),
                  _buildCard('Total Net Pay', '₹${'100'}', Icons.payments, Colors.teal),
                  _buildCard('Average Salary', '₹${'100'}', Icons.bar_chart, Colors.orange),
                  _buildCard('Top Month', '10', Icons.star, Colors.purple),
                ],
              ),
              const SizedBox(height: 20),

              // ✅ Chart
              SizedBox(
                height: 400,
                child: SfCartesianChart(
                  title: ChartTitle(text: 'Monthly Net Salary'),
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(title: AxisTitle(text: 'Net Pay (₹)')),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<ChartData, String>>[
                    ColumnSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.amount,
                      name: 'Net Pay',
                      color: Colors.teal,
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
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
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
