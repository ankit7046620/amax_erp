import 'package:amax_hr/app/modules/hrAdmin/views/hr_admin_view.dart';
import 'package:amax_hr/app/modules/hrReqirement/views/hr_reqirement_view.dart';
import 'package:amax_hr/app/modules/hrSetting/views/hr_setting_view.dart';
import 'package:amax_hr/constant/url.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/utils/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HrDashboarController extends GetxController {
  // Observable variables for dashboard stats
  var isLoading = true.obs;
  var totalEmployees = 0.obs;
  var newHiresThisYear = 0.obs;
  var employeeExitsThisYear = 0.obs;
  var employeesJoiningThisQuarter = 0.obs;
  var employeesRelievingThisQuarter = 0.obs;

  // Chart data
  var hiringAttritionData = <HiringAttritionData>[].obs;
  var employeesByAgeData = <EmployeeAgeData>[].obs;
  var genderData = <GenderData>[].obs;
  var employeeTypeData = <EmployeeTypeData>[].obs;
  var gradeData = <GradeData>[].obs;
  var branchData = <BranchData>[].obs;
  var departmentChartData = <DepartmentChartData>[].obs;
  var designationChartData = <DesignationChartData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeData();
  }

  Future<void> fetchEmployeeData() async {
    try {
      isLoading.value = true;

      final response = await ApiService.get(
        ApiUri.getEmployee,
        params: {'fields': '["*"]', 'limit_page_length': '1000'},
      );

      if (response != null && response.statusCode == 200) {
        final List<dynamic> employees = response.data['data'] ?? [];

        // ✅ Optional: Use globalCompanyName instead of hardcoded value
        final companyEmployees = employees
            .where((employee) => employee['company'] == globalCompanyName)
            .toList();
        processEmployeeData(companyEmployees);

        // ✅ Do something with companyEmployees
        print(
          '✅ Found ${companyEmployees.length} employees for $globalCompanyName',
        );

        // You can store them in a list if needed
        // this.employeeList = companyEmployees.map((e) => EmployeeModel.fromJson(e)).toList();
      } else {
        print('❌ Failed to fetch employees');
      }
    } catch (e) {
      print("❌ Error fetching employees: $e");
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
          return relievingDate.year == currentYear &&
              relievingQuarter == currentQuarter;
        } catch (e) {
          return false;
        }
      }
      return false;
    }).length;

    // Process all chart data
    processHiringAttritionData(employees);
    processEmployeesByAgeData(employees);
    processGenderData(employees);
    processEmployeeTypeData(employees);
    processGradeData(employees);
    processBranchData(employees);
    processDepartmentChartData(employees);
    processDesignationChartData(employees);
  }

  void processHiringAttritionData(List<dynamic> employees) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    List<HiringAttritionData> data = [];

    for (String month in months) {
      // For demo purposes, using sample data
      // You can replace this with actual calculations based on your data
      final hiringCount = (employees.length * 0.1)
          .round(); // Sample calculation
      final attritionCount = (employees.length * 0.05)
          .round(); // Sample calculation

      data.add(HiringAttritionData(month, hiringCount, "Hiring Count"));
      data.add(HiringAttritionData(month, attritionCount, "Attrition Count"));
    }

    hiringAttritionData.value = data;
  }

  void processEmployeesByAgeData(List<dynamic> employees) {
    final Map<String, int> ageCounts = {
      '18-19': 0,
      '20-24': 0,
      '25-29': 0,
      '30-34': 0,
      '35-39': 0,
      '40-44': 0,
      '45-49': 0,
      '50-54': 0,
      '55-59': 0,
      '60-64': 0,
      '65-69': 0,
      '70-74': 0,
      '75-79': 0,
      '80+': 0,
    };

    final now = DateTime.now();

    for (var employee in employees) {
      final dob = employee['date_of_birth'];
      if (dob == null) continue;

      try {
        final birthDate = DateTime.parse(dob);
        int age = now.year - birthDate.year;
        if (birthDate.month > now.month ||
            (birthDate.month == now.month && birthDate.day > now.day)) {
          age--; // Adjust if birthday hasn't occurred yet this year
        }

        switch (age) {
          case >= 18 && <= 19:
            ageCounts['18-19'] = ageCounts['18-19']! + 1;
            break;
          case >= 20 && <= 24:
            ageCounts['20-24'] = ageCounts['20-24']! + 1;
            break;
          case >= 25 && <= 29:
            ageCounts['25-29'] = ageCounts['25-29']! + 1;
            break;
          case >= 30 && <= 34:
            ageCounts['30-34'] = ageCounts['30-34']! + 1;
            break;
          case >= 35 && <= 39:
            ageCounts['35-39'] = ageCounts['35-39']! + 1;
            break;
          case >= 40 && <= 44:
            ageCounts['40-44'] = ageCounts['40-44']! + 1;
            break;
          case >= 45 && <= 49:
            ageCounts['45-49'] = ageCounts['45-49']! + 1;
            break;
          case >= 50 && <= 54:
            ageCounts['50-54'] = ageCounts['50-54']! + 1;
            break;
          case >= 55 && <= 59:
            ageCounts['55-59'] = ageCounts['55-59']! + 1;
            break;
          case >= 60 && <= 64:
            ageCounts['60-64'] = ageCounts['60-64']! + 1;
            break;
          case >= 65 && <= 69:
            ageCounts['65-69'] = ageCounts['65-69']! + 1;
            break;
          case >= 70 && <= 74:
            ageCounts['70-74'] = ageCounts['70-74']! + 1;
            break;
          case >= 75 && <= 79:
            ageCounts['75-79'] = ageCounts['75-79']! + 1;
            break;
          case >= 80:
            ageCounts['80+'] = ageCounts['80+']! + 1;
            break;
        }
      } catch (_) {
        // skip invalid date
      }
    }

    employeesByAgeData.value = ageCounts.entries
        .where((entry) => entry.value > 0)
        .map((e) => EmployeeAgeData(e.key, e.value))
        .toList();
  }

  void processGenderData(List<dynamic> employees) {
    Map<String, int> genderCounts = {'Male': 0, 'Female': 0};

    for (var employee in employees) {
      final gender = employee['gender'] ?? 'Unknown';
      if (gender == 'Male' || gender == 'Female') {
        genderCounts[gender] = (genderCounts[gender] ?? 0) + 1;
      }
    }

    genderData.value = genderCounts.entries
        .where((entry) => entry.value > 0)
        .map((e) => GenderData(e.key, e.value))
        .toList();
  }

  void processEmployeeTypeData(List<dynamic> employees) {
    Map<String, int> typeCounts = {};

    for (var employee in employees) {
      final employeeType =
          employee['employment_type'] ?? 'Full-time'; // Default to Full-time
      typeCounts[employeeType] = (typeCounts[employeeType] ?? 0) + 1;
    }

    employeeTypeData.value = typeCounts.entries
        .map((e) => EmployeeTypeData(e.key, e.value))
        .toList();
  }

  void processGradeData(List<dynamic> employees) {
    Map<String, int> gradeCounts = {};

    for (var employee in employees) {
      final grade = employee['grade'] ?? 'Ungraded';
      gradeCounts[grade] = (gradeCounts[grade] ?? 0) + 1;
    }

    gradeData.value = gradeCounts.entries
        .map((e) => GradeData(e.key, e.value))
        .toList();
  }

  void processBranchData(List<dynamic> employees) {
    Map<String, int> branchCounts = {};

    for (var employee in employees) {
      final branch = employee['branch'] ?? 'Main Office';
      branchCounts[branch] = (branchCounts[branch] ?? 0) + 1;
    }

    branchData.value = branchCounts.entries
        .map((e) => BranchData(e.key, e.value))
        .toList();
  }

  void processDepartmentChartData(List<dynamic> employees) {
    Map<String, int> departmentCounts = {};

    for (var employee in employees) {
      final department = employee['department'] ?? 'General';
      departmentCounts[department] = (departmentCounts[department] ?? 0) + 1;
    }

    departmentChartData.value = departmentCounts.entries
        .map((e) => DepartmentChartData(e.key, e.value))
        .toList();
  }

  void processDesignationChartData(List<dynamic> employees) {
    Map<String, int> designationCounts = {};

    for (var employee in employees) {
      final designation = employee['designation'] ?? 'Employee';
      designationCounts[designation] =
          (designationCounts[designation] ?? 0) + 1;
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

List<Widget> pages = [HrReqirementView(),HrAdminView(),HrSettingView()];

// Data models for charts
class HiringAttritionData {
  final String month;
  final int value;
  final String type;

  HiringAttritionData(this.month, this.value, this.type);
}

class EmployeeAgeData {
  final String ageGroup;
  final int count;

  EmployeeAgeData(this.ageGroup, this.count);
}

class GenderData {
  final String gender;
  final int count;

  GenderData(this.gender, this.count);
}

class EmployeeTypeData {
  final String type;
  final int count;

  EmployeeTypeData(this.type, this.count);
}

class GradeData {
  final String grade;
  final int count;

  GradeData(this.grade, this.count);
}

class BranchData {
  final String branch;
  final int count;

  BranchData(this.branch, this.count);
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
