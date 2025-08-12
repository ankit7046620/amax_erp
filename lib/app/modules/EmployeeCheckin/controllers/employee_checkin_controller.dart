// controllers/employee_checkin_controller.dart
import 'package:amax_hr/manager/api_service.dart' show ApiService;
import 'package:amax_hr/vo/employee_checkin_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_charts/charts.dart' hide Position;

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
    List<Employee> employees = list.map((item) => Employee.fromJson(item)).toList();
    return EmployeeListResponse(data: employees);
  }
}

class EmployeeCheckinController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var checkinList = <EmployeeCheckin>[].obs;
  var errorMessage = ''.obs;
  var selectedDate = DateTime.now().obs;
  var isRefreshing = false.obs;

  // New Employee Checkin variables
  var employeeList = <Employee>[].obs;
  var isLoadingEmployees = false.obs;
  var selectedEmployee = Rxn<Employee>();
  var selectedLogType = 'IN'.obs;
  var isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeCheckins();
  }

  // Fetch employee checkins with date range
  Future<void> fetchEmployeeCheckins({DateTime? startDate, DateTime? endDate}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Set default date range (last 7 days to today)
      DateTime start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
      DateTime end = endDate ?? DateTime.now();

      // Format dates for API
      String startDateStr = DateFormat('yyyy-MM-dd 00:00:00').format(start);
      String endDateStr = DateFormat('yyyy-MM-dd 23:59:59').format(end);

      // Construct the API endpoint with filters
      String endpoint = 'api/resource/Employee%20Checkin';
      String filters = '[["time","between",["$startDateStr","$endDateStr"]]]';
      String fields = '["name","employee","employee_name","log_type","time","device_id"]';

      final response = await ApiService.get(
        endpoint,
        params: {
          'filters': filters,
          'fields': fields,
          'limit': '100',
        },
      );

      if (response != null && response.data != null) {
        print('✅ API Response: ${response.data}');

        // Handle the response data structure
        Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
        EmployeeCheckinResponse checkinResponse = EmployeeCheckinResponse.fromJson(responseData);
        checkinList.value = checkinResponse.data;

        print('✅ Parsed ${checkinList.length} checkin records');
      } else {
        errorMessage.value = 'Failed to load data - No response received';
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print('❌ Error fetching employee checkins: $e');
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

        Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
        EmployeeListResponse employeeResponse = EmployeeListResponse.fromJson(responseData);
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

  // Get current location
  Future<Map<String, String>> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return {
          'latitude': '23.0225',
          'longitude': '72.5714',
          'location': 'Ahmedabad, Gujarat, India'
        };
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return {
            'latitude': '23.0225',
            'longitude': '72.5714',
            'location': 'Ahmedabad, Gujarat, India'
          };
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return {
          'latitude': '23.0225',
          'longitude': '72.5714',
          'location': 'Ahmedabad, Gujarat, India'
        };
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'location': 'Current Location'
      };
    } catch (e) {
      print('❌ Error getting location: $e');
      return {
        'latitude': '23.0225',
        'longitude': '72.5714',
        'location': 'Ahmedabad, Gujarat, India'
      };
    }
  }

  // Create new employee checkin
