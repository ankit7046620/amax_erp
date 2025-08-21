// // views/employee_checkin_view.dart
// import 'package:amax_hr/app/modules/EmployeeCheckin/controllers/employee_checkin_controller.dart';
// import 'package:amax_hr/vo/employee_checkin_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class EmployeeCheckinView extends GetView<EmployeeCheckinController> {
//   const EmployeeCheckinView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           'Employee Checkin',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.indigo.shade600,
//         elevation: 0,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: Colors.white),
//             onPressed: () => _showFilterDialog(context),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () => controller.refreshData(),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Date Filter Header
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.indigo.shade600,
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Call the popup method from controller
//                     controller.showNewCheckinPopup();
//                   },
//                   icon: const Icon(Icons.person_add_alt_1, size: 18),
//                   label: const Text('Attendance'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.blue[700],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//                 Obx(() => ElevatedButton.icon(
//                   onPressed: () => _selectDate(context),
//                   icon: const Icon(Icons.calendar_today, size: 18),
//                   label: Text(DateFormat('dd MMM yyyy').format(controller.selectedDate.value),),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.blue[700],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),),
//
//               ],
//             ),
//           ),
//
//           // Statistics Cards
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Obx(() => Column(
//               children: [
//                 // First row with existing statistics
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildStatCard(
//                         'Total Entries',
//                         controller.checkinList.length.toString(),
//                         Icons.list_alt,
//                         Colors.blue,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildStatCard(
//                         'Check In',
//                         controller.checkinList
//                             .where((item) => item.logType.toUpperCase() == 'IN')
//                             .length
//                             .toString(),
//                         Icons.login,
//                         Colors.green,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildStatCard(
//                         'Check Out',
//                         controller.checkinList
//                             .where((item) => item.logType.toUpperCase() == 'OUT')
//                             .length
//                             .toString(),
//                         Icons.logout,
//                         Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 // Second row with new Early Checkout and Check-in buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildClickableStatCard(
//                         'Early Checkout',
//                         _getEarlyCheckoutCount().toString(),
//                         Icons.schedule,
//                         Colors.orange,
//                             () => _showEarlyCheckoutList(context),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildClickableStatCard(
//                         'Early Check-in',
//                         _getTodayCheckInCount().toString(),
//                         Icons.login,
//                         Colors.purple,
//                             () => _showTodayCheckInList(context),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             )),
//           ),
//
//           // Checkin List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//
//               if (controller.errorMessage.value.isNotEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 64,
//                         color: Colors.red[300],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         controller.errorMessage.value,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.red[600],
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton.icon(
//                         onPressed: () => controller.fetchEmployeeCheckins(),
//                         icon: const Icon(Icons.refresh),
//                         label: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//
//               if (controller.checkinList.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/data_not_found.gif',
//                         fit: BoxFit.contain,
//                         // Optional: tint if needed
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         'No checkin records found',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.indigo[900],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Try selecting a different date range',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.indigo[900],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//
//               // Group checkins by employee name
//               Map<String, List<EmployeeCheckin>> groupedCheckins = _groupCheckinsByEmployee();
//
//               return RefreshIndicator(
//                 onRefresh: () => controller.refreshData(),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: groupedCheckins.keys.length,
//                   itemBuilder: (context, index) {
//                     String employeeName = groupedCheckins.keys.elementAt(index);
//                     List<EmployeeCheckin> employeeCheckins = groupedCheckins[employeeName]!;
//                     return _buildGroupedCheckinCard(employeeName, employeeCheckins);
//                   },
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Get early checkout count (checkout before 6:30 PM)
//   int _getEarlyCheckoutCount() {
//     int count = 0;
//     for (var checkin in controller.checkinList) {
//       if (checkin.logType.toUpperCase() == 'OUT') {
//         try {
//           DateTime checkoutTime = DateTime.parse(checkin.time);
//           // Check if checkout is before 6:30 PM (18:30)
//           DateTime officialOutTime = DateTime(
//             checkoutTime.year,
//             checkoutTime.month,
//             checkoutTime.day,
//             18,
//             30,
//           );
//           if (checkoutTime.isBefore(officialOutTime)) {
//             count++;
//           }
//         } catch (e) {
//           // Skip if time parsing fails
//         }
//       }
//     }
//     return count;
//   }
//
//   // Get today's check-in count
//   int _getTodayCheckInCount() {
//     String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     return controller.checkinList
//         .where((item) =>
//     item.logType.toUpperCase() == 'IN' &&
//         item.time.startsWith(today))
//         .length;
//   }
//
//   // Get early checkout employees list
//   List<EmployeeCheckin> _getEarlyCheckoutEmployees() {
//     List<EmployeeCheckin> earlyCheckouts = [];
//     for (var checkin in controller.checkinList) {
//       if (checkin.logType.toUpperCase() == 'OUT') {
//         try {
//           DateTime checkoutTime = DateTime.parse(checkin.time);
//           DateTime officialOutTime = DateTime(
//             checkoutTime.year,
//             checkoutTime.month,
//             checkoutTime.day,
//             18,
//             30,
//           );
//           if (checkoutTime.isBefore(officialOutTime)) {
//             earlyCheckouts.add(checkin);
//           }
//         } catch (e) {
//           // Skip if time parsing fails
//         }
//       }
//     }
//     return earlyCheckouts;
//   }
//
//   // Get today's check-in employees list
//   List<EmployeeCheckin> _getTodayCheckInEmployees() {
//     String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     return controller.checkinList
//         .where((item) =>
//     item.logType.toUpperCase() == 'IN' &&
//         item.time.startsWith(today))
//         .toList();
//   }
//
//   // Show early checkout list dialog
//   void _showEarlyCheckoutList(BuildContext context) {
//     List<EmployeeCheckin> earlyCheckouts = _getEarlyCheckoutEmployees();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Container(
//             width: Get.width * 0.9,
//             constraints: BoxConstraints(
//               maxHeight: Get.height * 0.7,
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.schedule, color: Colors.orange, size: 24),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Early Checkout Employees',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.orange[700],
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Employees who checked out before 6:30 PM',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Divider(),
//                 Expanded(
//                   child: earlyCheckouts.isEmpty
//                       ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.check_circle,
//                           size: 64,
//                           color: Colors.green[300],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No early checkouts found!',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                       : ListView.builder(
//                     itemCount: earlyCheckouts.length,
//                     itemBuilder: (context, index) {
//                       final checkin = earlyCheckouts[index];
//                       return _buildEmployeeListTile(checkin, Colors.orange);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Show today's check-in list dialog
//   void _showTodayCheckInList(BuildContext context) {
//     List<EmployeeCheckin> todayCheckIns = _getTodayCheckInEmployees();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Container(
//             width: Get.width * 0.9,
//             constraints: BoxConstraints(
//               maxHeight: Get.height * 0.7,
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.login, color: Colors.purple, size: 24),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Today\'s Check-in Employees',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.purple[700],
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Employees who checked in today',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Divider(),
//                 Expanded(
//                   child: todayCheckIns.isEmpty
//                       ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.info,
//                           size: 64,
//                           color: Colors.grey[300],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No check-ins found for today!',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                       : ListView.builder(
//                     itemCount: todayCheckIns.length,
//                     itemBuilder: (context, index) {
//                       final checkin = todayCheckIns[index];
//                       return _buildEmployeeListTile(checkin, Colors.purple);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Build employee list tile for dialogs
//   Widget _buildEmployeeListTile(EmployeeCheckin checkin, Color color) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: color.withOpacity(0.2),
//           child: Text(
//             checkin.employeeName.isNotEmpty
//                 ? checkin.employeeName[0].toUpperCase()
//                 : 'U',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ),
//         title: Text(
//           checkin.employeeName.isNotEmpty
//               ? checkin.employeeName
//               : 'Unknown Employee',
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//           ),
//         ),
//         subtitle: Text(
//           '${checkin.logType.toUpperCase()} at ${_getFormattedTime(checkin.time)}',
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//           ),
//         ),
//         trailing: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Text(
//             checkin.logType.toUpperCase(),
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.bold,
//               fontSize: 10,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Group checkins by employee name
//   Map<String, List<EmployeeCheckin>> _groupCheckinsByEmployee() {
//     Map<String, List<EmployeeCheckin>> grouped = {};
//
//     for (var checkin in controller.checkinList) {
//       String employeeName = checkin.employeeName.isNotEmpty ? checkin.employeeName : 'Unknown Employee';
//
//       if (grouped[employeeName] == null) {
//         grouped[employeeName] = [];
//       }
//       grouped[employeeName]!.add(checkin);
//     }
//
//     // Sort each employee's checkins by time
//     grouped.forEach((key, value) {
//       value.sort((a, b) => a.time.compareTo(b.time));
//     });
//
//     return grouped;
//   }
//
//   Widget _buildGroupedCheckinCard(String employeeName, List<EmployeeCheckin> checkins) {
//     // Separate IN and OUT entries
//     List<EmployeeCheckin> checkIns = checkins.where((c) => c.logType.toUpperCase() == 'IN').toList();
//     List<EmployeeCheckin> checkOuts = checkins.where((c) => c.logType.toUpperCase() == 'OUT').toList();
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Employee Name Header
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.indigo.shade100,
//                   radius: 20,
//                   child: Text(
//                     employeeName.isNotEmpty ? employeeName[0].toUpperCase() : 'U',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.indigo.shade700,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         employeeName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       Text(
//                         '${checkins.length} entries',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Status badges
//                 if (checkIns.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     margin: const EdgeInsets.only(right: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       'IN: ${checkIns.length}',
//                       style: const TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 10,
//                       ),
//                     ),
//                   ),
//                 if (checkOuts.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       'OUT: ${checkOuts.length}',
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 10,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//
//             const SizedBox(height: 12),
//             const Divider(height: 1),
//             const SizedBox(height: 12),
//
//             // Check-in and Check-out times in rows
//             Row(
//               children: [
//                 // Check In Column
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.login, size: 16, color: Colors.green),
//                           const SizedBox(width: 6),
//                           Text(
//                             'Check In',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.green,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       if (checkIns.isNotEmpty)
//                         ...checkIns.map((checkin) => Padding(
//                           padding: const EdgeInsets.only(bottom: 4),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 _getFormattedTime(checkin.time),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 13,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               if (checkin.deviceId.isNotEmpty)
//                                 Text(
//                                   'Device: ${checkin.deviceId}',
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         )).toList()
//                       else
//                         Text(
//                           'No check-in',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[500],
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//
//                 // Vertical divider
//                 Container(
//                   height: 50,
//                   width: 1,
//                   color: Colors.grey[300],
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                 ),
//
//                 // Check Out Column
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.logout, size: 16, color: Colors.red),
//                           const SizedBox(width: 6),
//                           Text(
//                             'Check Out',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.red,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       if (checkOuts.isNotEmpty)
//                         ...checkOuts.map((checkin) => Padding(
//                           padding: const EdgeInsets.only(bottom: 4),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 _getFormattedTime(checkin.time),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 13,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               if (checkin.deviceId.isNotEmpty)
//                                 Text(
//                                   'Device: ${checkin.deviceId}',
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         )).toList()
//                       else
//                         Text(
//                           'No check-out',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[500],
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             // Working duration (if both check-in and check-out exist)
//             if (checkIns.isNotEmpty && checkOuts.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 12),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.access_time, size: 14, color: Colors.blue[700]),
//                       const SizedBox(width: 6),
//                       Text(
//                         'Duration: ${_calculateDuration(checkIns.first, checkOuts.last)}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.blue[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getFormattedTime(String timeString) {
//     try {
//       DateTime dateTime = DateTime.parse(timeString);
//       return DateFormat('HH:mm').format(dateTime);
//     } catch (e) {
//       return timeString;
//     }
//   }
//
//   String _calculateDuration(EmployeeCheckin checkIn, EmployeeCheckin checkOut) {
//     try {
//       DateTime inTime = DateTime.parse(checkIn.time);
//       DateTime outTime = DateTime.parse(checkOut.time);
//
//       Duration difference = outTime.difference(inTime);
//
//       if (difference.isNegative) {
//         return 'Invalid duration';
//       }
//
//       int hours = difference.inHours;
//       int minutes = difference.inMinutes.remainder(60);
//
//       return '${hours}h ${minutes}m';
//     } catch (e) {
//       return 'N/A';
//     }
//   }
//
//   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildClickableStatCard(String title, String value, IconData icon, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 24),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: controller.selectedDate.value,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.blue[700]!,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       controller.filterByDate(picked);
//     }
//   }
//
//   void _showFilterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Filter Options'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.today),
//                 title: const Text('Today'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   controller.filterByDate(DateTime.now());
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.calendar_view_week),
//                 title: const Text('This Week'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   DateTime now = DateTime.now();
//                   DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//                   controller.filterByDateRange(startOfWeek, now);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.calendar_view_month),
//                 title: const Text('This Month'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   DateTime now = DateTime.now();
//                   DateTime startOfMonth = DateTime(now.year, now.month, 1);
//                   controller.filterByDateRange(startOfMonth, now);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.date_range),
//                 title: const Text('Custom Range'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showDateRangePicker(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _showDateRangePicker(BuildContext context) async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.blue[700]!,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       controller.filterByDateRange(picked.start, picked.end);
//     }
//   }
// }

