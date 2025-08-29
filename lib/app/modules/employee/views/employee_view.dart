import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../../../constant/assets_constant.dart';
import '../controllers/employee_controller.dart';
import 'horzontal_date_picker.dart';

class EmployeeView extends GetView<EmployeeController> {
  EmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EmployeeController());

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            const ProfileHeader(),

            /// Month navigation + calendar bar
            Obx(() => Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left,
                            color: Colors.black87, size: 26),
                        onPressed: c.previousMonth,
                      ),
                      Text(
                        '${c.monthName} ${c.year.value}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.black87, size: 26),
                        onPressed: c.nextMonth,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60, child: HorizontalCalendar()),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 16, top: 8, bottom: 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      backgroundColor: Colors.blue.shade50,
                      label: Text(
                        'Selected: ${c.selectedDateIndex.value + 1} ${c.monthName} ${c.year.value}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),

            /// Attendance summary in grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() {
                return GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                  children: [
                    SummaryCard(
                      color: Colors.green,
                      icon: Icons.login,
                      title: "Check In",
                      value: c.checkinList.isNotEmpty
                          ? c.checkinList
                          .firstWhereOrNull((e) => e.logType == "IN")
                          ?.time ??
                          "--:--"
                          : "--:--",
                      subtitle: "Today",
                    ),
                    SummaryCard(
                      color: Colors.red,
                      icon: Icons.logout,
                      title: "Check Out",
                      value: c.checkinList.isNotEmpty
                          ? c.checkinList
                          .firstWhereOrNull((e) => e.logType == "OUT")
                          ?.time ??
                          "--:--"
                          : "--:--",
                      subtitle: "Last",
                    ),
                    const SummaryCard(
                      color: Colors.amber,
                      icon: Icons.timer,
                      title: "Break Time",
                      value: "00:30",
                      subtitle: "Avg 30m",
                    ),
                    SummaryCard(
                      color: Colors.blue,
                      icon: Icons.calendar_today,
                      title: "Days Worked",
                      value: c.checkinList.length.toString(),
                      subtitle: "This Month",
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 10),

            /// Activities + Swipe button
            Expanded(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    /// Activity header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Activity",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("View All",
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),

                    /// Activity timeline
                    // Expanded(
                    //   child: Obx(() {
                    //     if (c.checkinList.isEmpty) {
                    //       return const Center(
                    //         child: Text(
                    //           "No activity yet",
                    //           style: TextStyle(color: Colors.grey),
                    //         ),
                    //       );
                    //     }
                    //     return ListView.separated(
                    //       separatorBuilder: (_, __) =>
                    //           Divider(height: 1, color: Colors.grey.shade200),
                    //       itemCount: c.checkinList.length.clamp(0, 4),
                    //       itemBuilder: (context, index) {
                    //         final item = c.checkinList[index];
                    //         final isIn = item.logType == "IN";
                    //         final color = isIn
                    //             ? Colors.green.shade700
                    //             : Colors.red.shade700;
                    //         return ListTile(
                    //           leading: CircleAvatar(
                    //             backgroundColor: color.withOpacity(0.15),
                    //             child: Icon(
                    //               isIn ? Icons.login : Icons.logout,
                    //               color: color,
                    //             ),
                    //           ),
                    //           title: Text(item.logType,
                    //               style: TextStyle(
                    //                   color: color,
                    //                   fontWeight: FontWeight.w600)),
                    //           trailing: Text(item.time,
                    //               style: const TextStyle(
                    //                   color: Colors.black54, fontSize: 13)),
                    //         );
                    //       },
                    //     );
                    //   }),
                    // ),
  
                    /// Swipe button at bottom
                    Obx(() {
                      final isIn = c.isCheckedIn.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10, top: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: SwipeableButtonView(
                          buttonText: isIn
                              ? "Swipe to Check Out"
                              : "Swipe to Check In",
                          buttonWidget: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          activeColor:
                          isIn ? Colors.red.shade600 : Colors.green.shade600,
                          isFinished: c.isFinished.value,
                          onWaitingProcess: () async {
                            await c.createEmployeeCheckin();
                            await Future.delayed(
                                const Duration(milliseconds: 600));
                            c.isFinished.value = true;
                          },
                          onFinish: () {
                            Future.delayed(const Duration(milliseconds: 400),
                                    () {
                                  c.isFinished.value = false;
                                });
                          },
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Summary card (grid item)
class SummaryCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const SummaryCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.10), color.withOpacity(0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(title,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 6),
          FittedBox(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 12, color: Colors.black54, height: 1.3)),
        ],
      ),
    );
  }
}

/// Profile header
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(AssetsConstant.tech_logo),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Michael Mitc",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Lead UI/UX Designer",
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              )
            ],
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none,
                  color: Colors.white, size: 26))
        ],
      ),
    );
  }
}