// Create new employee checkin
  Future<void> createEmployeeCheckin() async {
    if (selectedEmployee.value == null) {
      Get.snackbar('Error', 'Please select an employee');
      return;
    }

    try {
      isSubmitting.value = true;

      // Get current time
      String currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // Get current location
      Map<String, String> locationData = await _getCurrentLocation();

      Map<String, dynamic> requestBody = {
        'employee': selectedEmployee.value!.employee,
        'log_type': selectedLogType.value,
        'time': currentTime,
        'device_id': 'WEB_APP',
        'latitude': locationData['latitude'],
        'longitude': locationData['longitude'],
        'location': locationData['location'],
      };

      print('📤 Creating checkin with data: $requestBody');

      final response = await ApiService.post(
        'api/resource/Employee Checkin',
        data: requestBody,
      );

      if (response != null) {
        print('✅ Employee checkin created successfully: ${response.data}');

        // Clear selection first
        selectedEmployee.value = null;
        selectedLogType.value = 'IN';

        // Close popup immediately after success
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        // Show success message
        Get.snackbar(
          'Success',
          'Employee checkin created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Refresh the checkin list in background
        await refreshData();

      } else {
        Get.snackbar(
          'Error',
          'Failed to create employee checkin',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Error creating employee checkin: $e');
      Get.snackbar(
        'Error',
        'Failed to create checkin: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  // Show new checkin popup
  void showNewCheckinPopup() {
    // Reset form
    selectedEmployee.value = null;
    selectedLogType.value = 'IN';

    // Fetch employees if not already loaded
    if (employeeList.isEmpty) {
      fetchEmployees();
    }

    Get.dialog(
      NewEmployeeCheckinPopup(),
      barrierDismissible: false,
    );
  }

  // Refresh data
  Future<void> refreshData() async {
    isRefreshing.value = true;
    await fetchEmployeeCheckins();
    isRefreshing.value = false;
  }

  // Filter by specific date
  Future<void> filterByDate(DateTime date) async {
    selectedDate.value = date;
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    await fetchEmployeeCheckins(startDate: startOfDay, endDate: endOfDay);
  }

  // Filter by date range
  Future<void> filterByDateRange(DateTime startDate, DateTime endDate) async {
    await fetchEmployeeCheckins(startDate: startDate, endDate: endDate);
  }

  // Get formatted time
  String getFormattedTime(String timeString) {
    try {
      DateTime dateTime = DateTime.parse(timeString);
      return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
    } catch (e) {
      return timeString;
    }
  }

  // Get log type color
  Color getLogTypeColor(String logType) {
    switch (logType.toUpperCase()) {
      case 'IN':
        return Colors.green;
      case 'OUT':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get log type icon
  IconData getLogTypeIcon(String logType) {
    switch (logType.toUpperCase()) {
      case 'IN':
        return Icons.login;
      case 'OUT':
        return Icons.logout;
      default:
        return Icons.access_time;
    }
  }

  // Get filtered checkins by employee
  List<EmployeeCheckin> getCheckinsByEmployee(String employeeName) {
    return checkinList.where((checkin) =>
        checkin.employeeName.toLowerCase().contains(employeeName.toLowerCase())
    ).toList();
  }

  // Get today's checkins
  List<EmployeeCheckin> getTodayCheckins() {
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return checkinList.where((checkin) =>
        checkin.time.startsWith(today)
    ).toList();
  }

  // Get statistics
  int get totalEntries => checkinList.length;

  int get totalCheckIns => checkinList
      .where((item) => item.logType.toUpperCase() == 'IN')
      .length;

  int get totalCheckOuts => checkinList
      .where((item) => item.logType.toUpperCase() == 'OUT')
      .length;
}

// New Employee Checkin Popup Widget
class NewEmployeeCheckinPopup extends GetView<EmployeeCheckinController> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: Get.width * 0.9,
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.8,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.person_add_alt_1,
                  color: Colors.indigo.shade600,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'New Employee Checkin',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Employee Selection
            Text(
              'Employee *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoadingEmployees.value) {
                return Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Employee>(
                    isExpanded: true,
                    hint: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('Select Employee'),
                    ),
                    value: controller.selectedEmployee.value,
                    onChanged: (Employee? newValue) {
                      controller.selectedEmployee.value = newValue;
                    },
                    items: controller.employeeList.map((Employee employee) {
                      return DropdownMenuItem<Employee>(
                        value: employee,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                employee.employee,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                employee.employeeName,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Log Type Selection
            Text(
              'Log Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Check In'),
                    value: 'IN',
                    groupValue: controller.selectedLogType.value,
                    onChanged: (String? value) {
                      if (value != null) {
                        controller.selectedLogType.value = value;
                      }
                    },
                    activeColor: Colors.green,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Check Out'),
                    value: 'OUT',
                    groupValue: controller.selectedLogType.value,
                    onChanged: (String? value) {
                      if (value != null) {
                        controller.selectedLogType.value = value;
                      }
                    },
                    activeColor: Colors.red,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            )),

            const SizedBox(height: 20),

            // Time Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Time: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.now())}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Location Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Location will be captured automatically',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : () => controller.createEmployeeCheckin(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Save'),
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// // controllers/employee_checkin_controller.dart
// import 'package:amax_hr/manager/api_service.dart' show ApiService;
// import 'package:amax_hr/vo/employee_checkin_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class EmployeeCheckinController extends GetxController {
//   // Observable variables
//   var isLoading = false.obs;
//   var checkinList = <EmployeeCheckin>[].obs;
//   var errorMessage = ''.obs;
//   var selectedDate = DateTime.now().obs;
//   var isRefreshing = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchEmployeeCheckins();
//   }
//
//   // Fetch employee checkins with date range
//   Future<void> fetchEmployeeCheckins({DateTime? startDate, DateTime? endDate}) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       // Set default date range (last 7 days to today)
//       DateTime start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
//       DateTime end = endDate ?? DateTime.now();
//
//       // Format dates for API
//       String startDateStr = DateFormat('yyyy-MM-dd 00:00:00').format(start);
//       String endDateStr = DateFormat('yyyy-MM-dd 23:59:59').format(end);
//
//       // Construct the API endpoint with filters
//       String endpoint = 'api/resource/Employee%20Checkin';
//       String filters = '[["time","between",["$startDateStr","$endDateStr"]]]';
//       String fields = '["name","employee","employee_name","log_type","time","device_id"]';
//
//       final response = await ApiService.get(
//         endpoint,
//         params: {
//           'filters': filters,
//           'fields': fields,
//           'limit': '100',
//         },
//       );
//
//       if (response != null && response.data != null) {
//         print('✅ API Response: ${response.data}');
//
//         // Handle the response data structure
//         Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
//         EmployeeCheckinResponse checkinResponse = EmployeeCheckinResponse.fromJson(responseData);
//         checkinList.value = checkinResponse.data;
//
//         print('✅ Parsed ${checkinList.length} checkin records');
//       } else {
//         errorMessage.value = 'Failed to load data - No response received';
//       }
//     } catch (e) {
//       errorMessage.value = 'Error: ${e.toString()}';
//       print('❌ Error fetching employee checkins: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Refresh data
//   Future<void> refreshData() async {
//     isRefreshing.value = true;
//     await fetchEmployeeCheckins();
//     isRefreshing.value = false;
//   }
//
//   // Filter by specific date
//   Future<void> filterByDate(DateTime date) async {
//     selectedDate.value = date;
//     DateTime startOfDay = DateTime(date.year, date.month, date.day);
//     DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
//     await fetchEmployeeCheckins(startDate: startOfDay, endDate: endOfDay);
//   }
//
//   // Filter by date range
//   Future<void> filterByDateRange(DateTime startDate, DateTime endDate) async {
//     await fetchEmployeeCheckins(startDate: startDate, endDate: endDate);
//   }
//
//   // Get formatted time
//   String getFormattedTime(String timeString) {
//     try {
//       DateTime dateTime = DateTime.parse(timeString);
//       return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
//     } catch (e) {
//       return timeString;
//     }
//   }
//
//   // Get log type color
//   Color getLogTypeColor(String logType) {
//     switch (logType.toUpperCase()) {
//       case 'IN':
//         return Colors.green;
//       case 'OUT':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   // Get log type icon
//   IconData getLogTypeIcon(String logType) {
//     switch (logType.toUpperCase()) {
//       case 'IN':
//         return Icons.login;
//       case 'OUT':
//         return Icons.logout;
//       default:
//         return Icons.access_time;
//     }
//   }
//
//   // Get filtered checkins by employee
//   List<EmployeeCheckin> getCheckinsByEmployee(String employeeName) {
//     return checkinList.where((checkin) =>
//         checkin.employeeName.toLowerCase().contains(employeeName.toLowerCase())
//     ).toList();
//   }
//
//   // Get today's checkins
//   List<EmployeeCheckin> getTodayCheckins() {
//     String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     return checkinList.where((checkin) =>
//         checkin.time.startsWith(today)
//     ).toList();
//   }
//
//   // Get statistics
//   int get totalEntries => checkinList.length;
//
//   int get totalCheckIns => checkinList
//       .where((item) => item.logType.toUpperCase() == 'IN')
//       .length;
//
//   int get totalCheckOuts => checkinList
//       .where((item) => item.logType.toUpperCase() == 'OUT')
//       .length;
// }