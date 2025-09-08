// import 'package:amax_hr/manager/api_service.dart';
// import 'package:amax_hr/vo/AttendanceModel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AttendanceFormController extends GetxController {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   // Text Controllers
//   final TextEditingController attendanceDateController = TextEditingController();
//   final TextEditingController companyController = TextEditingController();
//
//   // Observable variables
//   final RxBool isLoading = false.obs;
//   final RxBool isSubmitting = false.obs;
//   final RxBool isEditMode = false.obs;
//
//   // Form fields
//   final RxString selectedEmployee = ''.obs;
//   final RxString selectedEmployeeName = ''.obs;
//   final RxString selectedStatus = ''.obs;
//   final RxString selectedLeaveType = ''.obs;
//   final RxString selectedShift = ''.obs;
//   final RxString selectedHalfDayPeriod = ''.obs;
//   final RxBool lateEntry = false.obs;
//   final RxBool earlyExit = false.obs;
//
//   // Data lists
//   final RxList<dynamic> employeeList = <dynamic>[].obs;
//   final RxList<dynamic> shiftTypeList = <dynamic>[].obs;
//   final RxList<dynamic> leaveTypeList = <dynamic>[].obs;
//
//   // Filtered employee list for search
//   final RxList<dynamic> filteredEmployeeList = <dynamic>[].obs;
//   final RxString searchQuery = ''.obs;
//
//   final List<String> statusOptions = [
//     'Present',
//     'Absent',
//     'On Leave',
//     'Work From Home',
//     'Half Day'
//   ];
//
//   // For edit mode
//   String? attendanceId;
//   AttendanceModel? currentAttendance;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Check if we're in edit mode
//     final arguments = Get.arguments;
//     if (arguments != null && arguments is Map) {
//       if (arguments['attendance'] != null) {
//         isEditMode.value = true;
//         currentAttendance = arguments['attendance'] as AttendanceModel;
//         attendanceId = currentAttendance!.name;
//         _populateFormForEdit();
//       }
//     }
//
//     // Set default company
//     companyController.text = 'Vasani Polymers';
//
//     // Set default date to today
//     attendanceDateController.text = _formatDate(DateTime.now());
//
//     _initializeData();
//   }
//
//   void _populateFormForEdit() {
//     if (currentAttendance != null) {
//       selectedEmployee.value = currentAttendance!.employee;
//       selectedEmployeeName.value = currentAttendance!.employeeName;
//       attendanceDateController.text = _formatDate(DateTime.parse(currentAttendance!.attendanceDate));
//       companyController.text = currentAttendance!.company ?? 'Vasani Polymers';
//       selectedStatus.value = currentAttendance!.status;
//       selectedShift.value = currentAttendance!.shift ?? '';
//       lateEntry.value = currentAttendance!.lateEntry == 1;
//       earlyExit.value = currentAttendance!.earlyExit == 1;
//
//       // Set leave type if status is On Leave or Half Day
//       if (currentAttendance!.status == 'On Leave' || currentAttendance!.status == 'Half Day') {
//         selectedLeaveType.value = currentAttendance!.leaveType ?? '';
//       }
//     }
//   }
//
//   Future<void> _initializeData() async {
//     isLoading.value = true;
//
//     await Future.wait([
//       _fetchEmployeeList(),
//       _fetchShiftTypes(),
//       _fetchLeaveTypes(),
//     ]);
//
//     isLoading.value = false;
//   }
//
//   Future<void> _fetchEmployeeList() async {
//     try {
//       const String endpoint = '/api/resource/Employee';
//       const String fields = '["name","employee_name","company"]';
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
//         Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
//
//         if (responseData['data'] != null) {
//           final List<dynamic> data = responseData['data'];
//           employeeList.assignAll(data);
//           filteredEmployeeList.assignAll(data);
//         }
//       }
//     } catch (e) {
//       print('Error fetching employee list: $e');
//       Get.snackbar('Error', 'Failed to load employee list');
//     }
//   }
//
//   Future<void> _fetchShiftTypes() async {
//     try {
//       const String endpoint = '/api/resource/Shift Type';
//       const String fields = '["name","start_time","end_time"]';
//
//       final response = await ApiService.get(
//         endpoint,
//         params: {
//           'fields': fields,
//           'limit_page_length': '0',
//         },
//       );
//
//       if (response != null && response.data != null) {
//         Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
//
//         if (responseData['data'] != null) {
//           final List<dynamic> data = responseData['data'];
//           shiftTypeList.assignAll(data);
//         }
//       }
//     } catch (e) {
//       print('Error fetching shift types: $e');
//       Get.snackbar('Error', 'Failed to load shift types');
//     }
//   }
//
//   Future<void> _fetchLeaveTypes() async {
//     try {
//       const String endpoint = '/api/resource/Leave Type';
//       const String fields = '["name","leave_type_name","max_leaves_allowed"]';
//
//       final response = await ApiService.get(
//         endpoint,
//         params: {
//           'fields': fields,
//           'limit_page_length': '0',
//         },
//       );
//
//       if (response != null && response.data != null) {
//         Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
//
//         if (responseData['data'] != null) {
//           final List<dynamic> data = responseData['data'];
//           leaveTypeList.assignAll(data);
//         }
//       }
//     } catch (e) {
//       print('Error fetching leave types: $e');
//       Get.snackbar('Error', 'Failed to load leave types');
//     }
//   }
//
//   void updateSearchQuery(String query) {
//     searchQuery.value = query;
//     if (query.isEmpty) {
//       filteredEmployeeList.assignAll(employeeList);
//     } else {
//       filteredEmployeeList.assignAll(
//         employeeList.where((employee) {
//           final name = employee['employee_name']?.toLowerCase() ?? '';
//           final code = employee['name']?.toLowerCase() ?? '';
//           return name.contains(query.toLowerCase()) || code.contains(query.toLowerCase());
//         }).toList(),
//       );
//     }
//   }
//
//   void updateEmployeeName() {
//     final employee = employeeList.firstWhere(
//           (emp) => emp['name'] == selectedEmployee.value,
//       orElse: () => null,
//     );
//
//     if (employee != null) {
//       selectedEmployeeName.value = employee['employee_name'] ?? employee['name'];
//     }
//   }
//
//   Future<void> selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: const Color(0xFF2E7D32),
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       attendanceDateController.text = _formatDate(picked);
//     }
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
//   }
//
//   String _formatDateForAPI(String displayDate) {
//     // Convert from DD-MM-YYYY to YYYY-MM-DD
//     final parts = displayDate.split('-');
//     if (parts.length == 3) {
//       return '${parts[2]}-${parts[1]}-${parts[0]}';
//     }
//     return displayDate;
//   }
//
//   Future<void> submitAttendance() async {
//     if (!formKey.currentState!.validate()) {
//       return;
//     }
//
//     // Additional validation for Half Day
//     if (selectedStatus.value == 'Half Day' && selectedHalfDayPeriod.value.isEmpty) {
//       Get.snackbar('Validation Error', 'Please select half day period');
//       return;
//     }
//
//     isSubmitting.value = true;
//
//     try {
//
//       Map<String, dynamic> requestData = {
//         'employee': selectedEmployee.value,
//         'attendance_date': _formatDateForAPI(attendanceDateController.text),
//         'company': companyController.text,
//         'status': selectedStatus.value,
//         'late_entry': lateEntry.value ? 1 : 0,
//         'early_exit': earlyExit.value ? 1 : 0,
//       };
//
//       // Add optional fields
//       if (selectedShift.value.isNotEmpty) {
//         requestData['shift'] = selectedShift.value;
//       }
//
//       if (selectedStatus.value == 'On Leave' || selectedStatus.value == 'Half Day') {
//         if (selectedLeaveType.value.isNotEmpty) {
//           requestData['leave_type'] = selectedLeaveType.value;
//         }
//       }
//
//       // Add half day period if selected
//       if (selectedStatus.value == 'Half Day' && selectedHalfDayPeriod.value.isNotEmpty) {
//         requestData['half_day_date'] = selectedHalfDayPeriod.value;
//       }
//
//       dynamic response;
//
//       if (isEditMode.value && attendanceId != null) {
//         // Update existing attendance
//         response = await ApiService.put(
//           '/api/resource/Attendance/$attendanceId',
//           data: requestData,
//         );
//       } else {
//         // Create new attendance
//         response = await ApiService.post(
//           '/api/resource/Attendance',
//           data: requestData,
//         );
//       }
//
//       if (response != null) {
//         Get.snackbar(
//           'Success',
//           isEditMode.value ? 'Attendance updated successfully' : 'Attendance created successfully',
//           backgroundColor: Colors.green[100],
//           colorText: Colors.green[800],
//         );
//
//         // Go back to list and refresh
//         Get.back(result: true);
//       } else {
//         throw Exception('Failed to submit attendance');
//       }
//
//     } catch (e) {
//       print('Error submitting attendance: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to ${isEditMode.value ? 'update' : 'create'} attendance: ${e.toString()}',
//         backgroundColor: Colors.red[100],
//         colorText: Colors.red[800],
//       );
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     attendanceDateController.dispose();
//     companyController.dispose();
//     super.onClose();
//   }
// }

