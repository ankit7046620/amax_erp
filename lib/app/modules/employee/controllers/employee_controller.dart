import 'package:amax_hr/app/modules/EmployeeCheckin/controllers/employee_checkin_controller.dart';
import 'package:amax_hr/main.dart';
import 'package:amax_hr/manager/api_service.dart';
import 'package:amax_hr/manager/location.dart';
import 'package:amax_hr/vo/employee_checkin_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeController extends GetxController {
  static EmployeeController get to => Get.find<EmployeeController>();

  // Loading state for shimmer cards
  var isCardLoading = true.obs;

  // Loading state for shimmer activity list
  var isActivityLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    // Simulate shimmer loading delay or replace with your actual fetch timing
    Future.delayed(const Duration(seconds: 2), () {
      isCardLoading.value = false;
      isActivityLoading.value = false;
    });

    fetchEmployees();
    fetchEmployeeCheckins();
    _loadLastLog(); // load last persisted state
  }

  var isLoadingEmployees = false.obs;
  var employeeList = <Employee>[].obs;

  RxString currentemployee = ''.obs;
  var selectedLogType = 'IN'.obs;
  var isSubmitting = false.obs;
  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var errorMessage = ''.obs;
  var checkinList = <EmployeeCheckin>[].obs;

  // Persisted state
  var isCheckedIn = false.obs;
  var isFinished = false.obs;

  /// Save last log into SharedPreferences
  Future<void> _saveLastLog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastLogType', selectedLogType.value);
    await prefs.setBool('isCheckedIn', isCheckedIn.value);
    await prefs.setString('lastLogTime', DateTime.now().toIso8601String());

    debugPrint("💾 Saved last log => type:${selectedLogType.value}, checkedIn:${isCheckedIn.value}");
  }

  /// Load last log from SharedPreferences
  Future<void> _loadLastLog() async {
    final prefs = await SharedPreferences.getInstance();
    selectedLogType.value = prefs.getString('lastLogType') ?? 'IN';
    isCheckedIn.value = prefs.getBool('isCheckedIn') ?? false;

    debugPrint("📦 Loaded last log => type:${selectedLogType.value}, checkedIn:${isCheckedIn.value}");
  }

  Future<void> fetchEmployees() async {
    try {
      isLoadingEmployees.value = true;

      const endpoint = 'api/resource/Employee';
      const fields = '["name","employee","employee_name"]';

      final response = await ApiService.get(
        endpoint,
        params: {'fields': fields, 'limit_page_length': '1000'},
      );

      if (response != null && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final employeeResponse = EmployeeListResponse.fromJson(responseData);

        employeeList.value = employeeResponse.data;
        if (employeeList.isNotEmpty) {
          currentemployee.value = employeeList.first.employee;
        }

        logger.d('✅ Current Employee: ${currentemployee.value}');
        logger.d('✅ Total Employees: ${employeeList.length}');
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

  void toggleLogType() {
    selectedLogType.value = selectedLogType.value == 'OUT' ? 'IN' : 'OUT';
    print("🔄 Current Log Type: ${selectedLogType.value}");
    _saveLastLog();
  }

  Future<void> createEmployeeCheckin() async {
    try {
      isSubmitting.value = true;
      final selectedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      dynamic response;

      final hasPermission = await LocationService.instance.checkPermission();
      if (hasPermission) {
        final location = await LocationService.instance.getCurrentLocation();
        print("📍 Current Location: $location");

        final requestBody = {
          'employee': currentemployee.value,
          'log_type': selectedLogType.value,
          'time': selectedTime,
          'device_id': 'WEB_APP',
          'latitude': location['latitude'],
          'location': location['location'],
        };

        print('📤 Creating checkin with data: $requestBody');

        response = await ApiService.post(
          'api/resource/Employee Checkin',
          data: requestBody,
        );
      } else {
        print("⚠️ Location permission not granted");
        Get.snackbar(
          'Permission Denied',
          'Please enable location services to create check-in',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      if (response != null) {
        print('✅ Employee checkin created successfully: ${response.data}');

        // Flip log type + persist
        toggleCheckInOut();

        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        Get.snackbar(
          'Success',
          'Employee checkin created successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await refreshData();
      } else {
        Get.snackbar(
          'Error',
          'Failed to create employee checkin',
          backgroundColor: Colors.grey,
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

  Future<void> fetchEmployeeCheckins({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final start = startDate ?? DateTime.now().subtract(const Duration(days: 7));
      final end = endDate ?? DateTime.now();

      final startDateStr = DateFormat('yyyy-MM-dd 00:00:00').format(start);
      final endDateStr = DateFormat('yyyy-MM-dd 23:59:59').format(end);

      const endpoint = 'api/resource/Employee%20Checkin';
      final filters = '[["time","between",["$startDateStr","$endDateStr"]]]';
      const fields = '["name","employee","employee_name","log_type","time","device_id"]';

      final response = await ApiService.get(
        endpoint,
        params: {'filters': filters, 'fields': fields, 'limit': '100'},
      );

      if (response != null && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;
        final checkinResponse = EmployeeCheckinResponse.fromJson(responseData);

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

  Future<void> refreshData() async {
    isRefreshing.value = true;
    checkinList.clear();
    update();
    await fetchEmployeeCheckins();
    isRefreshing.value = false;
  }

  final year = DateTime.now().year.obs;
  final month = DateTime.now().month.obs;
  final selectedDateIndex = (DateTime.now().day - 1).obs;

  void previousMonth() {
    if (month.value == 1) {
      month.value = 12;
      year.value--;
    } else {
      month.value--;
    }
    selectedDateIndex.value = 0;
  }

  void nextMonth() {
    if (month.value == 12) {
      month.value = 1;
      year.value++;
    } else {
      month.value++;
    }
    selectedDateIndex.value = 0;
  }

  void selectDate(int index) {
    selectedDateIndex.value = index;
  }

  int get daysInMonth => DateUtils.getDaysInMonth(year.value, month.value);

  String get monthName =>
      DateFormat('MMMM').format(DateTime(year.value, month.value, 1));

  void toggleCheckInOut() {
    isCheckedIn.value = !isCheckedIn.value;
    selectedLogType.value = isCheckedIn.value ? 'IN' : 'OUT';

    if (isCheckedIn.value) {
      print("✅ Checked In at ${DateTime.now()}");
    } else {
      print("⏹️ Checked Out at ${DateTime.now()}");
    }

    isFinished.value = true;
    _saveLastLog(); // persist state immediately
  }
}
