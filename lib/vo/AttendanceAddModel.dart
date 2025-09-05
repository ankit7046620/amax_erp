class AttendanceAddModel {
  final String name;  // This is the attendance ID (e.g., HR-ATT-2025-00044)
  final String employee;
  final String employeeName;
  final String attendanceDate;
  final String status;
  final double workingHours;
  final String? shift;
  final String? company;
  final String? leaveType;  // Leave type field
  final int lateEntry;
  final int earlyExit;
  final String modified;
  final String? halfDayDate;  // Half day period field

  AttendanceAddModel({
    required this.name,
    required this.employee,
    required this.employeeName,
    required this.attendanceDate,
    required this.status,
    required this.workingHours,
    this.shift,
    this.company,
    this.leaveType,
    required this.lateEntry,
    required this.earlyExit,
    required this.modified,
    this.halfDayDate,
  });

  factory AttendanceAddModel.fromJson(Map<String, dynamic> json) {
    return AttendanceAddModel(
      name: json['name'] ?? '',
      employee: json['employee'] ?? '',
      employeeName: json['employee_name'] ?? '',
      attendanceDate: json['attendance_date'] ?? '',
      status: json['status'] ?? '',
      workingHours: (json['working_hours'] ?? 0).toDouble(),
      shift: json['shift'],
      company: json['company'],
      leaveType: json['leave_type'],
      lateEntry: json['late_entry'] ?? 0,
      earlyExit: json['early_exit'] ?? 0,
      modified: json['modified'] ?? '',
      halfDayDate: json['half_day_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'employee': employee,
      'employee_name': employeeName,
      'attendance_date': attendanceDate,
      'status': status,
      'working_hours': workingHours,
      'shift': shift,
      'company': company,
      'leave_type': leaveType,
      'late_entry': lateEntry,
      'early_exit': earlyExit,
      'modified': modified,
      'half_day_date': halfDayDate,
    };
  }
}