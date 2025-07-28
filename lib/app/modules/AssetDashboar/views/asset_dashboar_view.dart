import 'package:amax_hr/app/modules/AssetDashboar/controllers/asset_dashboar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AssetDashboardView extends GetView<AssetDashboardController> {
  const AssetDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AssetDashboardController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Dashboard'),
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

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Asset Dashboard',
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
                        title: 'TOTAL ASSETS',
                        value: controller.totalAssets.value.toString(),
                        subtitle: '0 % since last month',
                        subtitleColor: Colors.grey.shade600,
                        icon: Icons.account_balance,
                        iconColor: Colors.teal.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'NEW ASSETS (THIS YEAR)',
                        value: controller.newAssetsThisYear.value.toString(),
                        subtitle: '0 % since last month',
                        subtitleColor: Colors.blue.shade600,
                        icon: Icons.add_circle_outline,
                        iconColor: Colors.deepOrange.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDashboardCard(
                  title: 'ASSET VALUE',
                  value: controller.totalAssetValue.value,
                  subtitle: '0 % since last month',
                  subtitleColor: Colors.grey.shade700,
                  icon: Icons.monetization_on,
                  iconColor: Colors.green.shade700,
                  isFullWidth: true,
                ),
                const SizedBox(height: 24),

                // Asset Value Analytics Chart with click event
                _buildChartCard(
                  title: 'Asset Value Analytics',
                  subtitle: 'NOV 2023',
                  child: SizedBox(
                    height: 250,
                    child: SfCartesianChart(
                      onSelectionChanged: (SelectionArgs args) {
                        // Handle column click event
                        if (args.seriesIndex != null && args.pointIndex != null) {
                          final seriesData = args.seriesIndex == 0
                              ? controller.assetValueAnalyticsData.where((data) => data.type == "Asset Value").toList()
                              : controller.assetValueAnalyticsData.where((data) => data.type == "Depreciated Amount").toList();

                          if (args.pointIndex! < seriesData.length) {
                            final selectedData = seriesData[args.pointIndex!];
                            _showValueTooltip(context, selectedData.type, selectedData.value);
                          }
                        }
                      },
                      enableAxisAnimation: true,
                      primaryXAxis: CategoryAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        labelFormat: '{value}L',
                        majorGridLines: const MajorGridLines(width: 0.5),
                      ),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.top,
                        alignment: ChartAlignment.center,
                      ),
                      series: <CartesianSeries>[
                        StackedColumnSeries<AssetValueAnalyticsData, String>(
                          dataSource: controller.assetValueAnalyticsData.where((data) => data.type == "Asset Value").toList(),
                          xValueMapper: (data, _) => "Nov 2023",
                          yValueMapper: (data, _) => data.value / 100000,
                          name: "Asset Value",
                          color: const Color(0xFFE91E63),
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            selectedColor: const Color(0xFFE91E63).withOpacity(0.7),
                          ),
                        ),
                        StackedColumnSeries<AssetValueAnalyticsData, String>(
                          dataSource: controller.assetValueAnalyticsData.where((data) => data.type == "Depreciated Amount").toList(),
                          xValueMapper: (data, _) => "Nov 2023",
                          yValueMapper: (data, _) => data.value / 100000,
                          name: "Depreciated Amount",
                          color: const Color(0xFF2196F3),
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            selectedColor: const Color(0xFF2196F3).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Category and Location Charts - Changed to Column Layout
                // Category-wise Asset Value (Pie Chart)
                _buildChartCard(
                  title: 'Category-wise Asset Value',
                  child: SizedBox(
                    height: 300,
                    child: SfCircularChart(
                      onSelectionChanged: (SelectionArgs args) {
                        // Handle pie chart click event
                        if (args.pointIndex != null && args.pointIndex! < controller.categoryChartData.length) {
                          final selectedData = controller.categoryChartData[args.pointIndex!];
                          _showValueTooltip(context, selectedData.category, selectedData.value);
                        }
                      },
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<AssetCategoryChartData, String>(
                          dataSource: controller.categoryChartData,
                          xValueMapper: (data, _) => data.category,
                          yValueMapper: (data, _) => data.value,
                          dataLabelMapper: (data, _) => '${(data.value / 1000).toStringAsFixed(0)}K',
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            textStyle: TextStyle(fontSize: 10),
                          ),
                          innerRadius: '60%',
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            unselectedOpacity: 0.5,
                          ),
                          pointColorMapper: (data, index) {
                            final colors = [
                              const Color(0xFFE91E63),
                              const Color(0xFF2196F3),
                              const Color(0xFF4CAF50),
                              const Color(0xFF9E9E9E),
                              const Color(0xFFFF9800),
                              const Color(0xFF9C27B0),
                            ];
                            return colors[index! % colors.length];
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Location-wise Asset Value (Pie Chart)
                _buildChartCard(
                  title: 'Location-wise Asset Value',
                  child: SizedBox(
                    height: 300,
                    child: SfCircularChart(
                      onSelectionChanged: (SelectionArgs args) {
                        // Handle pie chart click event
                        if (args.pointIndex != null && args.pointIndex! < controller.locationChartData.length) {
                          final selectedData = controller.locationChartData[args.pointIndex!];
                          _showValueTooltip(context, selectedData.location, selectedData.totalAssetValue);
                        }
                      },
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<AssetLocationChartData, String>(
                          dataSource: controller.locationChartData,
                          xValueMapper: (data, _) => data.location,
                          yValueMapper: (data, _) => data.totalAssetValue,
                          dataLabelMapper: (data, _) => '${(data.totalAssetValue / 1000).toStringAsFixed(0)}K',
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            textStyle: TextStyle(fontSize: 10),
                          ),
                          innerRadius: '60%',
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            unselectedOpacity: 0.5,
                          ),
                          pointColorMapper: (data, index) {
                            final colors = [
                              const Color(0xFFE91E63),
                              const Color(0xFF2196F3),
                              const Color(0xFF4CAF50),
                              const Color(0xFF9E9E9E),
                              const Color(0xFFFF9800),
                              const Color(0xFF9C27B0),
                            ];
                            return colors[index! % colors.length];
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Method to show tooltip-style popup when chart elements are clicked
  void _showValueTooltip(BuildContext context, String title, double value) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    '${title.toUpperCase()}: ${_formatValue(value)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-close after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      overlayEntry.remove();
    });
  }

  // Helper method to format values
  String _formatValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
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
            _shimmerCard(height: 250),
            const SizedBox(height: 20),
            // Updated shimmer for column layout
            _shimmerCard(height: 300),
            const SizedBox(height: 20),
            _shimmerCard(height: 300),
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

  Widget _buildChartCard({
    required String title,
    String? subtitle,
    required Widget child,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
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