import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/sale_graph_controller.dart';

class SaleGraphView extends StatelessWidget {
  const SaleGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    final SaleGraphController controller = Get.put(SaleGraphController());

    final List<String> filterOptions = [
      'daily',
      'weekly',
      'monthly',
      'quarterly',
      'yearly',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Line Chart'),
        centerTitle: true,
      ),
      body:   Column(
        children: [
          const SizedBox(height: 16),

          // /// Filter Dropdown
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Row(
          //     children: [
          //       const Text("Filter: "),
          //       const SizedBox(width: 12),
          //       DropdownButton<String>(
          //         value: controller.selectedFilter.value,
          //         items: filterOptions
          //             .map((filter) => DropdownMenuItem(
          //           value: filter,
          //           child: Text(filter.capitalizeFirst!),
          //         ))
          //             .toList(),
          //         onChanged: (value) {
          //           if (value != null) {
          //             controller.onFilterChanged(value);
          //           }
          //         },
          //       ),
          //     ],
          //   ),
          // ),

          const SizedBox(height: 16),

          /// Line Chart
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
                    dataLabelSettings:
                    const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
