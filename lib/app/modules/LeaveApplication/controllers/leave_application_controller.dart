// import 'package:amax_hr/manager/api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import your ApiService here
// // import 'your_api_service_path.dart';
//
// class LeaveApplication {
//   final String name;
//   final int docstatus;
//   final String employeeName;
//   final String employee;
//   final String fromDate;
//   final String toDate;
//   final String leaveType;
//   final String status;
//
//   LeaveApplication({
//     required this.name,
//     required this.docstatus,
//     required this.employeeName,
//     required this.employee,
//     required this.fromDate,
//     required this.toDate,
//     required this.leaveType,
//     required this.status,
//   });
//
//   factory LeaveApplication.fromJson(Map<String, dynamic> json) {
//     return LeaveApplication(
//       name: json['name'] ?? '',
//       docstatus: json['docstatus'] ?? 0,
//       employeeName: json['employee_name'] ?? '',
//       employee: json['employee'] ?? '',
//       fromDate: json['from_date'] ?? '',
//       toDate: json['to_date'] ?? '',
//       leaveType: json['leave_type'] ?? '',
//       status: json['status'] ?? '',
//     );
//   }
// }
//
// class LeaveApplicationController extends GetxController {
//   final RxList<LeaveApplication> leaveApplications = <LeaveApplication>[].obs;
//   final RxList<LeaveApplication> filteredApplications = <LeaveApplication>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxString selectedStatus = 'All'.obs;
//   final RxString searchQuery = ''.obs;
//   final RxString sortBy = 'Last Updated On'.obs;
//
//   final List<String> statusOptions = ['All', 'Open', 'Approved', 'Rejected', 'Cancelled'];
//   final List<String> sortOptions = ['Last Updated On', 'Employee Name', 'From Date', 'Status'];
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchLeaveApplications();
//   }
//
//   Future<void> fetchLeaveApplications() async {
//     try {
//       isLoading.value = true;
//
//       String endpoint = 'api/resource/Leave Application';
//       String fields = '["name","docstatus","employee_name","employee","from_date","to_date","leave_type","status"]';
//
//       final response = await ApiService.get(
//         endpoint,
//         params: {
//           'fields': fields,
//           'limit_page_length': '1000',
//         },
//       );
//
//       if (response != null && response.data != null) {
//         print('✅ Leave Applications API Response: ${response.data}');
//
//         // Cast the response to a Map
//         Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
//
//         // Extract the list safely
//         if (responseData['data'] != null) {
//           final List<dynamic> data = responseData['data'];
//           leaveApplications.value = data
//               .map((json) => LeaveApplication.fromJson(json))
//               .toList();
//
//           applyFilters();
//         }
//       } else {
//         Get.snackbar('Error', 'Failed to load leave applications');
//       }
//
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to fetch leave applications: $e',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void applyFilters() {
//     List<LeaveApplication> filtered = leaveApplications.toList();
//
//     // Apply status filter
//     if (selectedStatus.value != 'All') {
//       filtered = filtered.where((app) =>
//       app.status.toLowerCase() == selectedStatus.value.toLowerCase()
//       ).toList();
//     }
//
//     // Apply search filter
//     if (searchQuery.value.isNotEmpty) {
//       filtered = filtered.where((app) =>
//       app.employeeName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
//           app.employee.toLowerCase().contains(searchQuery.value.toLowerCase())
//       ).toList();
//     }
//
//     // Apply sorting
//     switch (sortBy.value) {
//       case 'Employee Name':
//         filtered.sort((a, b) => a.employeeName.compareTo(b.employeeName));
//         break;
//       case 'From Date':
//         filtered.sort((a, b) => b.fromDate.compareTo(a.fromDate));
//         break;
//       case 'Status':
//         filtered.sort((a, b) => a.status.compareTo(b.status));
//         break;
//       case 'Last Updated On':
//       default:
//       // Sort by name (ID) as a proxy for last updated
//         filtered.sort((a, b) => b.name.compareTo(a.name));
//         break;
//     }
//
//     filteredApplications.value = filtered;
//   }
//
//   void updateStatusFilter(String status) {
//     selectedStatus.value = status;
//     applyFilters();
//   }
//
//   void updateSearchQuery(String query) {
//     searchQuery.value = query;
//     applyFilters();
//   }
//
//   void updateSortBy(String sort) {
//     sortBy.value = sort;
//     applyFilters();
//   }
//
//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'approved':
//         return Colors.green;
//       case 'rejected':
//         return Colors.red;
//       case 'cancelled':
//         return Colors.red.shade400;
//       case 'open':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   String getTimeAgo(String dateString) {
//     try {
//       DateTime date = DateTime.parse(dateString);
//       DateTime now = DateTime.now();
//       Duration difference = now.difference(date);
//
//       if (difference.inDays > 0) {
//         if (difference.inDays >= 30) {
//           int months = (difference.inDays / 30).floor();
//           return '${months}M';
//         } else if (difference.inDays >= 7) {
//           int weeks = (difference.inDays / 7).floor();
//           return '${weeks}w';
//         } else {
//           return '${difference.inDays}d';
//         }
//       } else if (difference.inHours > 0) {
//         return '${difference.inHours}h';
//       } else {
//         return 'now';
//       }
//     } catch (e) {
//       return '';
//     }
//   }
//
//   void refreshData() {
//     fetchLeaveApplications();
//   }
// }

