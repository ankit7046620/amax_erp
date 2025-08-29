import 'package:amax_hr/app/modules/EmployeeCheckin/views/employee_checkin_view.dart'
    show EmployeeCheckinView;
import 'package:amax_hr/app/modules/HrDashboar/controllers/hr_dashboar_controller.dart';
import 'package:amax_hr/app/modules/HrDashboar/controllers/recruitment_dashboard_controller.dart';

import 'package:amax_hr/app/routes/app_pages.dart' show Routes;

import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';

import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../AttendanceDashboard/views/attendance_dashboard_view.dart';

class HrDashboarView extends GetView<HrDashboarController> {
  const HrDashboarView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HrDashboarController());

    // Reactive variables for managing expanded states
    final RxInt expandedDashboard =
        (-1).obs; // HR Dashboard expanded by default
    return GetBuilder<HrDashboarController>(
      builder: (controller) {
        return Scaffold(
          appBar: CommonAppBar(
            showBack: true,
            imagePath: AssetsConstant.tech_logo,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // HR Dashboard Section
                if (controller.isHrManager.value == true) ...[
                  _buildDashboardSection(
                    index: 0,
                    title: 'HR Dashboard',
                    icon: Icons.people,
                    color: Colors.indigo,
                    expandedDashboard: expandedDashboard,
                    content: _buildHRDashboardContent(),
                  ),
                ],

                // Recruitment Dashboard Section
        if (controller.isHrManager.value == true) ...[
                _buildDashboardSection(
                  index: 1,
                  title: 'Recruitment Dashboard',
                  icon: Icons.person_add,
                  color: Colors.green,
                  expandedDashboard: expandedDashboard,
                  content: _buildRecruitmentDashboardContent(),
                ),
],

        if (controller.isHrManager.value == true) ...[
                // Employee Lifecycle Dashboard Section
                _buildDashboardSection(
                  index: 2,
                  title: 'Employee Lifecycle Dashboard',
                  icon: Icons.timeline,
                  color: Colors.blue,
                  expandedDashboard: expandedDashboard,
                  content: _buildEmployeeLifecycleDashboardContent(),
                ),
],

        if (controller.isHrManager.value == true) ...[
                // Attendance Dashboard Section
                _buildDashboardSection(
                  index: 3,
                  title: 'Attendance Dashboard',
                  icon: Icons.access_time,
                  color: Colors.orange,
                  expandedDashboard: expandedDashboard,
                  content: AttendanceDashboardView(),
                ),
],
                // Expense Claims Dashboard Section

        if (controller.isHrManager.value == true) ...[
                _buildDashboardSection(index: 4,
                  title: 'Expense Claims Dashboard',
                  icon: Icons.receipt,
                  color: Colors.purple,
                  expandedDashboard: expandedDashboard,
                  content: _buildExpenseClaimsDashboardContent(),
                ),],



                  _checkInButton(),
                _leaveApplicationButton(),





              ],
            ),
          ),
        );
      },
    );
  }


  Widget _leaveApplicationButton(){
    return
      Container(
        width: double.infinity,
        height: 55,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Get.toNamed(Routes.LEAVE_APPLICATION);
            // Get.to(() => EmployeeCheckinView());
          },
          child: const Text(
            'Leave Application',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
  }


  Widget _checkInButton(){
    return
      Container(
        width: double.infinity,
        height: 55,
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Get.toNamed(Routes.EMPLOYEE_CHECKIN);
            // Get.to(() => EmployeeCheckinView());
          },
          child: const Text(
            'Employee Checkin',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
  }

  // Build individual dashboard section with accordion behavior
  Widget _buildDashboardSection({
    required int index,
    required String title,
    required IconData icon,
    required MaterialColor color,
    required RxInt expandedDashboard,
    required Widget content,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Dashboard Header Button
          Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (expandedDashboard.value == index) {
                  expandedDashboard.value = -1; // Collapse if already expanded
                } else {
                  expandedDashboard.value = index; // Expand this dashboard
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [color.shade600, color.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),
                    Obx(
                      () => AnimatedRotation(
                        turns: expandedDashboard.value == index ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(
                          Icons.expand_more,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expandable Content
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: expandedDashboard.value == index ? null : 0,
              child: expandedDashboard.value == index
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        border: Border.all(color: color.shade200, width: 2),
                      ),
                      child: content,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  // HR Dashboard Content
  Widget _buildHRDashboardContent() {
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
                  child: Container(), // Empty space to maintain layout
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Third Row - Quarterly Stats
            Row(
              children: [
                Expanded(
                  child: _buildDashboardCard(
                    title: 'EMPLOYEES JOINING (THIS QUARTER)',
                    value: controller.employeesJoiningThisQuarter.value
                        .toString(),
                    subtitle: '0 % since last quarter',
                    subtitleColor: Colors.grey.shade700,
                    icon: Icons.trending_up,
                    iconColor: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDashboardCard(
                    title: 'EMPLOYEES RELIEVING (THIS QUARTER)',
                    value: controller.employeesRelievingThisQuarter.value
                        .toString(),
                    subtitle: '0 % since last quarter',
                    subtitleColor: Colors.grey.shade700,
                    icon: Icons.trending_down,
                    iconColor: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Hiring vs Attrition Count (Line Chart)
            _buildChartCard(
              title: 'Hiring vs Attrition Count',
              subtitle: 'Last synced 6 hours ago',
              child: SizedBox(
                height: 250,
                child: SfCartesianChart(
                  onSelectionChanged: (SelectionArgs args) {
                    if (args.seriesIndex != null && args.pointIndex != null) {
                      final seriesData = args.seriesIndex == 0
                          ? controller.hiringAttritionData
                                .where((data) => data.type == "Hiring Count")
                                .toList()
                          : controller.hiringAttritionData
                                .where((data) => data.type == "Attrition Count")
                                .toList();

                      if (args.pointIndex! < seriesData.length) {
                        final selectedData = seriesData[args.pointIndex!];
                        _showValueTooltip(
                          Get.context!,
                          selectedData.type,
                          selectedData.value.toDouble(),
                        );
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
                    maximum: 5,
                    interval: 1,
                  ),
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    alignment: ChartAlignment.center,
                  ),
                  series: <CartesianSeries>[
                    LineSeries<HiringAttritionData, String>(
                      dataSource: controller.hiringAttritionData
                          .where((data) => data.type == "Hiring Count")
                          .toList(),
                      xValueMapper: (data, _) => data.month,
                      yValueMapper: (data, _) => data.value,
                      name: "Hiring Count",
                      color: const Color(0xFF2196F3),
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                      ),
                    ),
                    LineSeries<HiringAttritionData, String>(
                      dataSource: controller.hiringAttritionData
                          .where((data) => data.type == "Attrition Count")
                          .toList(),
                      xValueMapper: (data, _) => data.month,
                      yValueMapper: (data, _) => data.value,
                      name: "Attrition Count",
                      color: const Color(0xFF9C27B0),
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

            // Employees by Age (Bar Chart)
            _buildChartCard(
              title: 'Employees by Age',
              subtitle: 'Last synced 6 hours ago',
              child: SizedBox(
                height: 250,
                child: SfCartesianChart(
                  onSelectionChanged: (SelectionArgs args) {
                    if (args.pointIndex != null &&
                        args.pointIndex! <
                            controller.employeesByAgeData.length) {
                      final selectedData =
                          controller.employeesByAgeData[args.pointIndex!];
                      _showValueTooltip(
                        Get.context!,
                        selectedData.ageGroup,
                        selectedData.count.toDouble(),
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
                    maximum: 6,
                    interval: 1,
                  ),
                  series: <CartesianSeries>[
                    ColumnSeries<EmployeeAgeData, String>(
                      dataSource: controller.employeesByAgeData,
                      xValueMapper: (data, _) => data.ageGroup,
                      yValueMapper: (data, _) => data.count,
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

            // Column layout for Gender Diversity and Employee Type
            Column(
              children: [
                _buildChartCard(
                  title: 'Gender Diversity Ratio',
                  subtitle: 'Last synced 6 hours ago',
                  child: SizedBox(
                    height: 250,
                    child: SfCircularChart(
                      onSelectionChanged: (SelectionArgs args) {
                        if (args.pointIndex != null &&
                            args.pointIndex! < controller.genderData.length) {
                          final selectedData =
                              controller.genderData[args.pointIndex!];
                          _showValueTooltip(
                            Get.context!,
                            selectedData.gender,
                            selectedData.count.toDouble(),
                          );
                        }
                      },
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      series: <CircularSeries>[
                        PieSeries<GenderData, String>(
                          dataSource: controller.genderData,
                          xValueMapper: (data, _) => data.gender,
                          yValueMapper: (data, _) => data.count,
                          dataLabelMapper: (data, _) => '${data.count}',
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            unselectedOpacity: 0.5,
                          ),
                          pointColorMapper: (data, index) {
                            return data.gender == 'Male'
                                ? const Color(0xFF2196F3)
                                : const Color(0xFFE91E63);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChartCard(
                  title: 'Employees by Type',
                  subtitle: 'Last synced 6 hours ago',
                  child: SizedBox(
                    height: 250,
                    child: SfCircularChart(
                      onSelectionChanged: (SelectionArgs args) {
                        if (args.pointIndex != null &&
                            args.pointIndex! <
                                controller.employeeTypeData.length) {
                          final selectedData =
                              controller.employeeTypeData[args.pointIndex!];
                          _showValueTooltip(
                            Get.context!,
                            selectedData.type,
                            selectedData.count.toDouble(),
                          );
                        }
                      },
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      series: <CircularSeries>[
                        PieSeries<EmployeeTypeData, String>(
                          dataSource: controller.employeeTypeData,
                          xValueMapper: (data, _) => data.type,
                          yValueMapper: (data, _) => data.count,
                          dataLabelMapper: (data, _) => '${data.count}',
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            unselectedOpacity: 0.5,
                          ),
                          pointColorMapper: (data, index) {
                            return const Color(0xFF2196F3);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Column layout for Grade and Branch
            Column(
              children: [
                _buildChartCard(
                  title: 'Employees by Grade',
                  subtitle: 'Last synced 6 hours ago',
                  child: SizedBox(
                    height: 250,
                    child: SfCircularChart(
                      onSelectionChanged: (SelectionArgs args) {
                        if (args.pointIndex != null &&
                            args.pointIndex! < controller.gradeData.length) {
                          final selectedData =
                              controller.gradeData[args.pointIndex!];
                          _showValueTooltip(
                            Get.context!,
                            selectedData.grade,
                            selectedData.count.toDouble(),
                          );
                        }
                      },
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      series: <CircularSeries>[
                        PieSeries<GradeData, String>(
                          dataSource: controller.gradeData,
                          xValueMapper: (data, _) => data.grade,
                          yValueMapper: (data, _) => data.count,
                          dataLabelMapper: (data, _) => '${data.count}',
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            unselectedOpacity: 0.5,
                          ),
                          pointColorMapper: (data, index) {
                            return const Color(0xFF2196F3);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChartCard(
                  title: 'Employees by Branch',
                  subtitle: 'Last synced 6 hours ago',
                  child: SizedBox(
                    height: 250,
                    child: SfCircularChart(
                      onSelectionChanged: (SelectionArgs args) {
                        if (args.pointIndex != null &&
                            args.pointIndex! < controller.branchData.length) {
                          final selectedData =
                              controller.branchData[args.pointIndex!];
                          _showValueTooltip(
                            Get.context!,
                            selectedData.branch,
                            selectedData.count.toDouble(),
                          );
                        }
                      },
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                      series: <CircularSeries>[
                        PieSeries<BranchData, String>(
                          dataSource: controller.branchData,
                          xValueMapper: (data, _) => data.branch,
                          yValueMapper: (data, _) => data.count,
                          dataLabelMapper: (data, _) => '${data.count}',
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            unselectedOpacity: 0.5,
                          ),
                          pointColorMapper: (data, index) {
                            final colors = [
                              const Color(0xFF2196F3),
                              const Color(0xFFE91E63),
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

            const SizedBox(height: 20),

            // Column layout for Designation and Department
            Column(
              children: [
                _buildChartCard(
                  title: 'Designation Wise Employee Count',
                  subtitle: 'Last synced 6 hours ago',
                  child: SizedBox(
                    height: 250,
                    child: SfCircularChart(
                      onSelectionChanged: (SelectionArgs args) {
                        if (args.pointIndex != null &&
                            args.pointIndex! <
                                controller.designationChartData.length) {
                          final selectedData =
                              controller.designationChartData[args.pointIndex!];
                          _showValueTooltip(
                            Get.context!,
                            selectedData.designation,
                            selectedData.count.toDouble(),
                          );
                        }
                      },
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                      series: <CircularSeries>[
                        PieSeries<DesignationChartData, String>(
                          dataSource: controller.designationChartData,
                          xValueMapper: (data, _) => data.designation,
                          yValueMapper: (data, _) => data.count,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: false,
                          ),
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            unselectedOpacity: 0.5,
                          ),
                          pointColorMapper: (data, index) {
                            final colors = [
                              const Color(0xFF2196F3),
                              const Color(0xFFE91E63),
                              const Color(0xFF4CAF50),
                            ];
                            return colors[index! % colors.length];
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _buildChartCard(
                  title: 'Department Wise Employee Count',
                  subtitle: 'Last synced 6 hours ago',
                  child: SizedBox(
                    height: 250,
                    child: SfCircularChart(
                      onSelectionChanged: (SelectionArgs args) {
                        if (args.pointIndex != null &&
                            args.pointIndex! <
                                controller.departmentChartData.length) {
                          final selectedData =
                              controller.departmentChartData[args.pointIndex!];
                          _showValueTooltip(
                            Get.context!,
                            selectedData.department,
                            selectedData.count.toDouble(),
                          );
                        }
                      },
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                      series: <CircularSeries>[
                        PieSeries<DepartmentChartData, String>(
                          dataSource: controller.departmentChartData,
                          xValueMapper: (data, _) => data.department,
                          yValueMapper: (data, _) => data.count,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: false,
                          ),
                          selectionBehavior: SelectionBehavior(
                            enable: true,
                            unselectedOpacity: 0.5,
                          ),
                          pointColorMapper: (data, index) {
                            return const Color(0xFF2196F3);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // Recruitment Dashboard Content (Placeholder)

  // Recruitment Dashboard Content
  Widget _buildRecruitmentDashboardContent() {
    final RecruitmentDashboardController controller = Get.put(
      RecruitmentDashboardController(),
    );

    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerPlaceholder();
      }

      return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recruitment Dashboard',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // First Row - Job Openings, Total Applicants, Accepted, Rejected
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      title: 'JOB OPENINGS',
                      value: controller.totalJobOpenings.value.toString(),
                      subtitle: 'Active positions',
                      subtitleColor: Colors.grey.shade600,
                      icon: Icons.work,
                      iconColor: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      title: 'TOTAL APPLICANTS THIS MONTH',
                      value: controller.totalApplicantsThisMonth.value
                          .toString(),
                      subtitle: 'New applications',
                      subtitleColor: Colors.blue.shade600,
                      icon: Icons.people,
                      iconColor: Colors.green.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Second Row - Accepted and Rejected
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      title: 'ACCEPTED JOB APPLICANTS',
                      value: controller.acceptedJobApplicants.value.toString(),
                      subtitle: 'Successful candidates',
                      subtitleColor: Colors.green.shade600,
                      icon: Icons.check_circle,
                      iconColor: Colors.green.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      title: 'REJECTED JOB APPLICANTS',
                      value: controller.rejectedJobApplicants.value.toString(),
                      subtitle: 'Not selected',
                      subtitleColor: Colors.red.shade600,
                      icon: Icons.cancel,
                      iconColor: Colors.red.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Third Row - Job Offers and New Candidates
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      title: 'JOB OFFER THIS MONTH',
                      value: controller.jobOfferThisMonth.value.toString(),
                      subtitle: 'Offers extended',
                      subtitleColor: Colors.grey.shade700,
                      icon: Icons.local_offer,
                      iconColor: Colors.orange.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      title: 'NEW CANDIDATE ADDED THIS MONTH',
                      value: controller.newCandidateAddedThisMonth.value
                          .toString(),
                      subtitle: 'Fresh candidates',
                      subtitleColor: Colors.grey.shade700,
                      icon: Icons.person_add,
                      iconColor: Colors.purple.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Fourth Row - Job Offer Acceptance Rate and Time to Fill
              Row(
                children: [
                  Expanded(
                    child: _buildDashboardCard(
                      title: 'JOB OFFER ACCEPTANCE RATE',
                      value: '${controller.jobOfferAcceptanceRate.value}%',
                      subtitle: 'Acceptance ratio',
                      subtitleColor: Colors.grey.shade700,
                      icon: Icons.trending_up,
                      iconColor: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDashboardCard(
                      title: 'TIME TO FILL',
                      value: '${controller.timeToFill.value}d',
                      subtitle: 'Average days',
                      subtitleColor: Colors.grey.shade700,
                      icon: Icons.access_time,
                      iconColor: Colors.teal.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Job Applicant Pipeline Chart
              _buildChartCard(
                title: 'Job Applicant Pipeline',
                subtitle: 'Last synced 6 hours ago',
                child: SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    enableAxisAnimation: true,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}',
                      majorGridLines: const MajorGridLines(width: 0.5),
                      minimum: 0,
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<JobApplicantPipelineData, String>(
                        dataSource: controller.jobApplicantPipelineData,
                        xValueMapper: (data, _) => data.jobTitle,
                        yValueMapper: (data, _) => data.count,
                        color: const Color(0xFF2196F3),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Job Applicant Source Chart
              _buildChartCard(
                title: 'Job Applicant Source',
                subtitle: 'Last synced 6 hours ago',
                child: SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    enableAxisAnimation: true,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}',
                      majorGridLines: const MajorGridLines(width: 0.5),
                      minimum: 0,
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<JobApplicantSourceData, String>(
                        dataSource: controller.jobApplicantSourceData,
                        xValueMapper: (data, _) => data.source,
                        yValueMapper: (data, _) => data.count,
                        color: const Color(0xFF4CAF50),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Row for Country and Application Status Charts
              // Column for Country and Application Status Charts
              Column(
                children: [
                  _buildChartCard(
                    title: 'Job Applicants by Country',
                    subtitle: 'Last synced 6 hours ago',
                    child: SizedBox(
                      height: 250,
                      child: SfCircularChart(
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        series: <CircularSeries>[
                          PieSeries<JobApplicantsByCountryData, String>(
                            dataSource: controller.jobApplicantsByCountryData,
                            xValueMapper: (data, _) => data.country,
                            yValueMapper: (data, _) => data.count,
                            dataLabelMapper: (data, _) => '${data.count}',
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                            ),
                            pointColorMapper: (data, index) {
                              return const Color(0xFF2196F3);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildChartCard(
                    title: 'Job Application Status',
                    subtitle: 'Last synced 6 hours ago',
                    child: SizedBox(
                      height: 250,
                      child: SfCircularChart(
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        series: <CircularSeries>[
                          PieSeries<JobApplicationStatusData, String>(
                            dataSource: controller.jobApplicationStatusData,
                            xValueMapper: (data, _) => data.status,
                            yValueMapper: (data, _) => data.count,
                            dataLabelMapper: (data, _) => '${data.count}',
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                            ),
                            pointColorMapper: (data, index) {
                              final colors = [
                                const Color(0xFF4CAF50), // Accepted - Green
                                const Color(0xFFE91E63), // Rejected - Pink
                                const Color(0xFF2196F3), // Open - Blue
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

              const SizedBox(height: 20),

              // Column for Job Offer Status and Interview Status
              Column(
                children: [
                  _buildChartCard(
                    title: 'Job Offer Status',
                    subtitle: 'Last synced 6 hours ago',
                    child: SizedBox(
                      height: 250,
                      child: SfCircularChart(
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        series: <CircularSeries>[
                          PieSeries<JobOfferStatusData, String>(
                            dataSource: controller.jobOfferStatusData,
                            xValueMapper: (data, _) => data.status,
                            yValueMapper: (data, _) => data.count,
                            dataLabelMapper: (data, _) => '${data.count}',
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                            ),
                            pointColorMapper: (data, index) {
                              return data.status == 'Accepted'
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFFE91E63);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildChartCard(
                    title: 'Interview Status',
                    subtitle: 'Last synced 6 hours ago',
                    child: SizedBox(
                      height: 250,
                      child: SfCircularChart(
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        series: <CircularSeries>[
                          PieSeries<InterviewStatusData, String>(
                            dataSource: controller.interviewStatusData,
                            xValueMapper: (data, _) => data.status,
                            yValueMapper: (data, _) => data.count,
                            dataLabelMapper: (data, _) => '${data.count}',
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                            ),
                            pointColorMapper: (data, index) {
                              return const Color(0xFF2196F3);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Job Application Frequency Line Chart
              _buildChartCard(
                title: 'Job Application Frequency',
                subtitle: 'Last synced 6 hours ago',
                child: SizedBox(
                  height: 250,
                  child: SfCartesianChart(
                    enableAxisAnimation: true,
                    primaryXAxis: CategoryAxis(
                      majorGridLines: const MajorGridLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      labelFormat: '{value}',
                      majorGridLines: const MajorGridLines(width: 0.5),
                      minimum: 0,
                    ),
                    series: <CartesianSeries>[
                      LineSeries<JobApplicationFrequencyData, String>(
                        dataSource: controller.jobApplicationFrequencyData,
                        xValueMapper: (data, _) => data.month,
                        yValueMapper: (data, _) => data.count,
                        color: const Color(0xFF2196F3),
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                        ),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  // Employee Lifecycle Dashboard Content (Placeholder)
  Widget _buildEmployeeLifecycleDashboardContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.timeline, size: 80, color: Colors.blue.shade300),
          const SizedBox(height: 16),
          Text(
            'Employee Lifecycle Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon!',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Text(
            'This dashboard will track employee journey from onboarding to exit, performance reviews, career progression, and retention analytics.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // Attendance Dashboard Content (Placeholder)
  Widget _buildAttendanceDashboardContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.access_time, size: 80, color: Colors.orange.shade300),
          const SizedBox(height: 16),
          Text(
            'Attendance Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon!',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Text(
            'This dashboard will display attendance patterns, leave management, work hours tracking, and punctuality reports.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // Expense Claims Dashboard Content (Placeholder)
  Widget _buildExpenseClaimsDashboardContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.receipt, size: 80, color: Colors.purple.shade300),
          const SizedBox(height: 16),
          Text(
            'Expense Claims Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon!',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          Text(
            'This dashboard will manage expense submissions, approval workflows, reimbursement tracking, and expense analytics.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
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
            _shimmerCard(height: 250),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _shimmerCard(height: 250)),
                const SizedBox(width: 12),
                Expanded(child: _shimmerCard(height: 250)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _shimmerCard(height: 250)),
                const SizedBox(width: 12),
                Expanded(child: _shimmerCard(height: 250)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _shimmerCard(height: 250)),
                const SizedBox(width: 12),
                Expanded(child: _shimmerCard(height: 250)),
              ],
            ),
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
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
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
