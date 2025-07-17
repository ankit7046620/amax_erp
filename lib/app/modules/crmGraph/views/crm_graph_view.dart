import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/crm_graph_controller.dart';


class CrmGraphView extends GetView<CrmGraphController> {
  const CrmGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CrmGraphController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 CRM Graph View'),
        centerTitle: true,
      ),
      body: Obx(() {
        /// Prepare line chart data
        final List<ChartData> leadChartData = controller.monthWiseLeadCounts.entries
            .map((entry) => ChartData(entry.key, entry.value))
            .toList();

        /// Prepare bar chart data
        final List<ChartData> wonChartData = controller.wonChartData;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📈 Monthly Lead Trends (Line Chart)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: leadChartData.isEmpty
                    ? const Center(child: Text("No lead data available"))
                    : SfCartesianChart(
                  title: ChartTitle(text: 'Total Leads Per Month'),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Month'),
                    labelRotation: -45,
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Lead Count'),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<ChartData, String>>[
                    LineSeries<ChartData, String>(
                      dataSource: leadChartData,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.count,
                      name: 'Leads',
                      markerSettings: const MarkerSettings(isVisible: true),
                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                '🏆 Monthly Won Opportunities (Bar Chart)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: wonChartData.isEmpty
                    ? const Center(child: Text("No 'Won' data available"))
                    : SfCartesianChart(
                  title: ChartTitle(text: 'Won Leads Per Month'),
                  primaryXAxis: CategoryAxis(
                    title: AxisTitle(text: 'Month'),
                    labelRotation: -45,
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(text: 'Won Count'),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  palette: const <Color>[Colors.green],
                  series: <CartesianSeries<ChartData, String>>[
                    ColumnSeries<ChartData, String>(
                      dataSource: wonChartData,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.count,
                      name: 'Won',
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
}
