// import 'package:amax_hr/manager/api_service.dart' show ApiService;
// import 'package:amax_hr/vo/employee_checkin_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:syncfusion_flutter_charts/charts.dart' hide Position;
//
// class Employee {
//   final String name;
//   final String employee;
//   final String employeeName;
//
//   Employee({
//     required this.name,
//     required this.employee,
//     required this.employeeName,
//   });
//
//   factory Employee.fromJson(Map<String, dynamic> json) {
//     return Employee(
//       name: json['name'] ?? '',
//       employee: json['employee'] ?? '',
//       employeeName: json['employee_name'] ?? '',
//     );
//   }
// }
//
// class EmployeeListResponse {
//   final List<Employee> data;
//
//   EmployeeListResponse({required this.data});
//
//   factory EmployeeListResponse.fromJson(Map<String, dynamic> json) {
//     var list = json['data'] as List;
//     List<Employee> employees = list.map((item) => Employee.fromJson(item)).toList();
//     return EmployeeListResponse(data: employees);
//   }
// }
//
// class EmployeeCheckinController extends GetxController {
//   // Observable variables
//   var isLoading = false.obs;
//   var checkinList = <EmployeeCheckin>[].obs;
//   var errorMessage = ''.obs;
//   var selectedDate = DateTime.now().obs;
//   var isRefreshing = false.obs;
//
//   // New Employee Checkin variables
//   var employeeList = <Employee>[].obs;
//   var filteredEmployeeList = <Employee>[].obs;
//   var isLoadingEmployees = false.obs;
//   var selectedEmployee = Rxn<Employee>();
//   var selectedLogType = 'IN'.obs;
//   var isSubmitting = false.obs;
//   var selectedDateTime = DateTime.now().obs;
//   var searchController = TextEditingController();
//   var showEmployeeDropdown = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchEmployeeCheckins();
//   }
//
//   @override
//   void onClose() {
//     searchController.dispose();
//     super.onClose();
//   }
//
//   // Filter employees based on search
//   void filterEmployees(String query) {
//     if (query.isEmpty) {
//       filteredEmployeeList.value = employeeList;
//     } else {
//       filteredEmployeeList.value = employeeList.where((employee) =>
//       employee.employee.toLowerCase().contains(query.toLowerCase()) ||
//           employee.employeeName.toLowerCase().contains(query.toLowerCase())
//       ).toList();
//     }
//   }
//
//   // Select employee from dropdown
//   void selectEmployee(Employee employee) {
//     selectedEmployee.value = employee;
//     searchController.text = '${employee.employee} - ${employee.employeeName}';
//     showEmployeeDropdown.value = false;
//   }
//
//   // Show date time picker
//   Future<void> selectDateTime(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDateTime.value,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now().add(Duration(days: 1)),
//     );
//
//     if (pickedDate != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(selectedDateTime.value),
//       );
//
//       if (pickedTime != null) {
//         selectedDateTime.value = DateTime(
//           pickedDate.year,
//           pickedDate.month,
//           pickedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//       }
//     }
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
//   // Fetch employees list
//   Future<void> fetchEmployees() async {
//     try {
//       isLoadingEmployees.value = true;
//
//       String endpoint = 'api/resource/Employee';
//       String fields = '["name","employee","employee_name"]';
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
//         print('✅ Employees API Response: ${response.data}');
//
//         Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
//         EmployeeListResponse employeeResponse = EmployeeListResponse.fromJson(responseData);
//         employeeList.value = employeeResponse.data;
//         filteredEmployeeList.value = employeeResponse.data;
//
//         print('✅ Parsed ${employeeList.length} employees');
//       } else {
//         Get.snackbar('Error', 'Failed to load employees');
//       }
//     } catch (e) {
//       print('❌ Error fetching employees: $e');
//       Get.snackbar('Error', 'Failed to load employees: ${e.toString()}');
//     } finally {
//       isLoadingEmployees.value = false;
//     }
//   }
//
//   // Get current location
//   Future<Map<String, String>> _getCurrentLocation() async {
//     try {
//       // Check if location services are enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         return {
//           'latitude': '23.0225',
//           'longitude': '72.5714',
//           'location': 'Ahmedabad, Gujarat, India'
//         };
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           return {
//             'latitude': '23.0225',
//             'longitude': '72.5714',
//             'location': 'Ahmedabad, Gujarat, India'
//           };
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         return {
//           'latitude': '23.0225',
//           'longitude': '72.5714',
//           'location': 'Ahmedabad, Gujarat, India'
//         };
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       return {
//         'latitude': position.latitude.toString(),
//         'longitude': position.longitude.toString(),
//         'location': 'Current Location'
//       };
//     } catch (e) {
//       print('❌ Error getting location: $e');
//       return {
//         'latitude': '23.0225',
//         'longitude': '72.5714',
//         'location': 'Ahmedabad, Gujarat, India'
//       };
//     }
//   }
//
//   // Create new employee checkin
//   Future<void> createEmployeeCheckin() async {
//     if (selectedEmployee.value == null) {
//       Get.snackbar('Error', 'Please select an employee');
//       return;
//     }
//
//     try {
//       isSubmitting.value = true;
//
//       // Use selected date time instead of current time
//       String selectedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime.value);
//
//       // Get current location
//       Map<String, String> locationData = await _getCurrentLocation();
//
//       Map<String, dynamic> requestBody = {
//         'employee': selectedEmployee.value!.employee,
//         'log_type': selectedLogType.value,
//         'time': selectedTime,
//         'device_id': 'WEB_APP',
//         'latitude': locationData['latitude'],
//         'longitude': locationData['longitude'],
//         'location': locationData['location'],
//       };
//
//       print('📤 Creating checkin with data: $requestBody');
//
//       final response = await ApiService.post(
//         'api/resource/Employee Checkin',
//         data: requestBody,
//       );
//
//       if (response != null) {
//         print('✅ Employee checkin created successfully: ${response.data}');
//
//         // Clear selection first
//         selectedEmployee.value = null;
//         selectedLogType.value = 'IN';
//         selectedDateTime.value = DateTime.now();
//         searchController.clear();
//
//         // Close popup immediately after success
//         if (Get.isDialogOpen ?? false) {
//           Get.back();
//         }
//
//         // Show success message
//         Get.snackbar(
//           'Success',
//           'Employee checkin created successfully',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 2),
//         );
//
//         // Refresh the checkin list in background
//         await refreshData();
//
//       } else {
//         Get.snackbar(
//           'Error',
//           'Failed to create employee checkin',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       print('❌ Error creating employee checkin: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to create checkin: ${e.toString()}',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
//
//   // Show new checkin popup
//   void showNewCheckinPopup() {
//     // Reset form
//     selectedEmployee.value = null;
//     selectedLogType.value = 'IN';
//     selectedDateTime.value = DateTime.now();
//     searchController.clear();
//     showEmployeeDropdown.value = false;
//
//     // Fetch employees if not already loaded
//     if (employeeList.isEmpty) {
//       fetchEmployees();
//     }
//
//     Get.dialog(
//       NewEmployeeCheckinPopup(),
//       barrierDismissible: false,
//     );
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
//
// // New Employee Checkin Popup Widget
// class NewEmployeeCheckinPopup extends GetView<EmployeeCheckinController> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Container(
//         width: Get.width * 0.9,
//         constraints: BoxConstraints(
//           maxHeight: Get.height * 0.8,
//         ),
//         padding: const EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//           //  mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               Row(
//                 children: [
//                   Icon(
//                     Icons.person_add_alt_1,
//                     color: Colors.indigo.shade600,
//                     size: 24,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       'New Employee Checkin',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.indigo.shade700,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   IconButton(
//                     onPressed: () => Get.back(),
//                     icon: const Icon(Icons.close),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               // Employee Selection with Search
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Employee *',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey[300]!),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       children: [
//                         TextField(
//                           controller: controller.searchController,
//                           decoration: InputDecoration(
//                             hintText: 'Type to search employee...',
//                             prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
//                             border: InputBorder.none,
//                             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//                           ),
//                           onChanged: (value) {
//                             controller.filterEmployees(value);
//                             controller.showEmployeeDropdown.value = true;
//                           },
//                           onTap: () {
//                             // Always show dropdown when tapping
//                             controller.showEmployeeDropdown.value = true;
//                             // If search field is empty, show all employees
//                             if (controller.searchController.text.isEmpty) {
//                               controller.filteredEmployeeList.value = controller.employeeList;
//                             }
//                             // If there are employees but filteredList is empty, show all
//                             if (controller.filteredEmployeeList.isEmpty && controller.employeeList.isNotEmpty) {
//                               controller.filteredEmployeeList.value = controller.employeeList;
//                             }
//                           },
//                         ),
//                         Obx(() {
//                           if (controller.showEmployeeDropdown.value && controller.filteredEmployeeList.isNotEmpty) {
//                             return Container(
//                               decoration: BoxDecoration(
//                                 border: Border(top: BorderSide(color: Colors.grey[300]!)),
//                               ),
//                               constraints: const BoxConstraints(maxHeight: 200),
//                               child: ListView.builder(
//                                 shrinkWrap: true,
//                                 itemCount: controller.filteredEmployeeList.length,
//                                 itemBuilder: (context, index) {
//                                   final employee = controller.filteredEmployeeList[index];
//                                   return ListTile(
//                                     dense: true,
//                                     title: Text(
//                                       employee.employee,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w500,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     subtitle: Text(
//                                       employee.employeeName,
//                                       style: TextStyle(
//                                         color: Colors.grey[600],
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                     onTap: () => controller.selectEmployee(employee),
//                                   );
//                                 },
//                               ),
//                             );
//                           }
//                           return const SizedBox.shrink();
//                         }),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               // Time Selection
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Time *',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   GestureDetector(
//                     onTap: () => controller.selectDateTime(context),
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[300]!),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Obx(() => Text(
//                               DateFormat('dd-MM-yyyy HH:mm:ss').format(controller.selectedDateTime.value),
//                               style: const TextStyle(fontSize: 14),
//                             )),
//                           ),
//                           Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Asia/Kolkata',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 20),
//
//               // Log Type Selection
//               Text(
//                 'Log Type',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Obx(() => Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey[300]!),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     isExpanded: true,
//                     value: controller.selectedLogType.value,
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         controller.selectedLogType.value = newValue;
//                       }
//                     },
//                     items: const [
//                       DropdownMenuItem(value: 'IN', child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('IN'))),
//                       DropdownMenuItem(value: 'OUT', child: Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('OUT'))),
//                     ],
//                   ),
//                 ),
//               )),
//
//               const SizedBox(height: 20),
//
//               // Location / Device ID
//               Text(
//                 'Location / Device ID',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey[700],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   border: Border.all(color: Colors.grey[300]!),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Row(
//                   children: [
//                     Icon(Icons.location_on, color: Colors.grey, size: 20),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'WEB_APP',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//
//               // // Skip Auto Attendance Checkbox
//               // Row(
//               //   children: [
//               //     Checkbox(
//               //       value: false,
//               //       onChanged: (bool? value) {
//               //         // Handle checkbox change if needed
//               //       },
//               //     ),
//               //     const Text('Skip Auto Attendance'),
//               //   ],
//               // ),
//               //
//               const SizedBox(height: 24),
//
//               // Action Buttons
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Get.back(),
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Obx(() => ElevatedButton(
//                       onPressed: controller.isSubmitting.value
//                           ? null
//                           : () => controller.createEmployeeCheckin(),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: controller.isSubmitting.value
//                           ? const SizedBox(
//                         height: 16,
//                         width: 16,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                           : const Text('Save'),
//                     )),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//


import 'package:amax_hr/app/modules/EmployeeCheckin/views/new_employee_checkin_popup.dart';
import 'package:amax_hr/manager/api_service.dart' show ApiService;
import 'package:amax_hr/vo/employee_checkin_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Office location model
class OfficeLocation {
  final String name;
  final double latitude;
  final double longitude;
  final double radiusInMeters;
  final String address;

  OfficeLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusInMeters,
    required this.address,
  });

  // Calculate distance from current location
  double distanceFrom(double currentLat, double currentLng) {
    return Geolocator.distanceBetween(
      latitude,
      longitude,
      currentLat,
      currentLng,
    );
  }

  // Check if current location is within geofence
  bool isWithinGeofence(double currentLat, double currentLng) {
    return distanceFrom(currentLat, currentLng) <= radiusInMeters;
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

  // Employee Checkin variables
  var employeeList = <Employee>[].obs;
  var filteredEmployeeList = <Employee>[].obs;
  var isLoadingEmployees = false.obs;
  var selectedEmployee = Rxn<Employee>();
  var selectedLogType = 'IN'.obs;
  var isSubmitting = false.obs;
  var selectedDateTime = DateTime.now().obs;
  var searchController = TextEditingController();
  var showEmployeeDropdown = false.obs;

  // Geofencing variables
  var currentPosition = Rxn<Position>();
  var isLocationLoading = false.obs;
  var locationError = ''.obs;
  var isWithinGeofence = false.obs;
  var nearestOffice = Rxn<OfficeLocation>();
  var distanceFromOffice = 0.0.obs;

  // Google Maps variables
  var mapController = Rxn<GoogleMapController>();
  var markers = <Marker>{}.obs;
  var circles = <Circle>{}.obs;
  var showMap = false.obs;

  // Define office locations (you can modify these based on your offices)
  final List<OfficeLocation> officeLocations = [
    OfficeLocation(
      name: 'Main Office - Ahmedabad',
      latitude: 23.037292,
      longitude: 72.568822,
      radiusInMeters: 200, // 100 meters radius
      address: 'Ahmedabad, Gujarat, India',
    ),
    OfficeLocation(
      name: 'Branch Office - Popular House',
      latitude: 23.037292,
      longitude: 72.568822,
      radiusInMeters: 150, // 150 meters radius
      address: 'SG Highway, Ahmedabad, Gujarat, India',
    ),
    // Add more office locations as needed
  ];

  @override
  void onInit() {
    super.onInit();
    fetchEmployeeCheckins();
    _getCurrentLocationAndCheckGeofence();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Get current location and check geofencing
  Future<void> _getCurrentLocationAndCheckGeofence() async {
    try {
      isLocationLoading.value = true;
      locationError.value = '';

      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationError.value = 'Location services are disabled.';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationError.value = 'Location permissions are denied.';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationError.value = 'Location permissions are permanently denied.';
        return;
      }

      // Get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      currentPosition.value = position;

      // Check geofencing for all offices
      _checkGeofencing(position.latitude, position.longitude);

      // Update map markers and circles
      _updateMapElements();

    } catch (e) {
      locationError.value = 'Failed to get location: ${e.toString()}';
      print('❌ Error getting location: $e');
    } finally {
      isLocationLoading.value = false;
    }
  }

  // Check if current location is within any office geofence
  void _checkGeofencing(double currentLat, double currentLng) {
    OfficeLocation? closest;
    double minDistance = double.infinity;

    for (OfficeLocation office in officeLocations) {
      double distance = office.distanceFrom(currentLat, currentLng);

      if (distance < minDistance) {
        minDistance = distance;
        closest = office;
      }
    }

    if (closest != null) {
      nearestOffice.value = closest;
      distanceFromOffice.value = minDistance;
      isWithinGeofence.value = closest.isWithinGeofence(currentLat, currentLng);
    }
  }

  // Update Google Maps markers and circles
  void _updateMapElements() {
    if (currentPosition.value == null) return;

    Set<Marker> newMarkers = {};
    Set<Circle> newCircles = {};

    // Add current location marker
    newMarkers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(
          currentPosition.value!.latitude,
          currentPosition.value!.longitude,
        ),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'Current position',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // Add office location markers and geofence circles
    for (int i = 0; i < officeLocations.length; i++) {
      OfficeLocation office = officeLocations[i];

      // Add office marker
      newMarkers.add(
        Marker(
          markerId: MarkerId('office_$i'),
          position: LatLng(office.latitude, office.longitude),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      // Add geofence circle
      newCircles.add(
        Circle(
          circleId: CircleId('geofence_$i'),
          center: LatLng(office.latitude, office.longitude),
          radius: office.radiusInMeters,
          fillColor: (nearestOffice.value == office && isWithinGeofence.value)
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
          strokeColor: (nearestOffice.value == office && isWithinGeofence.value)
              ? Colors.green
              : Colors.red,
          strokeWidth: 2,
        ),
      );
    }

    markers.value = newMarkers;
    circles.value = newCircles;
  }

  // Refresh location and geofencing
  Future<void> refreshLocation() async {
    await _getCurrentLocationAndCheckGeofence();
  }

  // Enhanced create employee checkin with geofencing validation
  Future<void> createEmployeeCheckin() async {
    if (selectedEmployee.value == null) {
      Get.snackbar('Error', 'Please select an employee');
      return;
    }

    // Check if location is available
    if (currentPosition.value == null) {
      Get.snackbar(
        'Location Required',
        'Please enable location and wait for GPS signal',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      await _getCurrentLocationAndCheckGeofence();
      return;
    }

    // Check geofencing validation
    if (!isWithinGeofence.value) {
      _showGeofenceWarningDialog();
      return;
    }

    try {
      isSubmitting.value = true;

      String selectedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime.value);

      Map<String, dynamic> requestBody = {
        'employee': selectedEmployee.value!.employee,
        'log_type': selectedLogType.value,
        'time': selectedTime,
        'device_id': 'WEB_APP_GEOFENCED',
        'latitude': currentPosition.value!.latitude.toString(),
        'longitude': currentPosition.value!.longitude.toString(),
        'location': nearestOffice.value?.name ?? 'Unknown Office',
        'geofence_validated': true,
        'distance_from_office': distanceFromOffice.value.round(),
        'office_name': nearestOffice.value?.name,
      };

      print('📤 Creating geofenced checkin with data: $requestBody');

      final response = await ApiService.post(
        'api/resource/Employee Checkin',
        data: requestBody,
      );

      if (response != null) {
        print('✅ Employee checkin created successfully: ${response.data}');

        // Clear selection
        selectedEmployee.value = null;
        selectedLogType.value = 'IN';
        selectedDateTime.value = DateTime.now();
        searchController.clear();

        // Close popup
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        // Show success message
        Get.snackbar(
          'Success',
          '${selectedLogType.value} recorded successfully at ${nearestOffice.value?.name}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Refresh data
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

  // Show geofence warning dialog
  void _showGeofenceWarningDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_off, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Location Validation Failed'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are not within the allowed office area.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            if (nearestOffice.value != null) ...[
              Text('Nearest Office: ${nearestOffice.value!.name}'),
              Text('Distance: ${distanceFromOffice.value.round()} meters'),
              Text('Required: Within ${nearestOffice.value!.radiusInMeters.round()} meters'),
            ],
            const SizedBox(height: 12),
            Text(
              'Please move closer to the office location or contact your administrator.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              showMap.value = true; // Show map to user
            },
            child: const Text('View Map'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              refreshLocation(); // Refresh location
            },
            child: const Text('Refresh Location'),
          ),
        ],
      ),
    );
  }

  // Show location map dialog
  void showLocationMap() {
    showMap.value = true;
  }

  // Filter employees based on search
  void filterEmployees(String query) {
    if (query.isEmpty) {
      filteredEmployeeList.value = employeeList;
    } else {
      filteredEmployeeList.value = employeeList.where((employee) =>
      employee.employee.toLowerCase().contains(query.toLowerCase()) ||
          employee.employeeName.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }

  // Select employee from dropdown
  void selectEmployee(Employee employee) {
    selectedEmployee.value = employee;
    searchController.text = '${employee.employee} - ${employee.employeeName}';
    showEmployeeDropdown.value = false;
  }

  // Show date time picker
  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 1)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime.value),
      );

      if (pickedTime != null) {
        selectedDateTime.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  // Fetch employee checkins with date range
  Future<void> fetchEmployeeCheckins({DateTime? startDate, DateTime? endDate}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      DateTime start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
      DateTime end = endDate ?? DateTime.now();

      String startDateStr = DateFormat('yyyy-MM-dd 00:00:00').format(start);
      String endDateStr = DateFormat('yyyy-MM-dd 23:59:59').format(end);

      String endpoint = 'api/resource/Employee%20Checkin';
      String filters = '[["time","between",["$startDateStr","$endDateStr"]]]';
      String fields = '["name","employee","employee_name","log_type","time","device_id","latitude","longitude","location","office_name"]';

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
        filteredEmployeeList.value = employeeResponse.data;

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

  // Show new checkin popup
  void showNewCheckinPopup() {
    // Reset form
    selectedEmployee.value = null;
    selectedLogType.value = 'IN';
    selectedDateTime.value = DateTime.now();
    searchController.clear();
    showEmployeeDropdown.value = false;

    // Refresh location first
    _getCurrentLocationAndCheckGeofence();

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

  // Get statistics
  int get totalEntries => checkinList.length;
  int get totalCheckIns => checkinList.where((item) => item.logType.toUpperCase() == 'IN').length;
  int get totalCheckOuts => checkinList.where((item) => item.logType.toUpperCase() == 'OUT').length;
}