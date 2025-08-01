import 'dart:convert';
import 'package:amax_hr/constant/url.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/vo/project_vo.dart';
import 'package:amax_hr/vo/task_model.dart';
import 'package:get/get.dart';

class ProjectSummary {
  final String projectName;
  final int totalTasks;
  final int completedTasks;
  final int overdueTasks;

  ProjectSummary({
    required this.projectName,
    required this.totalTasks,
    required this.completedTasks,
    required this.overdueTasks,
  });
}

class ProjectBoardController extends GetxController {
  final isLoading = true.obs;
  List<ProjectModel> projectList = [];
  List<ProjectSummary> chartSummaryList = [];

  int totalProjects = 0;
  int completedProjects = 0;
  int openProjects = 0;
  int overdueProjects = 0;
  double averageCompletion = 0.0;

  @override
  void onReady() {
    super.onReady();
    fetchProjectData();
  }

  Future<void> fetchProjectData() async {
    try {
      isLoading.value = true;
      final response = await ApiService.get(
        ApiUri.getProject,
        params: {
          'fields': '[ "*"]',
          'limit_page_length': '1000',
          'filters': jsonEncode([
            ['company', '=', "Vasani Polymers"]
          ]),
        },
      );

      if (response != null && response.statusCode == 200) {
        final List rawProjects = response.data['data'] ?? [];
        projectList.clear();

        for (var proj in rawProjects) {
          final project = ProjectModel.fromJson(proj);
          final tasks = await fetchTasksForProject(project.name ?? '');
          project.taskList = tasks; // No late init error, since taskList is initialized
          projectList.add(project);
        }

        calculateProjectSummary();
        prepareChartData();
      } else {
        logger.e('❌ Failed to fetch projects');
      }
    } catch (e) {
      logger.e("❌ Error fetching projects: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<TaskModel>> fetchTasksForProject(String projectName) async {
    try {
      final response = await ApiService.get(
        '/api/resource/Task',
        params: {
          'fields': '[ "*"]',
          'filters': jsonEncode([
            ['project', '=', projectName]
          ]),
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((e) => TaskModel.fromJson(e)).toList();
      }
    } catch (e) {
      logger.e("❌ Error fetching tasks for $projectName: $e");
    }
    return [];
  }

  void calculateProjectSummary() {
    totalProjects = projectList.length;
    completedProjects = 0;
    openProjects = 0;
    overdueProjects = 0;
    double totalCompletion = 0.0;
    final now = DateTime.now();

    for (var project in projectList) {
      final status = (project.status ?? '').toLowerCase();
      final percentComplete = (project.percentComplete ?? 0).toDouble();
      final expectedEndDateStr = project.expectedEndDate;

      if (status == 'completed') {
        completedProjects++;
      } else if (status == 'open') {
        openProjects++;
      }

      if (status != 'completed' &&
          expectedEndDateStr != null &&
          expectedEndDateStr.isNotEmpty) {
        final expectedEndDate = DateTime.tryParse(expectedEndDateStr);
        if (expectedEndDate != null && expectedEndDate.isBefore(now)) {
          overdueProjects++;
        }
      }

      totalCompletion += percentComplete;
    }

    averageCompletion = totalProjects > 0 ? totalCompletion / totalProjects : 0;
  }

  void prepareChartData() {
    chartSummaryList.clear();
    for (var project in projectList) {
      final tasks = project.taskList;
      final completed = tasks.where((t) => t.status.toLowerCase() == 'completed').length;
      final overdue = tasks.where((t) {
        final due = DateTime.tryParse(t.creation ?? '');
        return due != null && due.isBefore(DateTime.now()) && t.status.toLowerCase() != 'completed';
      }).length;

      chartSummaryList.add(ProjectSummary(
        projectName: project.name ?? '',
        totalTasks: tasks.length,
        completedTasks: completed,
        overdueTasks: overdue,
      ));
    }
  }
}
