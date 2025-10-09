// // vo/employee_checkin_model.dart
// class EmployeeCheckin {
//   final String name;
//   final String employee;
//   final String employeeName;
//   final String logType;
//   final String time;
//   final String deviceId;
//
//   EmployeeCheckin({
//     required this.name,
//     required this.employee,
//     required this.employeeName,
//     required this.logType,
//     required this.time,
//     required this.deviceId,
//   });
//
//   factory EmployeeCheckin.fromJson(Map<String, dynamic> json) {
//     return EmployeeCheckin(
//       name: json['name']?.toString() ?? '',
//       employee: json['employee']?.toString() ?? '',
//       employeeName: json['employee_name']?.toString() ?? '',
//       logType: json['log_type']?.toString() ?? '',
//       time: json['time']?.toString() ?? '',
//       deviceId: json['device_id']?.toString() ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'employee': employee,
//       'employee_name': employeeName,
//       'log_type': logType,
//       'time': time,
//       'device_id': deviceId,
//     };
//   }
//
//   @override
//   String toString() {
//     return 'EmployeeCheckin{name: $name, employee: $employee, employeeName: $employeeName, logType: $logType, time: $time, deviceId: $deviceId}';
//   }
// }
//
// class EmployeeCheckinResponse {
//   final List<EmployeeCheckin> data;
//   final String? message;
//
//   EmployeeCheckinResponse({
//     required this.data,
//     this.message,
//   });
//
//   factory EmployeeCheckinResponse.fromJson(Map<String, dynamic> json) {
//     try {
//       // Handle different response structures
//       List<dynamic> dataList = [];
//
//       if (json.containsKey('data') && json['data'] is List) {
//         dataList = json['data'] as List;
//       } else if (json.containsKey('message') && json['message'] is List) {
//         dataList = json['message'] as List;
//       } else if (json is List) {
//         dataList = json as List;
//       } else {
//         print('⚠️ Unexpected JSON structure: $json');
//         dataList = [];
//       }
//
//       List<EmployeeCheckin> checkins = dataList
//           .map((item) {
//         try {
//           if (item is Map<String, dynamic>) {
//             return EmployeeCheckin.fromJson(item);
//           } else {
//             print('⚠️ Invalid item format: $item');
//             return null;
//           }
//         } catch (e) {
//           print('❌ Error parsing checkin item: $e');
//           return null;
//         }
//       })
//           .where((item) => item != null)
//           .cast<EmployeeCheckin>()
//           .toList();
//
//       return EmployeeCheckinResponse(
//         data: checkins,
//         message: json['message']?.toString(),
//       );
//     } catch (e) {
//       print('❌ Error parsing EmployeeCheckinResponse: $e');
//       return EmployeeCheckinResponse(
//         data: [],
//         message: 'Error parsing response: $e',
//       );
//     }
//   }
//
//   @override
//   String toString() {
//     return 'EmployeeCheckinResponse{data: ${data.length} items, message: $message}';
//   }
// }

// vo/employee_checkin_model.dart
class EmployeeCheckin {
  final String name;
  final String employee;
  final String employeeName;
  final String logType;
  final String time;
  final String deviceId;

  // Added location fields for geofencing support
  final String? latitude;
  final String? longitude;
  final String? location;
  final String? officeName;
  final bool? geofenceValidated;
  final int? distanceFromOffice;

  EmployeeCheckin({
    required this.name,
    required this.employee,
    required this.employeeName,
    required this.logType,
    required this.time,
    required this.deviceId,
    // Optional location parameters
    this.latitude,
    this.longitude,
    this.location,
    this.officeName,
    this.geofenceValidated,
    this.distanceFromOffice,
  });

  factory EmployeeCheckin.fromJson(Map<String, dynamic> json) {
    return EmployeeCheckin(
      name: json['name']?.toString() ?? '',
      employee: json['employee']?.toString() ?? '',
      employeeName: json['employee_name']?.toString() ?? '',
      logType: json['log_type']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      deviceId: json['device_id']?.toString() ?? '',
      // Handle location fields with null safety
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      location: json['location']?.toString(),
      officeName: json['office_name']?.toString(),
      geofenceValidated: json['geofence_validated'] == 1 ||
          json['geofence_validated'] == true,
      distanceFromOffice: json['distance_from_office'] is int
          ? json['distance_from_office']
          : (json['distance_from_office'] is String
          ? int.tryParse(json['distance_from_office'])
          : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'employee': employee,
      'employee_name': employeeName,
      'log_type': logType,
      'time': time,
      'device_id': deviceId,
      'latitude': latitude,
      'longitude': longitude,
      'location': location,
      'office_name': officeName,
      'geofence_validated': geofenceValidated,
      'distance_from_office': distanceFromOffice,
    };
  }

  // Helper method to check if location data is available
  bool hasLocationData() {
    return latitude?.isNotEmpty == true && longitude?.isNotEmpty == true;
  }

  // Helper method to get formatted coordinates
  String getFormattedCoordinates() {
    if (!hasLocationData()) return 'No location data';
    try {
      double lat = double.parse(latitude!);
      double lng = double.parse(longitude!);
      return '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';
    } catch (e) {
      return 'Invalid coordinates';
    }
  }

  // Helper method to check if this is a geofenced entry
  bool isGeofenced() {
    return geofenceValidated == true ||
        deviceId.contains('GEOFENCED') ||
        location?.contains('Office') == true;
  }

  @override
  String toString() {
    return 'EmployeeCheckin{name: $name, employee: $employee, employeeName: $employeeName, logType: $logType, time: $time, deviceId: $deviceId, location: $location, geofenced: ${isGeofenced()}}';
  }
}

class EmployeeCheckinResponse {
  final List<EmployeeCheckin> data;
  final String? message;

  EmployeeCheckinResponse({
    required this.data,
    this.message,
  });

  factory EmployeeCheckinResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Handle different response structures
      List<dynamic> dataList = [];

      if (json.containsKey('data') && json['data'] is List) {
        dataList = json['data'] as List;
      } else if (json.containsKey('message') && json['message'] is List) {
        dataList = json['message'] as List;
      } else if (json is List) {
        dataList = json as List;
      } else {
        print('⚠️ Unexpected JSON structure: $json');
        dataList = [];
      }

      List<EmployeeCheckin> checkins = dataList
          .map((item) {
        try {
          if (item is Map<String, dynamic>) {
            return EmployeeCheckin.fromJson(item);
          } else {
            print('⚠️ Invalid item format: $item');
            return null;
          }
        } catch (e) {
          print('❌ Error parsing checkin item: $e');
          return null;
        }
      })
          .where((item) => item != null)
          .cast<EmployeeCheckin>()
          .toList();

      return EmployeeCheckinResponse(
        data: checkins,
        message: json['message']?.toString(),
      );
    } catch (e) {
      print('❌ Error parsing EmployeeCheckinResponse: $e');
      return EmployeeCheckinResponse(
        data: [],
        message: 'Error parsing response: $e',
      );
    }
  }

  @override
  String toString() {
    return 'EmployeeCheckinResponse{data: ${data.length} items, message: $message}';
  }
}