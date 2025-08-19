class Event {
  String? name;             // comes in response
  String subject;
  String startsOn;
  String endsOn;
  String description;
  String eventType;
  String referenceDoctype;
  String referenceDocname;

  Event({
    this.name,
    required this.subject,
    required this.startsOn,
    required this.endsOn,
    required this.description,
    required this.eventType,
    required this.referenceDoctype,
    required this.referenceDocname,
  });

  /// Convert JSON → Dart object
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      subject: json['subject'],
      startsOn: json['starts_on'],
      endsOn: json['ends_on'],
      description: json['description'],
      eventType: json['event_type'],
      referenceDoctype: json['reference_doctype'] ?? json['ref_type'],
      referenceDocname: json['reference_docname'] ?? json['ref_name'],
    );
  }

  /// Convert Dart object → JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      if (name != null) "name": name,
      "subject": subject,
      "starts_on": startsOn,
      "ends_on": endsOn,
      "description": description,
      "event_type": eventType,
      "reference_doctype": referenceDoctype,
      "reference_docname": referenceDocname,
    };
  }
}