import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/vo/AttendanceAddModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceFormController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController attendanceDateController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final RxString selectedShiftName = ''.obs;
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isEditMode = false.obs;

  // Form fields
  final RxString selectedEmployee = ''.obs;
  final RxString selectedEmployeeName = ''.obs;
  final RxString selectedStatus = ''.obs;
  final RxString selectedLeaveType = ''.obs;
  final RxString selectedShift = ''.obs;
  final RxString selectedHalfDayPeriod = ''.obs;
  final RxBool lateEntry = false.obs;
  final RxBool earlyExit = false.obs;

  // Data lists
  final RxList<dynamic> employeeList = <dynamic>[].obs;
  final RxList<dynamic> shiftTypeList = <dynamic>[].obs;
  final RxList<dynamic> leaveTypeList = <dynamic>[].obs;

  // Filtered employee list for search
  final RxList<dynamic> filteredEmployeeList = <dynamic>[].obs;
  final RxString searchQuery = ''.obs;

  final List<String> statusOptions = [
    'Present',
    'Absent',
    'On Leave',
    'Work From Home',
    'Half Day'
  ];

  // For edit mode
  String? attendanceId;
  AttendanceAddModel? currentAttendance;

  @override
  void onInit() {
    super.onInit();

    // Check if we're in edit mode
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map) {
      if (arguments['attendance'] != null) {
        isEditMode.value = true;
        currentAttendance = arguments['attendance'] as AttendanceAddModel;
        attendanceId = currentAttendance!.name;
        _populateFormForEdit();
      }
    }

    // Set default company
    companyController.text = 'Vasani Polymers';

    // Set default date to today
    attendanceDateController.text = _formatDate(DateTime.now());

    _initializeData();
  }
  // Add this new method to update shift name:
  void updateShiftName() {
    final shift = shiftTypeList.firstWhere(
          (s) => s['name'] == selectedShift.value,
      orElse: () => null,
    );

    if (shift != null) {
      selectedShiftName.value = shift['name'] ?? '';
    }
  }

  // Update your _populateFormForEdit method to include shift name:
  void _populateFormForEdit() {
    if (currentAttendance != null) {
      selectedEmployee.value = currentAttendance!.employee;
      selectedEmployeeName.value = currentAttendance!.employeeName;
      attendanceDateController.text = _formatDate(DateTime.parse(currentAttendance!.attendanceDate));
      companyController.text = currentAttendance!.company ?? 'Vasani Polymers';
      selectedStatus.value = currentAttendance!.status;
      selectedShift.value = currentAttendance!.shift ?? '';

      // Update shift name when populating for edit
      if (selectedShift.value.isNotEmpty) {
        updateShiftName();
      }

      lateEntry.value = currentAttendance!.lateEntry == 1;
      earlyExit.value = currentAttendance!.earlyExit == 1;

      // Set leave type if status is On Leave or Half Day
      if (currentAttendance!.status == 'On Leave' || currentAttendance!.status == 'Half Day') {
        selectedLeaveType.value = currentAttendance!.leaveType ?? '';
      }

      // Set half day period if applicable
      if (currentAttendance!.status == 'Half Day' && currentAttendance!.halfDayDate != null) {
        selectedHalfDayPeriod.value = currentAttendance!.halfDayDate!;
      }
    }
  }

  // void _populateFormForEdit() {
  //   if (currentAttendance != null) {
  //     selectedEmployee.value = currentAttendance!.employee;
  //     selectedEmployeeName.value = currentAttendance!.employeeName;
  //     attendanceDateController.text = _formatDate(DateTime.parse(currentAttendance!.attendanceDate));
  //     companyController.text = currentAttendance!.company ?? 'Vasani Polymers';
  //     selectedStatus.value = currentAttendance!.status;
  //     selectedShift.value = currentAttendance!.shift ?? '';
  //     lateEntry.value = currentAttendance!.lateEntry == 1;
  //     earlyExit.value = currentAttendance!.earlyExit == 1;
  //
  //     // Set leave type if status is On Leave or Half Day
  //     if (currentAttendance!.status == 'On Leave' || currentAttendance!.status == 'Half Day') {
  //       selectedLeaveType.value = currentAttendance!.leaveType ?? '';
  //     }
  //
  //     // Set half day period if applicable
  //     if (currentAttendance!.status == 'Half Day' && currentAttendance!.halfDayDate != null) {
  //       selectedHalfDayPeriod.value = currentAttendance!.halfDayDate!;
  //     }
  //   }
  // }

  Future<void> _initializeData() async {
    isLoading.value = true;

    await Future.wait([
      _fetchEmployeeList(),
      _fetchShiftTypes(),
      _fetchLeaveTypes(),
    ]);

    isLoading.value = false;
  }

  Future<void> _fetchEmployeeList() async {
    try {
      const String endpoint = '/api/resource/Employee';
      const String fields = '["name","employee_name","company"]';

      final response = await ApiService.get(
        endpoint,
        params: {
          'fields': fields,
          'limit_page_length': '1000',
        },
      );

      if (response != null && response.data != null) {
        Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

        if (responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          employeeList.assignAll(data);
          filteredEmployeeList.assignAll(data);
        }
      }
    } catch (e) {
      print('Error fetching employee list: $e');
      Get.snackbar('Error', 'Failed to load employee list');
    }
  }

  Future<void> _fetchShiftTypes() async {
    try {
      const String endpoint = '/api/resource/Shift Type';
      const String fields = '["name","start_time","end_time"]';

      final response = await ApiService.get(
        endpoint,
        params: {
          'fields': fields,
          'limit_page_length': '0',
        },
      );

      if (response != null && response.data != null) {
        Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

        if (responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          shiftTypeList.assignAll(data);
        }
      }
    } catch (e) {
      print('Error fetching shift types: $e');
      Get.snackbar('Error', 'Failed to load shift types');
    }
  }

  Future<void> _fetchLeaveTypes() async {
    try {
      const String endpoint = '/api/resource/Leave Type';
      const String fields = '["name","leave_type_name","max_leaves_allowed"]';

      final response = await ApiService.get(
        endpoint,
        params: {
          'fields': fields,
          'limit_page_length': '0',
        },
      );

      if (response != null && response.data != null) {
        Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

        if (responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];
          leaveTypeList.assignAll(data);
        }
      }
    } catch (e) {
      print('Error fetching leave types: $e');
      Get.snackbar('Error', 'Failed to load leave types');
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredEmployeeList.assignAll(employeeList);
    } else {
      filteredEmployeeList.assignAll(
        employeeList.where((employee) {
          final name = employee['employee_name']?.toLowerCase() ?? '';
          return name.contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  void updateEmployeeName() {
    final employee = employeeList.firstWhere(
          (emp) => emp['name'] == selectedEmployee.value,
      orElse: () => null,


    );

    if (employee != null) {
      selectedEmployeeName.value = employee['employee_name'] ?? employee['name'];
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF2E7D32),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      attendanceDateController.text = _formatDate(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  String _formatDateForAPI(String displayDate) {
    // Convert from DD-MM-YYYY to YYYY-MM-DD
    final parts = displayDate.split('-');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return displayDate;
  }

  // Future<void> submitAttendance() async {
  //   if (!formKey.currentState!.validate()) {
  //     return;
  //   }
  //
  //   // Additional validation for Half Day
  //   if (selectedStatus.value == 'Half Day' && selectedHalfDayPeriod.value.isEmpty) {
  //     Get.snackbar('Validation Error', 'Please select half day period');
  //     return;
  //   }
  //
  //   isSubmitting.value = true;
  //
  //   try {
  //     Map<String, dynamic> requestData = {
  //       'employee': selectedEmployee.value,
  //       'attendance_date': _formatDateForAPI(attendanceDateController.text),
  //       'company': companyController.text,
  //       'status': selectedStatus.value,
  //       'late_entry': lateEntry.value ? 1 : 0,
  //       'early_exit': earlyExit.value ? 1 : 0,
  //     };
  //
  //     // Add optional fields
  //     if (selectedShift.value.isNotEmpty) {
  //       requestData['shift'] = selectedShift.value;
  //     }
  //
  //     if (selectedStatus.value == 'On Leave' || selectedStatus.value == 'Half Day') {
  //       if (selectedLeaveType.value.isNotEmpty) {
  //         requestData['leave_type'] = selectedLeaveType.value;
  //       }
  //     }
  //
  //     // Add half day period if selected
  //     if (selectedStatus.value == 'Half Day' && selectedHalfDayPeriod.value.isNotEmpty) {
  //       requestData['half_day_date'] = selectedHalfDayPeriod.value;
  //     }
  //
  //     dynamic response;
  //
  //     if (isEditMode.value && attendanceId != null) {
  //       // Update existing attendance
  //       response = await ApiService.put(
  //         '/api/resource/Attendance/$attendanceId',
  //         data: requestData,
  //       );
  //     } else {
  //       // Create new attendance
  //       response = await ApiService.post(
  //         '/api/resource/Attendance',
  //         data: requestData,
  //       );
  //     }
  //
  //     if (response != null) {
  //       Get.snackbar(
  //         'Success',
  //         isEditMode.value ? 'Attendance updated successfully' : 'Attendance created successfully',
  //         backgroundColor: Colors.green[100],
  //         colorText: Colors.green[800],
  //       );
  //
  //       // Go back to list and refresh
  //       Get.back(result: true);
  //     } else {
  //       throw Exception('Failed to submit attendance');
  //     }
  //
  //   } catch (e) {
  //     print('Error submitting attendance: $e');
  //     Get.snackbar(
  //       'Error',
  //       'Failed to ${isEditMode.value ? 'update' : 'create'} attendance: ${e.toString()}',
  //       backgroundColor: Colors.red[100],
  //       colorText: Colors.red[800],
  //     );
  //   } finally {
  //     isSubmitting.value = false;
  //   }
  // }

  Future<void> submitAttendance() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Additional validation for Half Day
    if (selectedStatus.value == 'Half Day' && selectedHalfDayPeriod.value.isEmpty) {
      Get.snackbar('Validation Error', 'Please select half day period');
      return;
    }

    isSubmitting.value = true;

    try {
      Map<String, dynamic> requestData = {
        'employee': selectedEmployee.value,
        'attendance_date': _formatDateForAPI(attendanceDateController.text),
        'company': companyController.text,
        'status': selectedStatus.value,
        'late_entry': lateEntry.value ? 1 : 0,
        'early_exit': earlyExit.value ? 1 : 0,
      };

      // Add optional fields
      if (selectedShift.value.isNotEmpty) {
        requestData['shift'] = selectedShift.value;
      }

      if (selectedStatus.value == 'On Leave' || selectedStatus.value == 'Half Day') {
        if (selectedLeaveType.value.isNotEmpty) {
          requestData['leave_type'] = selectedLeaveType.value;
        }
      }

      // Add half day period if selected
      if (selectedStatus.value == 'Half Day' && selectedHalfDayPeriod.value.isNotEmpty) {
        requestData['half_day_date'] = selectedHalfDayPeriod.value;
      }

      dynamic response;

      if (isEditMode.value && attendanceId != null) {
        // Update existing attendance
        response = await ApiService.put(
          '/api/resource/Attendance/$attendanceId',
          data: requestData,
        );
      } else {
        // Create new attendance
        response = await ApiService.post(
          '/api/resource/Attendance',
          data: requestData,
        );
      }

      if (response != null) {
        // Go back to list immediately and refresh
        Get.back(result: true);

        // Show success message on the list page
        Get.snackbar(
          'Success',
          isEditMode.value ? 'Attendance updated successfully' : 'Attendance created successfully',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
        );
      } else {
        throw Exception('Failed to submit attendance');
      }

    } catch (e) {
      print('Error submitting attendance: $e');
      Get.snackbar(
        'Error',
        'Failed to ${isEditMode.value ? 'update' : 'create'} attendance: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    attendanceDateController.dispose();
    companyController.dispose();
    super.onClose();
  }
}