import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HrDashboarController extends GetxController {
  // Observable variables for dashboard stats
  var isLoading = true.obs;
  var totalEmployees = 0.obs;
  var newHiresThisYear = 0.obs;
  var employeeExitsThisYear = 0.obs;
  var employeesJoiningThisQuarter = 0.obs;
  var employeesRelievingThisQuarter = 0.obs;

  // Chart data
  var employeeAnalyticsData = <EmployeeAnalyticsData>[].obs;
  var departmentChartData = <DepartmentChartData>[].obs;
  var designationChartData = <DesignationChartData>[].obs;

  final String apiUrl = 'https://plastic.techcloudamax.ai/api/resource/Employee?limit_page_length=1000&fields=[%22*%22]';
  final String cookie = 'sid=3d1a53c2caf7cfdc889e2f47e0bbcc81fe3454835c7386a2995c8860; full_name=Vignesh; sid=3d1a53c2caf7cfdc889e2f47e0bbcc81fe3454835c7386a2995c8860; system_user=yes; user_id=vignesh%40amaxconsultancyservices.com; user_image=';

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeData();
  }

  Future<void> fetchEmployeeData() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Cookie': cookie,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> employees = data['data'] ?? [];

        // Filter employees by company "Amax Consultancy Services (Demo)"
        final companyEmployees = employees.where((employee) =>
        employee['company'] == 'Amax Consultancy Services (Demo)').toList();

        processEmployeeData(companyEmployees);
      } else {
        Get.snackbar('Error', 'Failed to fetch employee data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void processEmployeeData(List<dynamic> employees) {
    // Calculate basic stats
    totalEmployees.value = employees.length;

    final currentYear = DateTime.now().year;
    final currentQuarter = ((DateTime.now().month - 1) ~/ 3) + 1;

    // Calculate new hires this year
    newHiresThisYear.value = employees.where((emp) {
      if (emp['date_of_joining'] != null) {
        try {
          final joinDate = DateTime.parse(emp['date_of_joining']);
          return joinDate.year == currentYear;
        } catch (e) {
          return false;
        }
      }
      return false;
    }).length;

    // Calculate exits this year (assuming relieving_date field exists)
    employeeExitsThisYear.value = employees.where((emp) {
      if (emp['relieving_date'] != null) {
        try {
          final relievingDate = DateTime.parse(emp['relieving_date']);
          return relievingDate.year == currentYear;
        } catch (e) {
          return false;
        }
      }
      return false;
    }).length;

    // Calculate quarterly stats
    employeesJoiningThisQuarter.value = employees.where((emp) {
      if (emp['date_of_joining'] != null) {
        try {
          final joinDate = DateTime.parse(emp['date_of_joining']);
          final joinQuarter = ((joinDate.month - 1) ~/ 3) + 1;
          return joinDate.year == currentYear && joinQuarter == currentQuarter;
        } catch (e) {
          return false;
        }
      }
      return false;
    }).length;

    employeesRelievingThisQuarter.value = employees.where((emp) {
      if (emp['relieving_date'] != null) {
        try {
          final relievingDate = DateTime.parse(emp['relieving_date']);
          final relievingQuarter = ((relievingDate.month - 1) ~/ 3) + 1;
          return relievingDate.year == currentYear && relievingQuarter == relievingQuarter;
        } catch (e) {
          return false;
        }
      }
      return false;
    }).length;

    // Process chart data
    processEmployeeAnalyticsData(employees);
    processDepartmentChartData(employees);
    processDesignationChartData(employees);
  }

  void processEmployeeAnalyticsData(List<dynamic> employees) {
    // Create monthly analytics data for current year
    final currentYear = DateTime.now().year;
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    List<EmployeeAnalyticsData> analyticsData = [];

    for (int i = 0; i < 12; i++) {
      final month = months[i];
      final monthNumber = i + 1;

      // Count new hires for this month
      final newHires = employees.where((emp) {
        if (emp['date_of_joining'] != null) {
          try {
            final joinDate = DateTime.parse(emp['date_of_joining']);
            return joinDate.year == currentYear && joinDate.month == monthNumber;
          } catch (e) {
            return false;
          }
        }
        return false;
      }).length;

      // Count exits for this month
      final exits = employees.where((emp) {
        if (emp['relieving_date'] != null) {
          try {
            final relievingDate = DateTime.parse(emp['relieving_date']);
            return relievingDate.year == currentYear && relievingDate.month == monthNumber;
          } catch (e) {
            return false;
          }
        }
        return false;
      }).length;

      analyticsData.add(EmployeeAnalyticsData(month, newHires, "New Hires"));
      analyticsData.add(EmployeeAnalyticsData(month, exits, "Exits"));
    }

    employeeAnalyticsData.value = analyticsData;
  }

  void processDepartmentChartData(List<dynamic> employees) {
    Map<String, int> departmentCounts = {};

    for (var employee in employees) {
      final department = employee['department'] ?? 'Unknown';
      departmentCounts[department] = (departmentCounts[department] ?? 0) + 1;
    }

    departmentChartData.value = departmentCounts.entries
        .map((e) => DepartmentChartData(e.key, e.value))
        .toList();
  }

  void processDesignationChartData(List<dynamic> employees) {
    Map<String, int> designationCounts = {};

    for (var employee in employees) {
      final designation = employee['designation'] ?? 'Unknown';
      designationCounts[designation] = (designationCounts[designation] ?? 0) + 1;
    }

    designationChartData.value = designationCounts.entries
        .map((e) => DesignationChartData(e.key, e.value))
        .toList();
  }

  Future<void> refreshData() async {
    await fetchEmployeeData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

// Data models for charts
class EmployeeAnalyticsData {
  final String month;
  final int value;
  final String type;

  EmployeeAnalyticsData(this.month, this.value, this.type);
}

class DepartmentChartData {
  final String department;
  final int count;

  DepartmentChartData(this.department, this.count);
}

class DesignationChartData {
  final String designation;
  final int count;

  DesignationChartData(this.designation, this.count);
}