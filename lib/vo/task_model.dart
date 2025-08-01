class TaskModel {
  final String subject;
  final String status;
  final String assignedTo;
  final String project;
  final String? description;
  final String? expectedStartDate;
  final String? expectedEndDate;
  final String? priority;
  final double? percentComplete;
  final String? creation;
  final String? modified;

  TaskModel({
    required this.subject,
    required this.status,
    required this.assignedTo,
    required this.project,
    this.description,
    this.expectedStartDate,
    this.expectedEndDate,
    this.priority,
    this.percentComplete,
    this.creation,
    this.modified,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      subject: json['subject'] ?? '',
      status: json['status'] ?? '',
      assignedTo: json['assigned_to'] ?? json['allocated_to'] ?? '',
      project: json['project'] ?? '',
      description: json['description'],
      expectedStartDate: json['expected_start_date'],
      expectedEndDate: json['expected_end_date'],
      priority: json['priority'],
      percentComplete: (json['percent_complete'] ?? 0).toDouble(),
      creation: json['creation'],
      modified: json['modified'],
    );
  }
}
