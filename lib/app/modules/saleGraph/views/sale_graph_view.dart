import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../controllers/sale_graph_controller.dart';


class SaleGraphView extends StatelessWidget {
  const SaleGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaleGraphController>(
      init: SaleGraphController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Sales Charts'), centerTitle: true),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),

                /// 🔹 LINE CHART HEADER
                sectionHeaderWithFilter(
                  title: "Sales Trends",
                  selectedValue: controller.chartTypeMap['Line Chart']!.value,
                  onFilterTap: (newFilter) {
                    controller.updateChartTypeFor('Line Chart', newFilter);
                  },
                ),

                const SizedBox(height: 12),

                /// 🔹 LINE CHART
                SizedBox(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Sales Trends'),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      primaryXAxis: CategoryAxis(),
                      series: <CartesianSeries<ChartDataSales, String>>[
                        LineSeries<ChartDataSales, String>(
                          dataSource: controller.lineChartData,
                          xValueMapper: (ChartDataSales data, _) => data.label,
                          yValueMapper: (ChartDataSales data, _) => data.value,
                          name: 'Sales',
                          markerSettings: const MarkerSettings(isVisible: true),
                          dataLabelSettings: const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 32),

                /// 🔹 BAR CHART HEADER
                sectionHeaderWithFilter(
                  title: "Customer Sales",
                  selectedValue: controller.chartTypeMap['Bar Chart']!.value,
                  onFilterTap: (newFilter) {
                    controller.chartTypeMap['Bar Chart']!.value = newFilter;
                    controller.generateCustomerSalesChartData(controller.receivedList,newFilter); // Optional filtering
                    controller.update();
                  },
                ),

                const SizedBox(height: 12),

                /// 🔹 BAR CHART
                Obx(() => controller.customerSalesChartData.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("No customer sales data available."),
                )
                    : SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SfCartesianChart(
                      title: ChartTitle(text: 'Customer-wise Total Sales'),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(text: 'Customer'),
                        labelRotation: 45,
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Total Sales (₹)'),
                        numberFormat: NumberFormat.currency(locale: 'en_IN', symbol: '₹'),
                      ),
                      series: <CartesianSeries<CustomerChartData, String>>[
                        ColumnSeries<CustomerChartData, String>(
                          dataSource: controller.customerSalesChartData,
                          xValueMapper: (CustomerChartData data, _) => data.customerName,
                          yValueMapper: (CustomerChartData data, _) => data.totalSales,
                          name: 'Sales',
                          color: Colors.indigo,
                          dataLabelSettings: const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🔹 Common Filter Header
  Widget sectionHeaderWithFilter({
    required String title,
    required String selectedValue,
    required ValueChanged<String> onFilterTap,
  }) {
    final SaleGraphController controller = Get.find();

    final currentValue = controller.chartTypes.contains(selectedValue)
        ? selectedValue
        : ChartFilterType.monthly;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              '$title ($currentValue)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          DropdownButton<String>(
            value: currentValue,
            icon: const Icon(Icons.arrow_drop_down),
            underline: Container(height: 1, color: Colors.transparent),
            style: const TextStyle(fontSize: 14, color: Colors.black),
            items: controller.chartTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onFilterTap(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