import 'package:amax_hr/manager/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import your ApiService here
// import 'your_api_service_path.dart';

class LeaveApplication {
  final String name;
  final int docstatus;
  final String employeeName;
  final String employee;
  final String fromDate;
  final String toDate;
  final String leaveType;
  final String status;
  final String? reason;
  final String? leaveApprover;
  final String? description;
  final int? halfDay;

  LeaveApplication({
    required this.name,
    required this.docstatus,
    required this.employeeName,
    required this.employee,
    required this.fromDate,
    required this.toDate,
    required this.leaveType,
    required this.status,
    this.reason,
    this.leaveApprover,
    this.description,
    this.halfDay,
  });

  factory LeaveApplication.fromJson(Map<String, dynamic> json) {
    return LeaveApplication(
      name: json['name'] ?? '',
      docstatus: json['docstatus'] ?? 0,
      employeeName: json['employee_name'] ?? '',
      employee: json['employee'] ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      leaveType: json['leave_type'] ?? '',
      status: json['status'] ?? '',
      reason: json['description'],
      leaveApprover: json['leave_approver'],
      description: json['description'],
      halfDay: json['half_day'] ?? 0,
    );
  }
}

class Employee {
  final String name;
  final String employee;
  final String employeeName;

  Employee({
    required this.name,
    required this.employee,
    required this.employeeName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'] ?? '',
      employee: json['employee'] ?? '',
      employeeName: json['employee_name'] ?? '',
    );
  }
}

class EmployeeListResponse {
  final List<Employee> data;

  EmployeeListResponse({required this.data});

  factory EmployeeListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Employee> employeeList = list.map((i) => Employee.fromJson(i)).toList();
    return EmployeeListResponse(data: employeeList);
  }
}

class LeaveApplicationController extends GetxController {
  final RxList<LeaveApplication> leaveApplications = <LeaveApplication>[].obs;
  final RxList<LeaveApplication> filteredApplications = <LeaveApplication>[]
      .obs;
  final RxBool isLoading = false.obs;
  final RxString selectedStatus = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'Last Updated On'.obs;

  // Employee related
  final RxList<Employee> employeeList = <Employee>[].obs;
  final RxBool isLoadingEmployees = false.obs;

  // Form controllers
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController leaveApproverController = TextEditingController();

  // Form state
  final RxString selectedEmployee = ''.obs;
  final RxString selectedLeaveType = ''.obs;
  final RxString selectedStatusForm = ''.obs;
  final RxBool isHalfDay = false.obs;
  final RxBool isSubmitting = false.obs;

