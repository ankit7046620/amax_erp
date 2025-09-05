class AttendanceModel {
  final String name;
  final String owner;
  final String creation;
  final String modified;
  final String modifiedBy;
  final int docstatus;
  final int idx;
  final String namingSeries;
  final String employee;
  final String employeeName;
  final double workingHours;
  final String status;
  final String? leaveType;
  final String? leaveApplication;
  final String attendanceDate;
  final String company;
  final String? department;
  final String? attendanceRequest;
  final String? halfDayStatus;
  final String? shift;
  final String? inTime;
  final String? outTime;
  final int lateEntry;
  final int earlyExit;
  final String? amendedFrom;

  AttendanceModel({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.docstatus,
    required this.idx,
    required this.namingSeries,
    required this.employee,
    required this.employeeName,
    required this.workingHours,
    required this.status,
    this.leaveType,
    this.leaveApplication,
    required this.attendanceDate,
    required this.company,
    this.department,
    this.attendanceRequest,
    this.halfDayStatus,
    this.shift,
    this.inTime,
    this.outTime,
    required this.lateEntry,
    required this.earlyExit,
    this.amendedFrom,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      name: json['name'] ?? '',
      owner: json['owner'] ?? '',
      creation: json['creation'] ?? '',
      modified: json['modified'] ?? '',
      modifiedBy: json['modified_by'] ?? '',
      docstatus: json['docstatus'] ?? 0,
      idx: json['idx'] ?? 0,
      namingSeries: json['naming_series'] ?? '',
      employee: json['employee'] ?? '',
      employeeName: json['employee_name'] ?? '',
      workingHours: (json['working_hours'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      leaveType: json['leave_type'],
      leaveApplication: json['leave_application'],
      attendanceDate: json['attendance_date'] ?? '',
      company: json['company'] ?? '',
      department: json['department'],
      attendanceRequest: json['attendance_request'],
      halfDayStatus: json['half_day_status'],
      shift: json['shift'],
      inTime: json['in_time'],
      outTime: json['out_time'],
      lateEntry: json['late_entry'] ?? 0,
      earlyExit: json['early_exit'] ?? 0,
      amendedFrom: json['amended_from'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'creation': creation,
      'modified': modified,
      'modified_by': modifiedBy,
      'docstatus': docstatus,
      'idx': idx,
      'naming_series': namingSeries,
      'employee': employee,
      'employee_name': employeeName,
      'working_hours': workingHours,
      'status': status,
      'leave_type': leaveType,
      'leave_application': leaveApplication,
      'attendance_date': attendanceDate,
      'company': company,
      'department': department,
      'attendance_request': attendanceRequest,
      'half_day_status': halfDayStatus,
      'shift': shift,
      'in_time': inTime,
      'out_time': outTime,
      'late_entry': lateEntry,
      'early_exit': earlyExit,
      'amended_from': amendedFrom,
    };
  }
}