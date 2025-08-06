// controllers/employee_checkin_controller.dart
import 'package:amax_hr/manager/api_service.dart' show ApiService;
import 'package:amax_hr/vo/employee_checkin_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmployeeCheckinController extends GetxController {
  // Observable variables
  var isLoading = false.obs;
  var checkinList = <EmployeeCheckin>[].obs;
  var errorMessage = ''.obs;
  var selectedDate = DateTime.now().obs;
  var isRefreshing = false.obs;

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