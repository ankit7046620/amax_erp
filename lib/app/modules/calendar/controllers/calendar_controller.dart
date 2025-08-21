import 'package:amax_hr/vo/crm_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarController extends GetxController {
  var events = <Appointment>[].obs;
  late String screenName;
  dynamic data;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _loadDummyEvents();
  // }


  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      screenName = args['screen'] ?? '';
      data = args['data'];

      debugPrint("Calendar opened from: $screenName");

      if (screenName == "LeadScreen") {
        debugPrint("Loading events for leads...#${data}");
        // 👉 Apply condition for leads
       _loadLeadEvents(data);
      } else {
        // 👉 Default events

      }
    }
  }



  void _loadLeadEvents(List<CrmModel> leads) {
    events.assignAll(leads.map<Appointment>((lead) {
      return Appointment(
        startTime: DateTime.parse(lead.creation), // assuming String date
        endTime: DateTime.parse(lead.creation).add(const Duration(hours: 1)),
        subject: lead.leadName ?? 'Lead',
        color: Colors.green,
        isAllDay: false,
      );
    }).toList());
  }

}


//   void _loadDummyEvents() {
//     final now = DateTime.now();
//     final currentYear = now.year;
//     final currentMonth = now.month;
//
//     events.assignAll([
//       Appointment(
//         startTime: DateTime(currentYear, currentMonth, 3, 9, 0),
//         endTime: DateTime(currentYear, currentMonth, 3, 10, 0),
//         subject: 'Team Stand-up Meeting',
//         color: Colors.blue,
//         isAllDay: false,
//       ),
//       Appointment(
//         startTime: DateTime(currentYear, currentMonth, 10),
//         endTime: DateTime(currentYear, currentMonth, 10),
//         subject: 'Public Holiday',
//         color: Colors.red,
//         isAllDay: true,
//       ),
//       Appointment(
//         startTime: DateTime(currentYear, currentMonth, 18, 18, 0),
//         endTime: DateTime(currentYear, currentMonth, 18, 20, 0),
//         subject: 'Client Presentation',
//         color: Colors.orange,
//         isAllDay: false,
//       ),
//     ]);
//     update();
//   }
//
// }

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
