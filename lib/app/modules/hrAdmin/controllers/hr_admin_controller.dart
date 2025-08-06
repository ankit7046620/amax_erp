import 'package:amax_hr/app/modules/HrDashboar/controllers/hr_dashboar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HrAdminController extends GetxController {
  //TODO: Implement HrAdminController
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
  final List<String> cardTitles = [
    'Hr DashBoard',
    'Recruitment',
    'Attendance',
  ];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  final List<List<Map<String, dynamic>>> cardData = [
    // For "Employee Details"
    [
      {'title': 'Name', 'value': 'John', 'subtitle': 'Employee', 'icon': Icons.person, 'iconColor': Colors.teal},
      {'title': 'ID', 'value': 'EMP102', 'subtitle': 'Code', 'icon': Icons.badge, 'iconColor': Colors.blue},
      {'title': 'Age', 'value': '29', 'subtitle': 'Years', 'icon': Icons.cake, 'iconColor': Colors.orange},
      {'title': 'Dept.', 'value': 'IT', 'subtitle': 'Engineering', 'icon': Icons.business, 'iconColor': Colors.purple},
      {'title': 'Phone', 'value': '+91 99999', 'subtitle': 'Mobile', 'icon': Icons.phone, 'iconColor': Colors.green},
      {'title': 'Join Date', 'value': '2021-05-10', 'subtitle': 'Joining', 'icon': Icons.date_range, 'iconColor': Colors.red},
    ],
    // For "Attendance"
    [
      {'title': 'Present', 'value': '20', 'subtitle': 'Days', 'icon': Icons.check_circle, 'iconColor': Colors.green},
      {'title': 'Absent', 'value': '2', 'subtitle': 'Days', 'icon': Icons.cancel, 'iconColor': Colors.red},
      {'title': 'Late', 'value': '1', 'subtitle': 'Times', 'icon': Icons.access_time, 'iconColor': Colors.orange},
      {'title': 'WFH', 'value': '3', 'subtitle': 'Days', 'icon': Icons.home, 'iconColor': Colors.teal},
      {'title': 'Half Day', 'value': '0', 'subtitle': 'Days', 'icon': Icons.adjust, 'iconColor': Colors.purple},
      {'title': 'Leaves Used', 'value': '5', 'subtitle': 'Days', 'icon': Icons.time_to_leave, 'iconColor': Colors.blue},
    ],
    // For "Leave Summary"
    [
      {'title': 'Annual', 'value': '15', 'subtitle': 'Total', 'icon': Icons.event_available, 'iconColor': Colors.green},
      {'title': 'Used', 'value': '5', 'subtitle': 'Days', 'icon': Icons.remove_circle, 'iconColor': Colors.red},
      {'title': 'Balance', 'value': '10', 'subtitle': 'Days Left', 'icon': Icons.account_balance_wallet, 'iconColor': Colors.orange},
      {'title': 'Sick', 'value': '2', 'subtitle': 'Days', 'icon': Icons.healing, 'iconColor': Colors.pink},
      {'title': 'Casual', 'value': '3', 'subtitle': 'Days', 'icon': Icons.weekend, 'iconColor': Colors.blue},
      {'title': 'LOP', 'value': '0', 'subtitle': 'Loss of Pay', 'icon': Icons.money_off, 'iconColor': Colors.grey},
    ],
  ];
}
