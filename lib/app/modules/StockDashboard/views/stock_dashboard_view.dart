import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/stock_dashboard_controller.dart';

class StockDashboardView extends GetView<StockDashboardController> {
  const StockDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StockDashboardController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerPlaceholder();
        }

        // Error widget removed

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stock Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'TOTAL ACTIVE ITEMS',
                        value: controller.totalActiveItems.value.toString(),
                        subtitle: '',
                        subtitleColor: Colors.green.shade600,
                        icon: Icons.inventory_2,
                        iconColor: Colors.teal.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'TOTAL WAREHOUSES',
                        value: controller.totalWarehouses.value.toString(),
                        subtitle: '',
                        subtitleColor: Colors.blue.shade600,
                        icon: Icons.warehouse,
                        iconColor: Colors.deepOrange.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDashboardCard(
                  title: 'TOTAL STOCK VALUE',
                  value: controller.totalStockValue.value,
                  subtitle: '0% since yesterday',
                  subtitleColor: Colors.grey.shade700,
                  icon: Icons.monetization_on,
                  iconColor: Colors.green.shade700,
                  isFullWidth: true,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  height: 300,
                  child: SfCartesianChart(

                    primaryXAxis: CategoryAxis(

                        labelRotation: -45,
                        majorGridLines: const MajorGridLines(width: 0),
                        labelIntersectAction: AxisLabelIntersectAction.rotate45,
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        isVisible: true,
                        maximumLabelWidth: 80,
                        labelPlacement: LabelPlacement.onTicks,
                        axisLine: const AxisLine(width: 0),
                        labelStyle: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                        )
                    ),
                    title: ChartTitle(text: 'Total Stock Value by Warehouse'),
                    series: <CartesianSeries>[
                      ColumnSeries<WarehouseStockChartData, String>(
                        dataSource: controller.barChartData,
                        xValueMapper: (data, _) => data.warehouse,
                        yValueMapper: (data, _) => data.totalStockValue,
                        name: 'Stock Value',
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
 

                    primaryXAxis: CategoryAxis(
                      // Set based on your max value
                        labelRotation: -45,
                        majorGridLines: const MajorGridLines(width: 0),
                        labelIntersectAction: AxisLabelIntersectAction.rotate45,
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        isVisible: true,
                        maximumLabelWidth: 80,
                        labelPlacement: LabelPlacement.onTicks,
                        axisLine: const AxisLine(width: 0),
                        labelStyle: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                        )
                    ),
                    title: ChartTitle(text: 'Total Stock Value by Warehouse'),
                    series: <CartesianSeries>[
                      ColumnSeries<WarehouseStockChartData, String>(
                        dataSource: controller.shortBarChartData,
                        xValueMapper: (data, _) => data.warehouse,
                        yValueMapper: (data, _) => data.totalStockValue,
                        name: 'Stock Value',
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _shimmerCard()),
                const SizedBox(width: 12),
                Expanded(child: _shimmerCard()),
              ],
            ),
            const SizedBox(height: 12),
            _shimmerCard(height: 100),
            const SizedBox(height: 24),
            _shimmerCard(height: 220),
          ],
        ),
      ),
    );
  }

  Widget _shimmerCard({double height = 80}) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required String subtitle,
    required Color subtitleColor,
    required IconData icon,
    required Color iconColor,
    bool isFullWidth = false,
  }) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}