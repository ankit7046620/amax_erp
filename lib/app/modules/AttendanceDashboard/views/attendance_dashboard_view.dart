import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/attendance_dashboard_controller.dart';

class AttendanceDashboardView extends GetView<AttendanceDashboardController> {
  const AttendanceDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AttendanceDashboardController());
    return _buildAttendanceDashboardContent();
  }

  // Main Dashboard Content
  Widget _buildAttendanceDashboardContent() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerPlaceholder();
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // First Row - Attendance Metrics
            Row(
              children: [
                Expanded(
                  child: _buildDashboardCard(
                    title: 'TOTAL PRESENT (TODAY)',
                    value: controller.totalPresentToday.value.toString(),
                    subtitle: '0 % since last month',
                    subtitleColor: Colors.grey.shade600,
                    icon: Icons.check_circle,
                    iconColor: Colors.green.shade600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardCard(
                    title: 'TOTAL ABSENT (TODAY)',
                    value: controller.totalAbsentToday.value.toString(),
                    subtitle: '0 % since last month',
                    subtitleColor: Colors.red.shade600,
                    icon: Icons.cancel,
                    iconColor: Colors.red.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Second Row - Late Entry and Early Exit
            Row(
              children: [
                Expanded(
                  child: _buildDashboardCard(
                    title: 'LATE ENTRY (TODAY)',
                    value: controller.lateEntryToday.value.toString(),
                    subtitle: '0 % since last month',
                    subtitleColor: Colors.orange.shade600,
                    icon: Icons.access_time,
                    iconColor: Colors.orange.shade600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardCard(
                    title: 'EARLY EXIT (THIS MONTH)',
                    value: controller.earlyExitThisMonth.value.toString(),
                    subtitle: '0 % since last month',
                    subtitleColor: Colors.purple.shade600,
                    icon: Icons.exit_to_app,
                    iconColor: Colors.purple.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Attendance Count Chart
            _buildChartCard(
              title: 'Attendance Count',
              subtitle: 'Last synced 7 minutes ago',
              child: SizedBox(
                height: 250,
                child: SfCartesianChart(
                  onSelectionChanged: (SelectionArgs args) {
                    if (args.seriesIndex != null && args.pointIndex != null) {
                      final seriesName = args.seriesIndex == 0
                          ? 'Absent'
                          : args.seriesIndex == 1
                          ? 'Present'
                          : 'Leave';

                      final monthData = [
                        'Jan',
                        'Feb',
                        'Mar',
                        'Apr',
                        'May',
                        'Jun',
                        'Jul',
                      ];
                      if (args.pointIndex! < monthData.length) {
                        final month = monthData[args.pointIndex!];
                        final data = controller.attendanceCountData
                            .where(
                              (d) => d.type == seriesName && d.month == month,
                            )
                            .toList();

                        if (data.isNotEmpty) {
                          _showValueTooltip(
                            Get.context!,
                            '$seriesName - $month',
                            data.first.value.toDouble(),
                          );
                        }
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
                    minimum: 0,
                    maximum: 3,
                    interval: 0.5,
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    alignment: ChartAlignment.center,
                  ),
                  series: <CartesianSeries>[
                    LineSeries<AttendanceData, String>(
                      dataSource: controller.attendanceCountData
                          .where((data) => data.type == "Absent")
                          .toList(),
                      xValueMapper: (data, _) => data.month,
                      yValueMapper: (data, _) => data.value,
                      name: "Absent",
                      color: const Color(0xFFE91E63),
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                      ),
                    ),
                    LineSeries<AttendanceData, String>(
                      dataSource: controller.attendanceCountData
                          .where((data) => data.type == "Present")
                          .toList(),
                      xValueMapper: (data, _) => data.month,
                      yValueMapper: (data, _) => data.value,
                      name: "Present",
                      color: const Color(0xFF2196F3),
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                      ),
                    ),
                    LineSeries<AttendanceData, String>(
                      dataSource: controller.attendanceCountData
                          .where((data) => data.type == "Leave")
                          .toList(),
                      xValueMapper: (data, _) => data.month,
                      yValueMapper: (data, _) => data.value,
                      name: "Leave",
                      color: const Color(0xFF4CAF50),
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Column with Timesheet Activity and Shift Assignment
            Column(
              children: [
                _buildChartCard(
                  title: 'Timesheet Activity Breakup',
                  subtitle: 'Last synced 7 minutes ago',
                  child: SizedBox(
                    height: 200,
                    child: controller.timesheetActivityData.isNotEmpty
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'PLANNING: ${controller.timesheetActivityData.first.percentage}%',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200,
                          ),
                          child: FractionallySizedBox(
                            widthFactor: controller.timesheetActivityData.first.percentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFF2196F3),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2196F3),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Planning\n${controller.timesheetActivityData.first.hours}',
                              style: const TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    )
                        : const Center(child: Text('No Data')),
                  ),
                ),
                const SizedBox(height: 16), // Vertical spacing between cards
                _buildChartCard(
                  title: 'Shift Assignment Breakup',
                  subtitle: 'Last synced 7 minutes ago',
                  child: const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'No Data',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Department wise Timesheet Hours
            _buildChartCard(
              title: 'Department wise Timesheet Hours',
              subtitle: 'Last synced 7 minutes ago',
              child: SizedBox(
                height: 250,
                child: controller.departmentTimesheetData.isNotEmpty
                    ? SfCartesianChart(
                        onSelectionChanged: (SelectionArgs args) {
                          if (args.pointIndex != null &&
                              args.pointIndex! <
                                  controller.departmentTimesheetData.length) {
                            final selectedData = controller
                                .departmentTimesheetData[args.pointIndex!];
                            _showValueTooltip(
                              Get.context!,
                              selectedData.department,
                              selectedData.hours.toDouble(),
                            );
                          }
                        },
                        enableAxisAnimation: true,
                        primaryXAxis: CategoryAxis(
                          majorGridLines: const MajorGridLines(width: 0),
                        ),
                        primaryYAxis: NumericAxis(
                          labelFormat: '{value}',
                          majorGridLines: const MajorGridLines(width: 0.5),
                          minimum: 0,
                          maximum: 50,
                          interval: 10,
                        ),
                        series: <CartesianSeries>[
                          ColumnSeries<DepartmentTimesheetData, String>(
                            dataSource: controller.departmentTimesheetData,
                            xValueMapper: (data, _) => data.department,
                            yValueMapper: (data, _) => data.hours,
                            color: const Color(0xFFE91E63),
                            selectionBehavior: SelectionBehavior(
                              enable: true,
                              selectedColor: const Color(
                                0xFFE91E63,
                              ).withOpacity(0.7),
                            ),
                          ),
                        ],
                      )
                    : const Center(child: Text('No Data')),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Dashboard Card Widget
  Widget _buildDashboardCard({
    required String title,
    required String value,
    required String subtitle,
    required Color subtitleColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 12, color: subtitleColor)),
        ],
      ),
    );
  }

  // Chart Card Widget
  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.grey),
                onPressed: () {
                  // Handle menu action
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // Shimmer Loading Placeholder
  Widget _buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildShimmerCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerCard()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildShimmerCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildShimmerCard()),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Show Value Tooltip
  void _showValueTooltip(BuildContext context, String label, double value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label: ${value.toStringAsFixed(0)}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }
}
