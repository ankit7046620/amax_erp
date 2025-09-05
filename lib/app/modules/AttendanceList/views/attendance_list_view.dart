// import 'package:amax_hr/vo/AttendanceModel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/attendance_list_controller.dart';
//
// class AttendanceListView extends GetView<AttendanceListController> {
//   const AttendanceListView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           'Attendance',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: Colors.indigo.shade600,
//         elevation: 0,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () => controller.refreshData(),
//           ),
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: Colors.white),
//             onPressed: () => _showFilterBottomSheet(context),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Header section with search and stats
//           _buildHeaderSection(),
//
//           // Content
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     color: Color(0xFF2E7D32),
//                   ),
//                 );
//               }
//
//               if (controller.errorMessage.value.isNotEmpty) {
//                 return _buildErrorWidget();
//               }
//
//               if (controller.filteredAttendanceList.isEmpty) {
//                 return _buildEmptyWidget();
//               }
//
//               return _buildAttendanceList();
//             }),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Add attendance functionality
//           Get.snackbar(
//             'Info',
//             'Add attendance functionality to be implemented',
//             backgroundColor: Colors.white,
//             colorText: Colors.black,
//           );
//         },
//         backgroundColor: const Color(0xFF3949AB),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildHeaderSection() {
//     return Container(
//       color: const Color(0xFF3949AB),
//       child: Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               onChanged: controller.updateSearchQuery,
//               decoration: InputDecoration(
//                 hintText: 'Search employees...',
//                 hintStyle: TextStyle(color: Colors.grey[400]),
//                 prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               ),
//             ),
//           ),
//
//           // Stats row
//           Obx(() => Padding(
//             padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: _buildStatCard(
//                     'Total',
//                     controller.attendanceList.length.toString(),
//                     Icons.people,
//                     Colors.white,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildStatCard(
//                     'Present',
//                     controller.attendanceList
//                         .where((a) => a.status.toLowerCase() == 'present')
//                         .length
//                         .toString(),
//                     Icons.check_circle,
//                     Colors.green[100]!,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildStatCard(
//                     'On Leave',
//                     controller.attendanceList
//                         .where((a) => a.status.toLowerCase() == 'on leave')
//                         .length
//                         .toString(),
//                     Icons.time_to_leave,
//                     Colors.orange[100]!,
//                   ),
//                 ),
//               ],
//             ),
//           )),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCard(String title, String count, IconData icon, Color backgroundColor) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         children: [
//           Icon(icon, size: 24, color: const Color(0xFF2E7D32)),
//           const SizedBox(height: 4),
//           Text(
//             count,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF2E7D32),
//             ),
//           ),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAttendanceList() {
//     return Obx(() => RefreshIndicator(
//       onRefresh: controller.refreshData,
//       color: const Color(0xFF2E7D32),
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: controller.filteredAttendanceList.length,
//         itemBuilder: (context, index) {
//           final attendance = controller.filteredAttendanceList[index];
//           return _buildAttendanceCard(attendance, index);
//         },
//       ),
//     ));
//   }
//
//   Widget _buildAttendanceCard(AttendanceModel attendance, int index) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header row
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: controller.getStatusColor(attendance.status).withOpacity(0.1),
//                   child: Icon(
//                     controller.getStatusIcon(attendance.status),
//                     color: controller.getStatusColor(attendance.status),
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         attendance.employeeName,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         attendance.employee,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: controller.getStatusColor(attendance.status).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: controller.getStatusColor(attendance.status).withOpacity(0.3),
//                         ),
//                       ),
//                       child: Text(
//                         attendance.status,
//                         style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w500,
//                           color: controller.getStatusColor(attendance.status),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       controller.getTimeAgo(attendance.modified),
//                       style: TextStyle(
//                         fontSize: 10,
//                         color: Colors.grey[500],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 12),
//
//             // Details row
//             Row(
//               children: [
//                 _buildDetailItem(
//                   Icons.calendar_today,
//                   'Date',
//                   controller.formatDate(attendance.attendanceDate),
//                 ),
//                 const SizedBox(width: 20),
//                 _buildDetailItem(
//                   Icons.access_time,
//                   'Hours',
//                   '${attendance.workingHours.toStringAsFixed(1)}h',
//                 ),
//                 if (attendance.shift != null) ...[
//                   const SizedBox(width: 20),
//                   _buildDetailItem(
//                     Icons.work_outline,
//                     'Shift',
//                     attendance.shift!,
//                   ),
//                 ],
//               ],
//             ),
//
//             if (attendance.lateEntry == 1 || attendance.earlyExit == 1) ...[
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   if (attendance.lateEntry == 1)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.orange[50],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.orange[200]!),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.schedule, size: 12, color: Colors.orange[700]),
//                           const SizedBox(width: 4),
//                           Text(
//                             'Late Entry',
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.orange[700],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   if (attendance.lateEntry == 1 && attendance.earlyExit == 1)
//                     const SizedBox(width: 8),
//                   if (attendance.earlyExit == 1)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.red[50],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.red[200]!),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.exit_to_app, size: 12, color: Colors.red[700]),
//                           const SizedBox(width: 4),
//                           Text(
//                             'Early Exit',
//                             style: TextStyle(
//                               fontSize: 10,
//                               color: Colors.red[700],
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailItem(IconData icon, String label, String value) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 14, color: Colors.grey[600]),
//         const SizedBox(width: 4),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 10,
//                 color: Colors.grey[500],
//               ),
//             ),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildErrorWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
//           const SizedBox(height: 16),
//           Text(
//             'Oops! Something went wrong',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               controller.errorMessage.value,
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: controller.refreshData,
//             icon: const Icon(Icons.refresh),
//             label: const Text('Try Again'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF2E7D32),
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             'No attendance records found',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Pull down to refresh or check your filters',
//             style: TextStyle(color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showFilterBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Filter by Status',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Obx(() => Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: controller.statusOptions.map((status) {
//                 bool isSelected = controller.selectedStatus.value == status;
//                 return GestureDetector(
//                   onTap: () {
//                     controller.updateStatusFilter(status);
//                     Navigator.pop(context);
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[100],
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
//                       ),
//                     ),
//                     child: Text(
//                       status,
//                       style: TextStyle(
//                         color: isSelected ? Colors.white : Colors.grey[700],
//                         fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             )),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:amax_hr/vo/AttendanceAddModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_list_controller.dart';
import '../views/attendance_form_view.dart';

