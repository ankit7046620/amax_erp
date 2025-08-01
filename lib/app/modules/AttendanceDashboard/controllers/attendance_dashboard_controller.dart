import 'package:amax_hr/manager/api_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Data Models
class AttendanceData {
  final String month;
  final String type;
  final int value;

  AttendanceData({required this.month, required this.type, required this.value});
}

class TimesheetActivityData {
  final String activity;
  final double percentage;
  final int hours;

  TimesheetActivityData({required this.activity, required this.percentage, required this.hours});
}

class DepartmentTimesheetData {
  final String department;
  final int hours;

  DepartmentTimesheetData({required this.department, required this.hours});
}

class AttendanceDashboardController extends GetxController {
  // Observable variables for dashboard metrics
  var isLoading = false.obs;
  var totalPresentToday = 0.obs;
  var totalAbsentToday = 0.obs;
  var lateEntryToday = 0.obs;
  var earlyExitThisMonth = 0.obs;

  // Chart data
  var attendanceCountData = <AttendanceData>[].obs;
  var timesheetActivityData = <TimesheetActivityData>[].obs;
  var departmentTimesheetData = <DepartmentTimesheetData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      isLoading.value = true;

      // Get current date in required format
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // API endpoint (without base URL since it's already in ApiService)
      String endpoint = 'api/resource/Employee';

      // Query parameters
      Map<String, dynamic> params = {
        'filters': '[["status","=","Active"],["creation",">=","$currentDate"]]',
        'fields': '["*"]'
      };

      final response = await ApiService.get(endpoint, params: params);

      if (response != null && response.statusCode == 200) {
        final jsonData = response.data;
        _processAttendanceData(jsonData);
      } else {
        print('API Error: ${response?.statusCode}');
        // Handle error - use mock data for demo
        _loadMockData();
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
      // Load mock data on error
      _loadMockData();
    } finally {
      isLoading.value = false;
    }
  }

  void _processAttendanceData(Map<String, dynamic> jsonData) {
    // Process the API response and calculate attendance metrics
    List<dynamic> employees = jsonData['data'] ?? [];

    // Calculate basic metrics (mock calculation based on employee data)
    totalPresentToday.value = employees.length > 0 ? 1 : 0;
    totalAbsentToday.value = employees.length > 0 ? 1 : 0;
    lateEntryToday.value = 0;
    earlyExitThisMonth.value = 0;

    // Generate attendance count data for chart
    _generateAttendanceCountData();

    // Generate timesheet activity data
    _generateTimesheetActivityData();

    // Generate department timesheet data
    _generateDepartmentTimesheetData(employees);
  }

  void _loadMockData() {
    // Mock data for demonstration
    totalPresentToday.value = 1;
    totalAbsentToday.value = 1;
    lateEntryToday.value = 0;
    earlyExitThisMonth.value = 0;

    _generateAttendanceCountData();
    _generateTimesheetActivityData();
    _generateDepartmentTimesheetDataMock();
  }

  void _generateAttendanceCountData() {
    attendanceCountData.value = [
      AttendanceData(month: 'Jan', type: 'Present', value: 2),
      AttendanceData(month: 'Feb', type: 'Present', value: 1),
      AttendanceData(month: 'Mar', type: 'Present', value: 0),
      AttendanceData(month: 'Apr', type: 'Present', value: 0),
      AttendanceData(month: 'May', type: 'Present', value: 1),
      AttendanceData(month: 'Jun', type: 'Present', value: 1),
      AttendanceData(month: 'Jul', type: 'Present', value: 2),

      AttendanceData(month: 'Jan', type: 'Absent', value: 0),
      AttendanceData(month: 'Feb', type: 'Absent', value: 0),
      AttendanceData(month: 'Mar', type: 'Absent', value: 0),
      AttendanceData(month: 'Apr', type: 'Absent', value: 0),
      AttendanceData(month: 'May', type: 'Absent', value: 0),
      AttendanceData(month: 'Jun', type: 'Absent', value: 0),
      AttendanceData(month: 'Jul', type: 'Absent', value: 1),

      AttendanceData(month: 'Jan', type: 'Leave', value: 0),
      AttendanceData(month: 'Feb', type: 'Leave', value: 0),
      AttendanceData(month: 'Mar', type: 'Leave', value: 0),
      AttendanceData(month: 'Apr', type: 'Leave', value: 0),
      AttendanceData(month: 'May', type: 'Leave', value: 0),
      AttendanceData(month: 'Jun', type: 'Leave', value: 1),
      AttendanceData(month: 'Jul', type: 'Leave', value: 1),
    ];
  }

  void _generateTimesheetActivityData() {
    timesheetActivityData.value = [
      TimesheetActivityData(activity: 'Planning', percentage: 100.0, hours: 42),
    ];
  }

  void _generateDepartmentTimesheetData(List<dynamic> employees) {
    Map<String, int> departmentHours = {};

    for (var employee in employees) {
      String department = employee['department'] ?? 'Unknown';
      if (department != 'Unknown' && department.isNotEmpty) {
        departmentHours[department] = (departmentHours[department] ?? 0) + 42;
      }
    }

    departmentTimesheetData.value = departmentHours.entries
        .map((entry) => DepartmentTimesheetData(
      department: entry.key.split(' - ').first, // Remove suffix like "- VP"
      hours: entry.value,
    ))
        .toList();

    // If no data, use mock data
    if (departmentTimesheetData.isEmpty) {
      _generateDepartmentTimesheetDataMock();
    }
  }

  void _generateDepartmentTimesheetDataMock() {
    departmentTimesheetData.value = [
      DepartmentTimesheetData(department: 'HR', hours: 42),
      DepartmentTimesheetData(department: 'IT', hours: 35),
    ];
  }

  void refreshData() {
    fetchAttendanceData();
  }
}