  // Options
  final List<String> statusOptions = [
    'All',
    'Open',
    'Approved',
    'Rejected',
    'Cancelled'
  ];
  final List<String> sortOptions = [
    'Last Updated On',
    'Employee Name',
    'From Date',
    'Status'
  ];
  final RxList<String> leaveTypes = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLeaveApplications();
    fetchLeaveTypes();
  }

  @override
  void onClose() {
    fromDateController.dispose();
    toDateController.dispose();
    reasonController.dispose();
    leaveApproverController.dispose();
    super.onClose();
  }

  Future<void> fetchLeaveApplications() async {
    try {
      isLoading.value = true;

      String endpoint = 'api/resource/Leave Application';
      String fields = '["name","docstatus","employee_name","employee","from_date","to_date","leave_type","status","leave_approver","description"]';

      final response = await ApiService.get(
        endpoint,
        params: {
          'fields': fields,
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.data != null) {
        print('✅ Leave Applications API Response: ${response.data}');

        // Cast the response to a Map
        Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

        // Extract the list safely
        if (responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          leaveApplications.value = data
              .map((json) => LeaveApplication.fromJson(json))
              .toList();

          applyFilters();
        }
      } else {
        Get.snackbar('Error', 'Failed to load leave applications');
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch leave applications: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch employees list
  Future<void> fetchEmployees() async {
    try {
      isLoadingEmployees.value = true;

      String endpoint = 'api/resource/Employee';
      String fields = '["name","employee","employee_name"]';

      final response = await ApiService.get(
        endpoint,
        params: {
          'fields': fields,
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.data != null) {
        print('✅ Employees API Response: ${response.data}');

        Map<String, dynamic> responseData = response.data as Map<String,
            dynamic>;
        EmployeeListResponse employeeResponse = EmployeeListResponse.fromJson(
            responseData);
        employeeList.value = employeeResponse.data;

        print('✅ Parsed ${employeeList.length} employees');
      } else {
        Get.snackbar('Error', 'Failed to load employees');
      }
    } catch (e) {
      print('❌ Error fetching employees: $e');
      Get.snackbar('Error', 'Failed to load employees: ${e.toString()}');
    } finally {
      isLoadingEmployees.value = false;
    }
  }

  // Fetch leave types
  Future<void> fetchLeaveTypes() async {
    try {
      String endpoint = 'api/resource/Leave Type';
      String fields = '["name"]';

      final response = await ApiService.get(
        endpoint,
        params: {
          'fields': fields,
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.data != null) {
        Map<String, dynamic> responseData = response.data as Map<String,
            dynamic>;
        if (responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          leaveTypes.value =
              data.map((item) => item['name'].toString()).toList();
        }
      }
    } catch (e) {
      print('❌ Error fetching leave types: $e');
    }
  }

  // Add new leave application
  Future<void> addLeaveApplication() async {
    if (!_validateForm()) return;

    try {
      isSubmitting.value = true;

      String endpoint = 'api/resource/Leave Application';

      Map<String, dynamic> requestBody = {
        "employee": selectedEmployee.value,
        "from_date": fromDateController.text,
        "to_date": toDateController.text,
        "half_day": isHalfDay.value ? 1 : 0,
        "leave_type": selectedLeaveType.value,
        "description": reasonController.text,
        "leave_approver": leaveApproverController.text,
        "status": selectedStatusForm.value
      };

      final response = await ApiService.post(
        endpoint,
        data: requestBody,
      );

      if (response != null) {
        Get.snackbar(
          'Success',
          'Leave application submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.back(); // Close dialog
        fetchLeaveApplications(); // Refresh list
      } else {
        Get.snackbar('Error', 'Failed to submit leave application');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit leave application: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Update existing leave application
  Future<void> updateLeaveApplication(String leaveId) async {
    if (!_validateForm()) return;

    try {
      isSubmitting.value = true;

      String endpoint = 'api/resource/Leave Application/$leaveId';

      Map<String, dynamic> requestBody = {
        "employee": selectedEmployee.value,
        "from_date": fromDateController.text,
        "to_date": toDateController.text,
        "half_day": isHalfDay.value ? 1 : 0,
        "leave_type": selectedLeaveType.value,
        "description": reasonController.text,
        "leave_approver": leaveApproverController.text,
        "status": selectedStatusForm.value
      };

      final response = await ApiService.put(endpoint, data: requestBody,);

      if (response != null) {
        Get.snackbar(
          'Success',
          'Leave application updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.back(); // Close dialog
        fetchLeaveApplications(); // Refresh list
      } else {
        Get.snackbar('Error', 'Failed to update leave application');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update leave application: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Form validation
  bool _validateForm() {
    if (selectedEmployee.value.isEmpty) {
      Get.snackbar('Error', 'Please select an employee');
      return false;
    }

    if (selectedLeaveType.value.isEmpty) {
      Get.snackbar('Error', 'Please select leave type');
      return false;
    }

    if (fromDateController.text.isEmpty) {
      Get.snackbar('Error', 'Please select from date');
      return false;
    }

    if (toDateController.text.isEmpty) {
      Get.snackbar('Error', 'Please select to date');
      return false;
    }

    if (leaveApproverController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter leave approver email');
      return false;
    }

    return true;
  }

  // Date selection methods
  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      fromDateController.text =
      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day
          .toString().padLeft(2, '0')}";
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      toDateController.text =
      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day
          .toString().padLeft(2, '0')}";
    }
  }

  // Form management
  void clearForm() {
    selectedEmployee.value = '';
    selectedLeaveType.value = '';
    selectedStatusForm.value = 'Open';
    fromDateController.clear();
    toDateController.clear();
    reasonController.clear();
    leaveApproverController.clear();
    isHalfDay.value = false;
  }

  void populateFormForEdit(LeaveApplication application) {
    print("LeaveApprover:"+application.leaveApprover.toString());
    selectedEmployee.value = application.employee;
    selectedLeaveType.value = application.leaveType;
    selectedStatusForm.value = application.status;
    fromDateController.text = application.fromDate;
    toDateController.text = application.toDate;
    reasonController.text = application.reason ?? '';
    leaveApproverController.text = application.leaveApprover ?? '';
    isHalfDay.value = (application.halfDay ?? 0) == 1;
  }

  void applyFilters() {
    List<LeaveApplication> filtered = leaveApplications.toList();

    // Apply status filter
    if (selectedStatus.value != 'All') {
      filtered = filtered.where((app) =>
      app.status.toLowerCase() == selectedStatus.value.toLowerCase()
      ).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((app) =>
      app.employeeName.toLowerCase().contains(
          searchQuery.value.toLowerCase()) ||
          app.employee.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }

    // Apply sorting
    switch (sortBy.value) {
      case 'Employee Name':
        filtered.sort((a, b) => a.employeeName.compareTo(b.employeeName));
        break;
      case 'From Date':
        filtered.sort((a, b) => b.fromDate.compareTo(a.fromDate));
        break;
      case 'Status':
        filtered.sort((a, b) => a.status.compareTo(b.status));
        break;
      case 'Last Updated On':
      default:
      // Sort by name (ID) as a proxy for last updated
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    filteredApplications.value = filtered;
  }

  void updateStatusFilter(String status) {
    selectedStatus.value = status;
    applyFilters();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void updateSortBy(String sort) {
    sortBy.value = sort;
    applyFilters();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.red.shade400;
      case 'open':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String getTimeAgo(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      Duration difference = now.difference(date);

      if (difference.inDays > 0) {
        if (difference.inDays >= 30) {
          int months = (difference.inDays / 30).floor();
          return '${months}M';
        } else if (difference.inDays >= 7) {
          int weeks = (difference.inDays / 7).floor();
          return '${weeks}w';
        } else {
          return '${difference.inDays}d';
        }
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h';
      } else {
        return 'now';
      }
    } catch (e) {
      return '';
    }
  }

  void refreshData() {
    fetchLeaveApplications();
  }
}