//Above code is old one
// views/employee_checkin_view.dart
// import 'package:amax_hr/app/modules/EmployeeCheckin/controllers/employee_checkin_controller.dart';
// import 'package:amax_hr/vo/employee_checkin_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class EmployeeCheckinView extends GetView<EmployeeCheckinController> {
//   const EmployeeCheckinView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//           'Employee Checkin',
//           style: TextStyle(
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.indigo.shade600,
//         elevation: 0,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list, color: Colors.white),
//             onPressed: () => _showFilterDialog(context),
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: () => controller.refreshData(),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Date Filter Header
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.indigo.shade600,
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(20),
//                 bottomRight: Radius.circular(20),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     // Call the popup method from controller
//                     controller.showNewCheckinPopup();
//                   },
//                   icon: const Icon(Icons.person_add_alt_1, size: 18),
//                   label: const Text('Attendance'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.blue[700],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//                 Obx(() => ElevatedButton.icon(
//                   onPressed: () => _selectDate(context),
//                   icon: const Icon(Icons.calendar_today, size: 18),
//                   label: Text(DateFormat('dd MMM yyyy').format(controller.selectedDate.value),),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.blue[700],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),),
//
//               ],
//             ),
//           ),
//
//           // Statistics Cards
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Obx(() => Column(
//               children: [
//                 // First row with existing statistics
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildStatCard(
//                         'Total Entries',
//                         controller.checkinList.length.toString(),
//                         Icons.list_alt,
//                         Colors.blue,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildStatCard(
//                         'Check In',
//                         controller.checkinList
//                             .where((item) => item.logType.toUpperCase() == 'IN')
//                             .length
//                             .toString(),
//                         Icons.login,
//                         Colors.green,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildStatCard(
//                         'Check Out',
//                         controller.checkinList
//                             .where((item) => item.logType.toUpperCase() == 'OUT')
//                             .length
//                             .toString(),
//                         Icons.logout,
//                         Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 // Second row with new Early Checkout and Early Check-in buttons
//                 Row(
//                   children: [
//                     Expanded(
//                       child: _buildClickableStatCard(
//                         'Early Checkout',
//                         _getEarlyCheckoutCount().toString(),
//                         Icons.schedule,
//                         Colors.orange,
//                             () => _showEarlyCheckoutList(context),
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildClickableStatCard(
//                         'Early Check-in',
//                         _getEarlyCheckInCount().toString(),
//                         Icons.login,
//                         Colors.purple,
//                             () => _showEarlyCheckInList(context),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             )),
//           ),
//
//           // Checkin List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//
//               if (controller.errorMessage.value.isNotEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 64,
//                         color: Colors.red[300],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         controller.errorMessage.value,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.red[600],
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton.icon(
//                         onPressed: () => controller.fetchEmployeeCheckins(),
//                         icon: const Icon(Icons.refresh),
//                         label: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//
//               if (controller.checkinList.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/data_not_found.gif',
//                         fit: BoxFit.contain,
//                         // Optional: tint if needed
//                       ),
//                       const SizedBox(height: 5),
//                       Text(
//                         'No checkin records found',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.indigo[900],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Try selecting a different date range',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.indigo[900],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//
//               // Group checkins by employee name
//               Map<String, List<EmployeeCheckin>> groupedCheckins = _groupCheckinsByEmployee();
//
//               return RefreshIndicator(
//                 onRefresh: () => controller.refreshData(),
//                 child: ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: groupedCheckins.keys.length,
//                   itemBuilder: (context, index) {
//                     String employeeName = groupedCheckins.keys.elementAt(index);
//                     List<EmployeeCheckin> employeeCheckins = groupedCheckins[employeeName]!;
//                     return _buildGroupedCheckinCard(employeeName, employeeCheckins);
//                   },
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Get early checkout count (checkout before 6:30 PM)
//   int _getEarlyCheckoutCount() {
//     int count = 0;
//     for (var checkin in controller.checkinList) {
//       if (checkin.logType.toUpperCase() == 'OUT') {
//         try {
//           DateTime checkoutTime = DateTime.parse(checkin.time);
//           // Check if checkout is before 6:30 PM (18:30)
//           DateTime officialOutTime = DateTime(
//             checkoutTime.year,
//             checkoutTime.month,
//             checkoutTime.day,
//             18,
//             30,
//           );
//           if (checkoutTime.isBefore(officialOutTime)) {
//             count++;
//           }
//         } catch (e) {
//           // Skip if time parsing fails
//         }
//       }
//     }
//     return count;
//   }
//
//   // Get early check-in count (check-in before 9:30 AM)
//   int _getEarlyCheckInCount() {
//     int count = 0;
//     for (var checkin in controller.checkinList) {
//       if (checkin.logType.toUpperCase() == 'IN') {
//         try {
//           DateTime checkinTime = DateTime.parse(checkin.time);
//           // Check if check-in is before 9:30 AM (09:30)
//           DateTime officialInTime = DateTime(
//             checkinTime.year,
//             checkinTime.month,
//             checkinTime.day,
//             9,
//             30,
//           );
//           if (checkinTime.isBefore(officialInTime)) {
//             count++;
//           }
//         } catch (e) {
//           // Skip if time parsing fails
//         }
//       }
//     }
//     return count;
//   }
//
//   // Get early checkout employees list
//   List<EmployeeCheckin> _getEarlyCheckoutEmployees() {
//     List<EmployeeCheckin> earlyCheckouts = [];
//     for (var checkin in controller.checkinList) {
//       if (checkin.logType.toUpperCase() == 'OUT') {
//         try {
//           DateTime checkoutTime = DateTime.parse(checkin.time);
//           DateTime officialOutTime = DateTime(
//             checkoutTime.year,
//             checkoutTime.month,
//             checkoutTime.day,
//             18,
//             30,
//           );
//           if (checkoutTime.isBefore(officialOutTime)) {
//             earlyCheckouts.add(checkin);
//           }
//         } catch (e) {
//           // Skip if time parsing fails
//         }
//       }
//     }
//     return earlyCheckouts;
//   }
//
//   // Get early check-in employees list
//   List<EmployeeCheckin> _getEarlyCheckInEmployees() {
//     List<EmployeeCheckin> earlyCheckIns = [];
//     for (var checkin in controller.checkinList) {
//       if (checkin.logType.toUpperCase() == 'IN') {
//         try {
//           DateTime checkinTime = DateTime.parse(checkin.time);
//           DateTime officialInTime = DateTime(
//             checkinTime.year,
//             checkinTime.month,
//             checkinTime.day,
//             9,
//             30,
//           );
//           if (checkinTime.isBefore(officialInTime)) {
//             earlyCheckIns.add(checkin);
//           }
//         } catch (e) {
//           // Skip if time parsing fails
//         }
//       }
//     }
//     return earlyCheckIns;
//   }
//
//   // Show early checkout list dialog
//   void _showEarlyCheckoutList(BuildContext context) {
//     List<EmployeeCheckin> earlyCheckouts = _getEarlyCheckoutEmployees();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Container(
//             width: Get.width * 0.9,
//             constraints: BoxConstraints(
//               maxHeight: Get.height * 0.7,
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.schedule, color: Colors.orange, size: 24),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Early Checkout Employees',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.orange[700],
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Employees who checked out before 6:30 PM',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Divider(),
//                 Expanded(
//                   child: earlyCheckouts.isEmpty
//                       ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.check_circle,
//                           size: 64,
//                           color: Colors.green[300],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No early checkouts found!',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                       : ListView.builder(
//                     itemCount: earlyCheckouts.length,
//                     itemBuilder: (context, index) {
//                       final checkin = earlyCheckouts[index];
//                       return _buildEmployeeListTile(checkin, Colors.orange);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Show early check-in list dialog
//   void _showEarlyCheckInList(BuildContext context) {
//     List<EmployeeCheckin> earlyCheckIns = _getEarlyCheckInEmployees();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: Container(
//             width: Get.width * 0.9,
//             constraints: BoxConstraints(
//               maxHeight: Get.height * 0.7,
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.schedule_send, color: Colors.purple, size: 24),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         'Early Check-in Employees',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.purple[700],
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(context),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Employees who checked in before 9:30 AM',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Divider(),
//                 Expanded(
//                   child: earlyCheckIns.isEmpty
//                       ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.check_circle,
//                           size: 64,
//                           color: Colors.green[300],
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No early check-ins found!',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                       : ListView.builder(
//                     itemCount: earlyCheckIns.length,
//                     itemBuilder: (context, index) {
//                       final checkin = earlyCheckIns[index];
//                       return _buildEmployeeListTile(checkin, Colors.purple);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Build employee list tile for dialogs
//   Widget _buildEmployeeListTile(EmployeeCheckin checkin, Color color) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: color.withOpacity(0.2),
//           child: Text(
//             checkin.employeeName.isNotEmpty
//                 ? checkin.employeeName[0].toUpperCase()
//                 : 'U',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//         ),
//         title: Text(
//           checkin.employeeName.isNotEmpty
//               ? checkin.employeeName
//               : 'Unknown Employee',
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 14,
//           ),
//         ),
//         subtitle: Text(
//           '${checkin.logType.toUpperCase()} at ${_getFormattedTime(checkin.time)}',
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//           ),
//         ),
//         trailing: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Text(
//             checkin.logType.toUpperCase(),
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.bold,
//               fontSize: 10,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Group checkins by employee name
//   Map<String, List<EmployeeCheckin>> _groupCheckinsByEmployee() {
//     Map<String, List<EmployeeCheckin>> grouped = {};
//
//     for (var checkin in controller.checkinList) {
//       String employeeName = checkin.employeeName.isNotEmpty ? checkin.employeeName : 'Unknown Employee';
//
//       if (grouped[employeeName] == null) {
//         grouped[employeeName] = [];
//       }
//       grouped[employeeName]!.add(checkin);
//     }
//
//     // Sort each employee's checkins by time
//     grouped.forEach((key, value) {
//       value.sort((a, b) => a.time.compareTo(b.time));
//     });
//
//     return grouped;
//   }
//
//   Widget _buildGroupedCheckinCard(String employeeName, List<EmployeeCheckin> checkins) {
//     // Separate IN and OUT entries
//     List<EmployeeCheckin> checkIns = checkins.where((c) => c.logType.toUpperCase() == 'IN').toList();
//     List<EmployeeCheckin> checkOuts = checkins.where((c) => c.logType.toUpperCase() == 'OUT').toList();
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Employee Name Header
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: Colors.indigo.shade100,
//                   radius: 20,
//                   child: Text(
//                     employeeName.isNotEmpty ? employeeName[0].toUpperCase() : 'U',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.indigo.shade700,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         employeeName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       Text(
//                         '${checkins.length} entries',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Status badges
//                 if (checkIns.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     margin: const EdgeInsets.only(right: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       'IN: ${checkIns.length}',
//                       style: const TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 10,
//                       ),
//                     ),
//                   ),
//                 if (checkOuts.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       'OUT: ${checkOuts.length}',
//                       style: const TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 10,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//
//             const SizedBox(height: 12),
//             const Divider(height: 1),
//             const SizedBox(height: 12),
//
//             // Check-in and Check-out times in rows
//             Row(
//               children: [
//                 // Check In Column
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.login, size: 16, color: Colors.green),
//                           const SizedBox(width: 6),
//                           Text(
//                             'Check In',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.green,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       if (checkIns.isNotEmpty)
//                         ...checkIns.map((checkin) => Padding(
//                           padding: const EdgeInsets.only(bottom: 4),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 _getFormattedTime(checkin.time),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 13,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               if (checkin.deviceId.isNotEmpty)
//                                 Text(
//                                   'Device: ${checkin.deviceId}',
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         )).toList()
//                       else
//                         Text(
//                           'No check-in',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[500],
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//
//                 // Vertical divider
//                 Container(
//                   height: 50,
//                   width: 1,
//                   color: Colors.grey[300],
//                   margin: const EdgeInsets.symmetric(horizontal: 12),
//                 ),
//
//                 // Check Out Column
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.logout, size: 16, color: Colors.red),
//                           const SizedBox(width: 6),
//                           Text(
//                             'Check Out',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.red,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       if (checkOuts.isNotEmpty)
//                         ...checkOuts.map((checkin) => Padding(
//                           padding: const EdgeInsets.only(bottom: 4),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 _getFormattedTime(checkin.time),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 13,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               if (checkin.deviceId.isNotEmpty)
//                                 Text(
//                                   'Device: ${checkin.deviceId}',
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     color: Colors.grey[600],
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         )).toList()
//                       else
//                         Text(
//                           'No check-out',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[500],
//                             fontStyle: FontStyle.italic,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//
//             // Working duration (if both check-in and check-out exist)
//             if (checkIns.isNotEmpty && checkOuts.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(top: 12),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.access_time, size: 14, color: Colors.blue[700]),
//                       const SizedBox(width: 6),
//                       Text(
//                         'Duration: ${_calculateDuration(checkIns.first, checkOuts.last)}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.blue[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _getFormattedTime(String timeString) {
//     try {
//       DateTime dateTime = DateTime.parse(timeString);
//       return DateFormat('HH:mm').format(dateTime);
//     } catch (e) {
//       return timeString;
//     }
//   }
//
//   String _calculateDuration(EmployeeCheckin checkIn, EmployeeCheckin checkOut) {
//     try {
//       DateTime inTime = DateTime.parse(checkIn.time);
//       DateTime outTime = DateTime.parse(checkOut.time);
//
//       Duration difference = outTime.difference(inTime);
//
//       if (difference.isNegative) {
//         return 'Invalid duration';
//       }
//
//       int hours = difference.inHours;
//       int minutes = difference.inMinutes.remainder(60);
//
//       return '${hours}h ${minutes}m';
//     } catch (e) {
//       return 'N/A';
//     }
//   }
//
//   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildClickableStatCard(String title, String value, IconData icon, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.1),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 24),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: controller.selectedDate.value,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.blue[700]!,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       controller.filterByDate(picked);
//     }
//   }
//
//   void _showFilterDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Filter Options'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.today),
//                 title: const Text('Today'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   controller.filterByDate(DateTime.now());
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.calendar_view_week),
//                 title: const Text('This Week'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   DateTime now = DateTime.now();
//                   DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
//                   controller.filterByDateRange(startOfWeek, now);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.calendar_view_month),
//                 title: const Text('This Month'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   DateTime now = DateTime.now();
//                   DateTime startOfMonth = DateTime(now.year, now.month, 1);
//                   controller.filterByDateRange(startOfMonth, now);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.date_range),
//                 title: const Text('Custom Range'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showDateRangePicker(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   void _showDateRangePicker(BuildContext context) async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.blue[700]!,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: Colors.black,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//
//     if (picked != null) {
//       controller.filterByDateRange(picked.start, picked.end);
//     }
//   }
// }
import 'package:amax_hr/app/modules/EmployeeCheckin/controllers/employee_checkin_controller.dart';
import 'package:amax_hr/vo/employee_checkin_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EmployeeCheckinView extends GetView<EmployeeCheckinController> {
  const EmployeeCheckinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Employee Checkin',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo.shade600,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Filter Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.shade600,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Call the popup method from controller
                    controller.showNewCheckinPopup();
                  },
                  icon: const Icon(Icons.person_add_alt_1, size: 18),
                  label: const Text('Attendance'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Obx(() => ElevatedButton.icon(
                  onPressed: () => _selectDate(context),
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(DateFormat('dd MMM yyyy').format(controller.selectedDate.value),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),),

              ],
            ),
          ),

          // Statistics Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Obx(() => Column(
              children: [
                // First row with existing statistics
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Entries',
                        controller.checkinList.length.toString(),
                        Icons.list_alt,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Check In',
                        controller.checkinList
                            .where((item) => item.logType.toUpperCase() == 'IN')
                            .length
                            .toString(),
                        Icons.login,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Check Out',
                        controller.checkinList
                            .where((item) => item.logType.toUpperCase() == 'OUT')
                            .length
                            .toString(),
                        Icons.logout,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Second row with new Early Checkout and Early Check-in buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildClickableStatCard(
                        'Early Checkout',
                        _getEarlyCheckoutCount().toString(),
                        Icons.schedule,
                        Colors.orange,
                            () => _showEarlyCheckoutList(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildClickableStatCard(
                        'Early Check-in',
                        _getEarlyCheckInCount().toString(),
                        Icons.login,
                        Colors.purple,
                            () => _showEarlyCheckInList(context),
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ),

          // Checkin List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => controller.fetchEmployeeCheckins(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.checkinList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/data_not_found.gif',
                        fit: BoxFit.contain,
                        // Optional: tint if needed
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'No checkin records found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.indigo[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try selecting a different date range',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.indigo[900],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Group checkins by employee name
              Map<String, List<EmployeeCheckin>> groupedCheckins = _groupCheckinsByEmployee();

              return RefreshIndicator(
                onRefresh: () => controller.refreshData(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: groupedCheckins.keys.length,
                  itemBuilder: (context, index) {
                    String employeeName = groupedCheckins.keys.elementAt(index);
                    List<EmployeeCheckin> employeeCheckins = groupedCheckins[employeeName]!;
                    return _buildGroupedCheckinCard(employeeName, employeeCheckins);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // Get early checkout count (checkout before 6:30 PM)
  int _getEarlyCheckoutCount() {
    int count = 0;
    for (var checkin in controller.checkinList) {
      if (checkin.logType.toUpperCase() == 'OUT') {
        try {
          DateTime checkoutTime = DateTime.parse(checkin.time);
          // Check if checkout is before 6:30 PM (18:30)
          DateTime officialOutTime = DateTime(
            checkoutTime.year,
            checkoutTime.month,
            checkoutTime.day,
            18,
            30,
          );
          if (checkoutTime.isBefore(officialOutTime)) {
            count++;
          }
        } catch (e) {
          // Skip if time parsing fails
        }
      }
    }
    return count;
  }

  // Get early check-in count (check-in before 9:30 AM)
  int _getEarlyCheckInCount() {
    int count = 0;
    for (var checkin in controller.checkinList) {
      if (checkin.logType.toUpperCase() == 'IN') {
        try {
          DateTime checkinTime = DateTime.parse(checkin.time);
          // Check if check-in is before 9:30 AM (09:30)
          DateTime officialInTime = DateTime(
            checkinTime.year,
            checkinTime.month,
            checkinTime.day,
            9,
            30,
          );
          if (checkinTime.isBefore(officialInTime)) {
            count++;
          }
        } catch (e) {
          // Skip if time parsing fails
        }
      }
    }
    return count;
  }

  // Get early checkout employees list
  List<EmployeeCheckin> _getEarlyCheckoutEmployees() {
    List<EmployeeCheckin> earlyCheckouts = [];
    for (var checkin in controller.checkinList) {
      if (checkin.logType.toUpperCase() == 'OUT') {
        try {
          DateTime checkoutTime = DateTime.parse(checkin.time);
          DateTime officialOutTime = DateTime(
            checkoutTime.year,
            checkoutTime.month,
            checkoutTime.day,
            18,
            30,
          );
          if (checkoutTime.isBefore(officialOutTime)) {
            earlyCheckouts.add(checkin);
          }
        } catch (e) {
          // Skip if time parsing fails
        }
      }
    }
    return earlyCheckouts;
  }

  // Get early check-in employees list
  List<EmployeeCheckin> _getEarlyCheckInEmployees() {
    List<EmployeeCheckin> earlyCheckIns = [];
    for (var checkin in controller.checkinList) {
      if (checkin.logType.toUpperCase() == 'IN') {
        try {
          DateTime checkinTime = DateTime.parse(checkin.time);
          DateTime officialInTime = DateTime(
            checkinTime.year,
            checkinTime.month,
            checkinTime.day,
            9,
            30,
          );
          if (checkinTime.isBefore(officialInTime)) {
            earlyCheckIns.add(checkin);
          }
        } catch (e) {
          // Skip if time parsing fails
        }
      }
    }
    return earlyCheckIns;
  }

  // Show early checkout list dialog
  void _showEarlyCheckoutList(BuildContext context) {
    List<EmployeeCheckin> earlyCheckouts = _getEarlyCheckoutEmployees();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: Get.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: Get.height * 0.7,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.orange, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Early Checkout Employees',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Employees who checked out before 6:30 PM',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                Expanded(
                  child: earlyCheckouts.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 64,
                          color: Colors.green[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No early checkouts found!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: earlyCheckouts.length,
                    itemBuilder: (context, index) {
                      final checkin = earlyCheckouts[index];
                      return _buildEmployeeListTile(checkin, Colors.orange);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show early check-in list dialog
  void _showEarlyCheckInList(BuildContext context) {
    List<EmployeeCheckin> earlyCheckIns = _getEarlyCheckInEmployees();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: Get.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: Get.height * 0.7,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule_send, color: Colors.purple, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Early Check-in Employees',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple[700],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Employees who checked in before 9:30 AM',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                Expanded(
                  child: earlyCheckIns.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 64,
                          color: Colors.green[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No early check-ins found!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: earlyCheckIns.length,
                    itemBuilder: (context, index) {
                      final checkin = earlyCheckIns[index];
                      return _buildEmployeeListTile(checkin, Colors.purple);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Build employee list tile for dialogs
  Widget _buildEmployeeListTile(EmployeeCheckin checkin, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            checkin.employeeName.isNotEmpty
                ? checkin.employeeName[0].toUpperCase()
                : 'U',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        title: Text(
          checkin.employeeName.isNotEmpty
              ? checkin.employeeName
              : 'Unknown Employee',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          '${checkin.logType.toUpperCase()} at ${_getFormattedTime(checkin.time)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            checkin.logType.toUpperCase(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  // Group checkins by employee name
  Map<String, List<EmployeeCheckin>> _groupCheckinsByEmployee() {
    Map<String, List<EmployeeCheckin>> grouped = {};

    for (var checkin in controller.checkinList) {
      String employeeName = checkin.employeeName.isNotEmpty ? checkin.employeeName : 'Unknown Employee';

      if (grouped[employeeName] == null) {
        grouped[employeeName] = [];
      }
      grouped[employeeName]!.add(checkin);
    }

    // Sort each employee's checkins by time
    grouped.forEach((key, value) {
      value.sort((a, b) => a.time.compareTo(b.time));
    });

    return grouped;
  }

  Widget _buildGroupedCheckinCard(String employeeName, List<EmployeeCheckin> checkins) {
    // Separate IN and OUT entries
    List<EmployeeCheckin> checkIns = checkins.where((c) => c.logType.toUpperCase() == 'IN').toList();
    List<EmployeeCheckin> checkOuts = checkins.where((c) => c.logType.toUpperCase() == 'OUT').toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee Name Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.indigo.shade100,
                  radius: 20,
                  child: Text(
                    employeeName.isNotEmpty ? employeeName[0].toUpperCase() : 'U',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employeeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${checkins.length} entries',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Status badges
                if (checkIns.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'IN: ${checkIns.length}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                if (checkOuts.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'OUT: ${checkOuts.length}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Check-in and Check-out times in rows
            Row(
              children: [
                // Check In Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.login, size: 16, color: Colors.green),
                          const SizedBox(width: 6),
                          Text(
                            'Check In',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (checkIns.isNotEmpty)
                        ...checkIns.map((checkin) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getFormattedDateTime(checkin.time),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),

                              // if (checkin.deviceId.isNotEmpty)
                              //   Text(
                              //     'Device: ${checkin.deviceId}',
                              //     style: TextStyle(
                              //       fontSize: 10,
                              //       color: Colors.grey[600],
                              //     ),
                              //   ),
                            ],
                          ),
                        )).toList()
                      else
                        Text(
                          'No check-in',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),

                // Vertical divider
                Container(
                  height: 50,
                  width: 1,
                  color: Colors.grey[300],
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),

                // Check Out Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.logout, size: 16, color: Colors.red),
                          const SizedBox(width: 6),
                          Text(
                            'Check Out',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      if (checkOuts.isNotEmpty)
                        ...checkOuts.map((checkin) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getFormattedDateTime(checkin.time),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                              if (checkin.deviceId.isNotEmpty)
                                Text(
                                  'Device: ${checkin.deviceId}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        )).toList()
                      else
                        Text(
                          'No check-out',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Working duration (if both check-in and check-out exist)
            if (checkIns.isNotEmpty && checkOuts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.blue[700]),
                      const SizedBox(width: 6),
                      Text(
                        'Duration: ${_calculateDuration(checkIns.first, checkOuts.last)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getFormattedTime(String timeString) {
    try {
      DateTime dateTime = DateTime.parse(timeString);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return timeString;
    }
  }

  // Updated method to include date and time
  String _getFormattedDateTime(String timeString) {
    try {
      DateTime dateTime = DateTime.parse(timeString);
      return DateFormat('dd MMM yyyy - HH:mm').format(dateTime);
    } catch (e) {
      return timeString;
    }
  }

  String _calculateDuration(EmployeeCheckin checkIn, EmployeeCheckin checkOut) {
    try {
      DateTime inTime = DateTime.parse(checkIn.time);
      DateTime outTime = DateTime.parse(checkOut.time);

      Duration difference = outTime.difference(inTime);

      if (difference.isNegative) {
        return 'Invalid duration';
      }

      int hours = difference.inHours;
      int minutes = difference.inMinutes.remainder(60);

      return '${hours}h ${minutes}m';
    } catch (e) {
      return 'N/A';
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildClickableStatCard(String title, String value, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.filterByDate(picked);
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.today),
                title: const Text('Today'),
                onTap: () {
                  Navigator.pop(context);
                  controller.filterByDate(DateTime.now());
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_view_week),
                title: const Text('This Week'),
                onTap: () {
                  Navigator.pop(context);
                  DateTime now = DateTime.now();
                  DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
                  controller.filterByDateRange(startOfWeek, now);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_view_month),
                title: const Text('This Month'),
                onTap: () {
                  Navigator.pop(context);
                  DateTime now = DateTime.now();
                  DateTime startOfMonth = DateTime(now.year, now.month, 1);
                  controller.filterByDateRange(startOfMonth, now);
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('Custom Range'),
                onTap: () {
                  Navigator.pop(context);
                  _showDateRangePicker(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[700]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.filterByDateRange(picked.start, picked.end);
    }
  }
}