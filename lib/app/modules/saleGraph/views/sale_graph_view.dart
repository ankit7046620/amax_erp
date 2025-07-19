import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/sale_graph_controller.dart';

class SaleGraphView extends StatelessWidget {
  const SaleGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaleGraphController>(
      init: SaleGraphController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Sales Line Chart'), centerTitle: true),
          body: Column(
            children: [
              const SizedBox(height: 16),

              // Header with filter dropdown
              sectionHeaderWithFilter(
                title: "Sales Trends",
                selectedValue: controller.chartTypeMap['Line Chart']!.value,
                onFilterTap: (newFilter) {
                  controller.updateChartTypeFor('Line Chart', newFilter);
                  controller.update(); // Trigger rebuild
                },
              ),

              const SizedBox(height: 12),

              // Line Chart
              SizedBox(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SfCartesianChart(
                    title: ChartTitle(text: 'Sales Trends'),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries>[
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
            ],
          ),
        );
      },
    );
  }

  /// Header with dropdown filter
  Widget sectionHeaderWithFilter({
    required String title,
    required String selectedValue,
    required ValueChanged<String> onFilterTap,
  }) {
    final SaleGraphController controller = Get.find();

    final currentValue = controller.chartTypes.contains(selectedValue)
        ? selectedValue
        : 'Monthly';

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
                print('$title - $value');
              }
            },
          ),
        ],
      ),
    );
  }
}
