import 'package:amax_hr/vo/task_model.dart';

class ProjectModel {
  String? name;
  String? status;
  String? expectedEndDate;
  double? percentComplete;
  List<TaskModel> taskList = [];

  ProjectModel({
    this.name,
    this.status,
    this.expectedEndDate,
    this.percentComplete,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      name: json['name'],
      status: json['status'],
      expectedEndDate: json['expected_end_date'],
      percentComplete: (json['percent_complete'] is num)
          ? (json['percent_complete'] as num).toDouble()
          : 0.0,
    );
  }
}