class AttendanceListView extends GetView<AttendanceListController> {
  const AttendanceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Attendance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.indigo.shade600,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.refreshData(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section with search and stats
          _buildHeaderSection(),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF2E7D32),
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return _buildErrorWidget();
              }

              if (controller.filteredAttendanceList.isEmpty) {
                return _buildEmptyWidget();
              }

              return _buildAttendanceList();
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.to(() => const AttendanceFormView());
          if (result == true) {
            controller.refreshData();
          }
        },
        backgroundColor: const Color(0xFF3949AB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      color: const Color(0xFF3949AB),
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search employees...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // Stats row
          Obx(() => Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    controller.attendanceList.length.toString(),
                    Icons.people,
                    Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Present',
                    controller.attendanceList
                        .where((a) => a.status.toLowerCase() == 'present')
                        .length
                        .toString(),
                    Icons.check_circle,
                    Colors.green[100]!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'On Leave',
                    controller.attendanceList
                        .where((a) => a.status.toLowerCase() == 'on leave')
                        .length
                        .toString(),
                    Icons.time_to_leave,
                    Colors.orange[100]!,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: const Color(0xFF2E7D32)),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList() {
    return Obx(() => RefreshIndicator(
      onRefresh: controller.refreshData,
      color: const Color(0xFF2E7D32),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredAttendanceList.length,
        itemBuilder: (context, index) {
          final attendance = controller.filteredAttendanceList[index];
          return _buildAttendanceCard(attendance, index);
        },
      ),
    ));
  }

  Widget _buildAttendanceCard(AttendanceAddModel attendance, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          // Navigate to edit form
          final result = await Get.to(
                () => const AttendanceFormView(),
            arguments: {'attendance': attendance},
          );
          if (result == true) {
            controller.refreshData();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: controller.getStatusColor(attendance.status).withOpacity(0.1),
                    child: Icon(
                      controller.getStatusIcon(attendance.status),
                      color: controller.getStatusColor(attendance.status),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attendance.employeeName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          attendance.employee,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: controller.getStatusColor(attendance.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller.getStatusColor(attendance.status).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          attendance.status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: controller.getStatusColor(attendance.status),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.getTimeAgo(attendance.modified),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Details row
              Row(
                children: [
                  _buildDetailItem(
                    Icons.calendar_today,
                    'Date',
                    controller.formatDate(attendance.attendanceDate),
                  ),
                  const SizedBox(width: 20),
                  _buildDetailItem(
                    Icons.access_time,
                    'Hours',
                    '${attendance.workingHours.toStringAsFixed(1)}h',
                  ),
                  if (attendance.shift != null) ...[
                    const SizedBox(width: 20),
                    _buildDetailItem(
                      Icons.work_outline,
                      'Shift',
                      attendance.shift!,
                    ),
                  ],
                ],
              ),

              // Leave Type row (if applicable)
              if (attendance.leaveType != null && attendance.leaveType!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildDetailItem(
                      Icons.event_note,
                      'Leave Type',
                      attendance.leaveType!,
                    ),
                  ],
                ),
              ],

              // Half Day Period row (if applicable)
              if (attendance.halfDayDate != null && attendance.halfDayDate!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildDetailItem(
                      Icons.schedule,
                      'Half Day Period',
                      attendance.halfDayDate!,
                    ),
                  ],
                ),
              ],

              if (attendance.lateEntry == 1 || attendance.earlyExit == 1) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (attendance.lateEntry == 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.schedule, size: 12, color: Colors.orange[700]),
                            const SizedBox(width: 4),
                            Text(
                              'Late Entry',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (attendance.lateEntry == 1 && attendance.earlyExit == 1)
                      const SizedBox(width: 8),
                    if (attendance.earlyExit == 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.exit_to_app, size: 12, color: Colors.red[700]),
                            const SizedBox(width: 4),
                            Text(
                              'Early Exit',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No attendance records found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pull down to refresh or check your filters',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.statusOptions.map((status) {
                bool isSelected = controller.selectedStatus.value == status;
                return GestureDetector(
                  onTap: () {
                    controller.updateStatusFilter(status);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}