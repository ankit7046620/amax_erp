import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/vo/AttendanceAddModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceListController extends GetxController {
  // Observable list to store attendance data
  final RxList<AttendanceAddModel> attendanceList = <AttendanceAddModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Error state
  final RxString errorMessage = ''.obs;

  // Search and filter
  final RxString searchQuery = ''.obs;
  final RxString selectedStatus = 'All'.obs;

  // Filtered list based on search and status
  RxList<AttendanceAddModel> get filteredAttendanceList {
    if (searchQuery.value.isEmpty && selectedStatus.value == 'All') {
      return attendanceList;
    }

    return attendanceList.where((attendance) {
      bool matchesSearch = searchQuery.value.isEmpty ||
          attendance.employeeName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          attendance.employee.toLowerCase().contains(searchQuery.value.toLowerCase());

      bool matchesStatus = selectedStatus.value == 'All' ||
          attendance.status.toLowerCase() == selectedStatus.value.toLowerCase();

      return matchesSearch && matchesStatus;
    }).toList().obs;
  }

  // Status options for filter
  final List<String> statusOptions = ['All', 'Present', 'Absent', 'On Leave', 'Work From Home', 'Half Day'];

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Fetch attendance data from API
  Future<void> fetchAttendanceData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      const String endpoint = '/api/resource/Attendance';
      const String fields = '["*"]';

      final response = await ApiService.get(
        endpoint,
        params: {
          'fields': fields,
          'limit_page_length': '1000',
        },
      );
      if (response != null && response.data != null) {
        print('✅ Attendance List API Response: ${response.data}');

        // Cast the response to a Map
        Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

        // Extract the list safely
        if (responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];

          attendanceList
            ..clear()
            ..addAll(data.map((json) => AttendanceAddModel.fromJson(json)));

          // Sort by date (latest first)
          attendanceList.sort((a, b) => b.attendanceDate.compareTo(a.attendanceDate));
        }
      } else {
        Get.snackbar('Error', 'Failed to load attendance list');
      }

    } catch (e) {
      errorMessage.value = 'Failed to load attendance data: ${e.toString()}';
      print('Error fetching attendance data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await fetchAttendanceData();
  }

  // Update search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Update status filter
  void updateStatusFilter(String status) {
    selectedStatus.value = status;
  }

  // Get status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'on leave':
        return Colors.orange;
      case 'work from home':
        return Colors.blue;
      case 'half day':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  // Get status icon
  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      case 'on leave':
        return Icons.time_to_leave;
      case 'work from home':
        return Icons.home_work;
      case 'half day':
        return Icons.access_time;
      default:
        return Icons.help;
    }
  }

  // Format date
  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  // Get time ago
  String getTimeAgo(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      Duration difference = DateTime.now().difference(dateTime);

      if (difference.inDays > 0) {
        return '${difference.inDays}d';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m';
      } else {
        return 'now';
      }
    } catch (e) {
      return '';
    }
  }
}