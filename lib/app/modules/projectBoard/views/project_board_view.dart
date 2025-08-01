import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/project_board_controller.dart';

class ProjectBoardView extends StatelessWidget {
  const ProjectBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProjectBoardController());

    return Scaffold(
      appBar: CommonAppBar(imagePath: AssetsConstant.tech_logo, showBack: true),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Project Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildSummaryRow(controller),
              const SizedBox(height: 20),
              _buildBarChart(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryRow(ProjectBoardController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _summaryCard("Average Completion", "${controller.averageCompletion.toStringAsFixed(0)}%", Colors.red),
        _summaryCard("Total Tasks", "${controller.chartSummaryList.fold(0, (a, b) => a + b.totalTasks)}", Colors.blue),
        _summaryCard("Completed", "${controller.chartSummaryList.fold(0, (a, b) => a + b.completedTasks)}", Colors.green),
        _summaryCard("Overdue", "${controller.chartSummaryList.fold(0, (a, b) => a + b.overdueTasks)}", Colors.orange),
      ],
    );
  }

  Widget _summaryCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildBarChart(ProjectBoardController controller) {
    return SizedBox(
      height: 260,
      child: SfCartesianChart(
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: CategoryAxis(),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries>[
          ColumnSeries<ProjectSummary, String>(
            name: 'Overdue',
            color: Colors.redAccent,
            dataSource: controller.chartSummaryList,
            xValueMapper: (data, _) => data.projectName,
            yValueMapper: (data, _) => data.overdueTasks,
          ),
          ColumnSeries<ProjectSummary, String>(
            name: 'Completed',
            color: Colors.lightBlue,
            dataSource: controller.chartSummaryList,
            xValueMapper: (data, _) => data.projectName,
            yValueMapper: (data, _) => data.completedTasks,
          ),
          ColumnSeries<ProjectSummary, String>(
            name: 'Total Tasks',
            color: Colors.blueAccent,
            dataSource: controller.chartSummaryList,
            xValueMapper: (data, _) => data.projectName,
            yValueMapper: (data, _) => data.totalTasks,
          ),
        ],
      ),
    );
  }
}
