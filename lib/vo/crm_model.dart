class CrmModel {
  List<Data> data;

  CrmModel({required this.data});

  factory CrmModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<Data> parsedData = [];

    if (rawData != null && rawData is List) {
      parsedData = rawData
          .where((item) => item != null)
          .map<Data>((item) => Data.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return CrmModel(data: parsedData);
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((v) => v.toJson()).toList(),
    };
  }
}

class Data {
  String name;
  String leadName;
  String emailId;
  String companyName;
  String status;
  String creation;
  String modified;
  String source;
  String territory;

  Data({
    required this.name,
    required this.leadName,
    required this.emailId,
    required this.companyName,
    required this.status,
    required this.creation,
    required this.modified,
    required this.source,
    required this.territory,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['name'] ?? '',
      leadName: json['lead_name'] ?? '',
      emailId: json['email_id'] ?? '',
      companyName: json['company_name'] ?? '',
      status: json['status'] ?? '',
      creation: json['creation'] ?? '',
      modified: json['modified'] ?? '',
      source: json['source'] ?? '',
      territory: json['territory'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lead_name': leadName,
      'email_id': emailId,
      'company_name': companyName,
      'status': status,
      'creation': creation,
      'modified': modified,
      'source': source,
      'territory': territory,
    };
  }
}
