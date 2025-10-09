import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Holiday {
  final String name;
  final String fromDate;
  final String toDate;
  final String imageUpload;

  Holiday({
    required this.name,
    required this.fromDate,
    required this.toDate,
    required this.imageUpload,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      name: json['name'] ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      imageUpload: json['image_upload'] ?? '',
    );
  }
}

class HolidayListController extends GetxController {
  final holidays = <Holiday>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Base URL for your API
  static const String baseUrl = 'https://plastic.techcloudamax.ai';

  @override
  void onInit() {
    super.onInit();
    fetchHolidays();
  }

  Future<void> fetchHolidays() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/resource/Holiday List?fields=["name","from_date","to_date","image_upload"]&limit_page_length=0'
        ),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'sid=92b8b77357fc97bed5e27e86cd1151248a3eea8592d20aea1c627213; full_name=Vignesh; system_user=yes; user_id=vignesh%40amaxconsultancyservices.com; system_user=yes; user_image=; full_name=Vignesh; sid=92b8b77357fc97bed5e27e86cd1151248a3eea8592d20aea1c627213; system_user=yes; user_id=vignesh%40amaxconsultancyservices.com; user_image='
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> holidayData = jsonData['data'] ?? [];

        holidays.value = holidayData
            .map((json) => Holiday.fromJson(json))
            .toList();
      } else {
        errorMessage.value = 'Failed to load holidays: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshHolidays() async {
    await fetchHolidays();
  }

  String formatDate(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  int getDaysDifference(String fromDate, String toDate) {
    try {
      final DateTime from = DateTime.parse(fromDate);
      final DateTime to = DateTime.parse(toDate);
      return to.difference(from).inDays + 1;
    } catch (e) {
      return 1;
    }
  }

  bool isUpcoming(String fromDate) {
    try {
      final DateTime holiday = DateTime.parse(fromDate);
      final DateTime now = DateTime.now();
      return holiday.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  /// Constructs the full image URL from the image_upload field
  String getFullImageUrl(String imageUpload) {
    if (imageUpload.isEmpty) return '';

    // If the imageUpload already contains a full URL, return as is
    if (imageUpload.startsWith('http://') || imageUpload.startsWith('https://')) {
      return imageUpload;
    }

    // If it's a relative path, construct the full URL
    if (imageUpload.startsWith('/')) {
      return '$baseUrl$imageUpload';
    }

    // If it's just a filename or path without leading slash
    return '$baseUrl/$imageUpload';
  }

  /// Format holiday date range for display
  String getDateRange(Holiday holiday) {
    if (holiday.fromDate == holiday.toDate) {
      return formatDate(holiday.fromDate);
    }
    return '${formatDate(holiday.fromDate)} - ${formatDate(holiday.toDate)}';
  }

  /// Get days until the holiday
  int getDaysUntilHoliday(String fromDate) {
    try {
      final DateTime holiday = DateTime.parse(fromDate);
      final DateTime now = DateTime.now();
      final DateTime todayStart = DateTime(now.year, now.month, now.day);
      final DateTime holidayStart = DateTime(holiday.year, holiday.month, holiday.day);

      return holidayStart.difference(todayStart).inDays;
    } catch (e) {
      return -1;
    }
  }

  /// Check if holiday is today
  bool isToday(String fromDate) {
    try {
      final DateTime holiday = DateTime.parse(fromDate);
      final DateTime now = DateTime.now();

      return holiday.year == now.year &&
          holiday.month == now.month &&
          holiday.day == now.day;
    } catch (e) {
      return false;
    }
  }

  /// Check if holiday is in progress (multi-day holiday)
  bool isInProgress(String fromDate, String toDate) {
    try {
      final DateTime from = DateTime.parse(fromDate);
      final DateTime to = DateTime.parse(toDate);
      final DateTime now = DateTime.now();

      return now.isAfter(from) && now.isBefore(to.add(const Duration(days: 1)));
    } catch (e) {
      return false;
    }
  }
}