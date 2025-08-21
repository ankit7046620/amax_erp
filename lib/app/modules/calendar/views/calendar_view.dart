import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfcalendar;
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CalendarController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📅 Calendar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0093E9), Color(0xFF80D0C7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF7F9FC),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: sfcalendar.SfCalendar(
                view: sfcalendar.CalendarView.month,
                dataSource: EventDataSource(controller.events.toList()),

                // 📌 Styling the calendar
                todayHighlightColor: Colors.orange,
                headerStyle: const sfcalendar.CalendarHeaderStyle(
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                viewHeaderStyle: const sfcalendar.ViewHeaderStyle(
                  dayTextStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),

                monthViewSettings: const sfcalendar.MonthViewSettings(
                  showAgenda: true,
                  agendaStyle: sfcalendar.AgendaStyle(
                    appointmentTextStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    dateTextStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    dayTextStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  appointmentDisplayMode:
                  sfcalendar.MonthAppointmentDisplayMode.appointment,
                  agendaViewHeight: 220,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
