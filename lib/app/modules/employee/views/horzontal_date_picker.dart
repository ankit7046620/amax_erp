import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/employee_controller.dart';

class HorizontalCalendar extends StatefulWidget {
  HorizontalCalendar({Key? key}) : super(key: key);

  @override
  _HorizontalCalendarState createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  final EmployeeController controller = Get.find<EmployeeController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selected = controller.selectedDateIndex.value;
      // Scroll so selected date is centered or visible
      final position = selected * 68.0; // width (58) + spacing (10)
      scrollController.jumpTo(position);
    });
  }

  List<_CalendarDay> _generateDays() {
    List<_CalendarDay> days = [];
    int totalDays = controller.daysInMonth;
    for (int i = 1; i <= totalDays; i++) {
      final date = DateTime(controller.year.value, controller.month.value, i);
      final weekDay = DateFormat('E').format(date);
      days.add(_CalendarDay(day: i.toString().padLeft(2, '0'), weekDay: weekDay));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final days = _generateDays();
      final selectedIndex = controller.selectedDateIndex.value;

      return SizedBox(
        height: 60,
        child: ListView.separated(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: days.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex;
            final day = days[index];
            return GestureDetector(
              onTap: () => controller.selectDate(index),
              child: Container(
                width: 58,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.07),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day.day,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.weekDay,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _CalendarDay {
  final String day;
  final String weekDay;

  _CalendarDay({required this.day, required this.weekDay});
}
