import 'package:amax_hr/app/modules/HrDashboar/controllers/hr_dashboar_controller.dart';
import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HrDashboarView extends GetView<HrDashboarController> {
  const HrDashboarView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HrDashboarController());
    return Scaffold(
             appBar:CommonAppBar(imagePath: AssetsConstant.tech_logo,showBack: true,),
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
                  'Human Resource Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // First Row - Total Employees, New Hires, Exits
                Row(
                  children: [
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'TOTAL EMPLOYEES',
                        value: controller.totalEmployees.value.toString(),
                        subtitle: '0 % since last month',
                        subtitleColor: Colors.grey.shade600,
                        icon: Icons.people,
                        iconColor: Colors.teal.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'NEW HIRES (THIS YEAR)',
                        value: controller.newHiresThisYear.value.toString(),
                        subtitle: '0 % since last month',
                        subtitleColor: Colors.blue.shade600,
                        icon: Icons.person_add,
                        iconColor: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Second Row - Employee Exits
                Row(
                  children: [
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'EMPLOYEE EXITS (THIS YEAR)',
                        value: controller.employeeExitsThisYear.value.toString(),
                        subtitle: '0 % since last month',
                        subtitleColor: Colors.red.shade600,
                        icon: Icons.person_remove,
                        iconColor: Colors.red.shade600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'EMPLOYEES JOINING (THIS QUARTER)',
                        value: controller.employeesJoiningThisQuarter.value.toString(),
                        subtitle: '0 % since last quarter',
                        subtitleColor: Colors.grey.shade700,
                        icon: Icons.trending_up,
                        iconColor: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Third Row - Quarterly Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'EMPLOYEES RELIEVING (THIS QUARTER)',
                        value: controller.employeesRelievingThisQuarter.value.toString(),
                        subtitle: '0 % since last quarter',
                        subtitleColor: Colors.grey.shade700,
                        icon: Icons.trending_down,
                        iconColor: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Employee Analytics Chart
                _buildChartCard(
                  title: 'Employee Analytics',
                  subtitle: 'Current Year',
                  child: SizedBox(
                    height: 250,
                    child: SfCartesianChart(
                      onSelectionChanged: (SelectionArgs args) {
                        if (args.seriesIndex != null && args.pointIndex != null) {
                          final seriesData = args.seriesIndex == 0
                              ? controller.employeeAnalyticsData.where((data) => data.type == "New Hires").toList()
                              : controller.employeeAnalyticsData.where((data) => data.type == "Exits").toList();

                          if (args.pointIndex! < seriesData.length) {
                            final selectedData = seriesData[args.pointIndex!];
                            _showValueTooltip(context, selectedData.type, selectedData.value.toDouble());
                          }
                        }
                      },
                      enableAxisAnimation: true,
                      primaryXAxis: CategoryAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        labelFormat: '{value}',
                        majorGridLines: const MajorGridLines(width: 0.5),
                      ),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.top,
                        alignment: ChartAlignment.center,
                      ),
                      series: <CartesianSeries>[
                        ColumnSeries<EmployeeAnalyticsData, String>(
                          dataSource: controller.employeeAnalyticsData.where((data) => data.type == "New Hires").toList(),
                          xValueMapper: (data, _) => data.month,
                          yValueMapper: (data, _) => data.value,
                          name: "New Hires",
                          color: const Color(0xFF4CAF50),
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            selectedColor: const Color(0xFF4CAF50).withOpacity(0.7),
                          ),
                        ),
                        ColumnSeries<EmployeeAnalyticsData, String>(
                          dataSource: controller.employeeAnalyticsData.where((data) => data.type == "Exits").toList(),
                          xValueMapper: (data, _) => data.month,
                          yValueMapper: (data, _) => data.value,
                          name: "Exits",
                          color: const Color(0xFFE91E63),
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            selectedColor: const Color(0xFFE91E63).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Department-wise Employee Distribution (Pie Chart)
                _buildChartCard(
                  title: 'Department-wise Employee Distribution',
                  child: SizedBox(
                    height: 300,
                    child: SfCircularChart(
                      onSelectionChanged: (SelectionArgs args) {
                        if (args.pointIndex != null && args.pointIndex! < controller.departmentChartData.length) {
                          final selectedData = controller.departmentChartData[args.pointIndex!];
                          _showValueTooltip(context, selectedData.department, selectedData.count.toDouble());
                        }
                      },
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<DepartmentChartData, String>(
                          dataSource: controller.departmentChartData,
                          xValueMapper: (data, _) => data.department,
                          yValueMapper: (data, _) => data.count,
                          dataLabelMapper: (data, _) => '${data.count}',
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

                // Designation-wise Employee Distribution (Pie Chart)
                _buildChartCard(
                  title: 'Designation-wise Employee Distribution',
                  child: SizedBox(
                    height: 300,
                    child: SfCircularChart(
                      onSelectionChanged: (SelectionArgs args) {
                        if (args.pointIndex != null && args.pointIndex! < controller.designationChartData.length) {
                          final selectedData = controller.designationChartData[args.pointIndex!];
                          _showValueTooltip(context, selectedData.designation, selectedData.count.toDouble());
                        }
                      },
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<DesignationChartData, String>(
                          dataSource: controller.designationChartData,
                          xValueMapper: (data, _) => data.designation,
                          yValueMapper: (data, _) => data.count,
                          dataLabelMapper: (data, _) => '${data.count}',
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
            Row(
              children: [
                Expanded(child: _shimmerCard()),
                const SizedBox(width: 12),
                Expanded(child: Container()),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _shimmerCard()),
                const SizedBox(width: 12),
                Expanded(child: _shimmerCard()),
              ],
            ),
            const SizedBox(height: 24),
            _shimmerCard(height: 250),
            const SizedBox(height: 20),
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