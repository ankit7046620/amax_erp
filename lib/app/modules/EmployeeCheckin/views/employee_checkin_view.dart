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
//                                 _getFormattedDateTime(checkin.time),
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 13,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//
//                               // if (checkin.deviceId.isNotEmpty)
//                               //   Text(
//                               //     'Device: ${checkin.deviceId}',
//                               //     style: TextStyle(
//                               //       fontSize: 10,
//                               //       color: Colors.grey[600],
//                               //     ),
//                               //   ),
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
//                                 _getFormattedDateTime(checkin.time),
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
//   // Updated method to include date and time
//   String _getFormattedDateTime(String timeString) {
//     try {
//       DateTime dateTime = DateTime.parse(timeString);
//       return DateFormat('dd MMM yyyy - HH:mm').format(dateTime);
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
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
            icon: const Icon(Icons.map, color: Colors.white),
            onPressed: () => _showLocationMapDialog(context),
            tooltip: 'View Locations Map',
          ),
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
          // Date Filter Header with Location Status
          _buildHeaderSection(context),

          // Statistics Cards
          _buildStatisticsSection(context),

          // Checkin List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return _buildErrorSection();
              }

              if (controller.checkinList.isEmpty) {
                return _buildEmptySection();
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
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade600,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Main action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () => controller.showNewCheckinPopup(),
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
                label: Text(DateFormat('dd MMM yyyy').format(controller.selectedDate.value)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),

          // Location status indicator
          Obx(() => _buildLocationStatusIndicator(context)),
        ],
      ),
    );
  }

  Widget _buildLocationStatusIndicator(BuildContext context) {
    if (controller.currentPosition.value == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, color: Colors.orange[300], size: 16),
            const SizedBox(width: 6),
            Text(
              'Location Services Required',
              style: TextStyle(
                color: Colors.orange[300],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: controller.isWithinGeofence.value
            ? Colors.green.withOpacity(0.2)
            : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            controller.isWithinGeofence.value ? Icons.check_circle : Icons.error,
            color: controller.isWithinGeofence.value
                ? Colors.green[300]
                : Colors.red[300],
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            controller.isWithinGeofence.value
                ? 'In Office Area'
                : 'Outside Office (${controller.distanceFromOffice.value.round()}m)',
            style: TextStyle(
              color: controller.isWithinGeofence.value
                  ? Colors.green[300]
                  : Colors.red[300],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    return Container(
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
          // Second row with enhanced statistics
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
    );
  }

  Widget _buildFloatingActionButton() {
    return Obx(() => FloatingActionButton.extended(
      onPressed: () => controller.showNewCheckinPopup(),
      backgroundColor: controller.isWithinGeofence.value
          ? Colors.green
          : Colors.orange,
      foregroundColor: Colors.white,
      icon: Icon(
        controller.isWithinGeofence.value
            ? Icons.check_circle
            : Icons.location_on,
      ),
      label: Text(
        controller.isWithinGeofence.value
            ? 'Quick Check-in'
            : 'Check Location',
      ),
    ));
  }

  Widget _buildErrorSection() {
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

  Widget _buildEmptySection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/data_not_found.gif',
            fit: BoxFit.contain,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.inbox,
                size: 100,
                color: Colors.grey[400],
              );
            },
          ),
          const SizedBox(height: 20),
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

  // Show location map dialog
  void _showLocationMapDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: Get.width * 0.95,
            height: Get.height * 0.8,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.map, color: Colors.indigo.shade600, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Office Locations & Checkins',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade700,
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
                  'Red markers: Office locations with geofence areas\nBlue marker: Your current location',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() {
                    if (controller.currentPosition.value == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            const Text('Loading location...'),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => controller.refreshLocation(),
                              child: const Text('Refresh Location'),
                            ),
                          ],
                        ),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            controller.currentPosition.value!.latitude,
                            controller.currentPosition.value!.longitude,
                          ),
                          zoom: 14.0,
                        ),
                        markers: _buildAllLocationMarkers(),
                        circles: controller.circles,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                // Legend
                _buildMapLegend(),
              ],
            ),
          ),
        );
      },
    );
  }

  Set<Marker> _buildAllLocationMarkers() {
    Set<Marker> markers = {};

    // Add current location marker
    if (controller.currentPosition.value != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            controller.currentPosition.value!.latitude,
            controller.currentPosition.value!.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current position',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    // Add office location markers
    for (int i = 0; i < controller.officeLocations.length; i++) {
      var office = controller.officeLocations[i];
      markers.add(
        Marker(
          markerId: MarkerId('office_$i'),
          position: LatLng(office.latitude, office.longitude),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: '${office.address}\nRadius: ${office.radiusInMeters.round()}m',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    // Add checkin location markers for today
    List<EmployeeCheckin> todayCheckins = controller.checkinList.where((checkin) {
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      return checkin.time.startsWith(today);
    }).toList();

    for (int i = 0; i < todayCheckins.length; i++) {
      EmployeeCheckin checkin = todayCheckins[i];
      if (checkin.latitude != null && checkin.longitude != null) {
        try {
          double lat = double.parse(checkin.latitude!);
          double lng = double.parse(checkin.longitude!);

          markers.add(
            Marker(
              markerId: MarkerId('checkin_$i'),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: '${checkin.logType.toUpperCase()} - ${checkin.employeeName}',
                snippet: '${_getFormattedTime(checkin.time)}\n${checkin.location ?? 'Unknown Location'}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                checkin.logType.toUpperCase() == 'IN'
                    ? BitmapDescriptor.hueGreen
                    : BitmapDescriptor.hueOrange,
              ),
            ),
          );
        } catch (e) {
          print('Error parsing coordinates for checkin: $e');
        }
      }
    }

    return markers;
  }

  Widget _buildMapLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildLegendItem(Colors.red, 'Office Locations'),
                _buildLegendItem(Colors.blue, 'Your Location'),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _buildLegendItem(Colors.green, 'Check-In Points'),
                _buildLegendItem(Colors.orange, 'Check-Out Points'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // Enhanced grouped checkin card with location info
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
            // Employee Name Header with Location Badge
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
                // Location verification badge
                _buildLocationVerificationBadge(checkins),
                const SizedBox(width: 8),
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

            // Check-in and Check-out times with enhanced location info
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
                          padding: const EdgeInsets.only(bottom: 8),
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
                              if (checkin.location?.isNotEmpty == true)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    checkin.location!,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w500,
                                    ),
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
                  height: 60,
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
                          padding: const EdgeInsets.only(bottom: 8),
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
                              if (checkin.location?.isNotEmpty == true)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    checkin.location!,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red[700],
                                      fontWeight: FontWeight.w500,
                                    ),
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

            // Working duration and location summary
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                      if (_hasValidLocation(checkIns.first) || _hasValidLocation(checkOuts.last))
                        GestureDetector(
                          onTap: () => _showCheckinMapDialog(checkins),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.map, size: 12, color: Colors.indigo[700]),
                                const SizedBox(width: 4),
                                Text(
                                  'View Map',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.indigo[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildLocationVerificationBadge(List<EmployeeCheckin> checkins) {
    bool hasGeofencedEntry = checkins.any((checkin) =>
    checkin.deviceId.contains('GEOFENCED') ||
        checkin.location?.contains('Office') == true);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: hasGeofencedEntry
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
      Icon(
      hasGeofencedEntry ? Icons.verified : Icons.location_off,
        size: 12,
        color:hasGeofencedEntry ? Colors.green : Colors.orange,
      ),
    ],
    ),
    );
  }

  bool _hasValidLocation(EmployeeCheckin checkin) {
    return checkin.latitude?.isNotEmpty == true &&
        checkin.longitude?.isNotEmpty == true;
  }

  void _showCheckinMapDialog(List<EmployeeCheckin> checkins) {
    List<EmployeeCheckin> validLocationCheckins = checkins.where((checkin) =>
        _hasValidLocation(checkin)).toList();

    if (validLocationCheckins.isEmpty) {
      Get.snackbar(
        'No Location Data',
        'No location information available for these checkins',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: Get.width * 0.95,
            height: Get.height * 0.7,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.map, color: Colors.indigo.shade600, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${checkins.first.employeeName} - Checkin Locations',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _getAverageLocation(validLocationCheckins),
                        zoom: 15.0,
                      ),
                      markers: _buildCheckinMarkers(validLocationCheckins),
                      zoomControlsEnabled: true,
                      mapType: MapType.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  LatLng _getAverageLocation(List<EmployeeCheckin> checkins) {
    double totalLat = 0;
    double totalLng = 0;
    int count = 0;

    for (var checkin in checkins) {
      try {
        double lat = double.parse(checkin.latitude!);
        double lng = double.parse(checkin.longitude!);
        totalLat += lat;
        totalLng += lng;
        count++;
      } catch (e) {
        continue;
      }
    }

    if (count == 0) {
      return const LatLng(23.0225, 72.5714); // Default to Ahmedabad
    }

    return LatLng(totalLat / count, totalLng / count);
  }

  Set<Marker> _buildCheckinMarkers(List<EmployeeCheckin> checkins) {
    Set<Marker> markers = {};

    for (int i = 0; i < checkins.length; i++) {
      EmployeeCheckin checkin = checkins[i];
      try {
        double lat = double.parse(checkin.latitude!);
        double lng = double.parse(checkin.longitude!);

        markers.add(
          Marker(
            markerId: MarkerId('checkin_$i'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: '${checkin.logType.toUpperCase()} - ${checkin.employeeName}',
              snippet: '${_getFormattedTime(checkin.time)}\n${checkin.location ?? 'Unknown Location'}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              checkin.logType.toUpperCase() == 'IN'
                  ? BitmapDescriptor.hueGreen
                  : BitmapDescriptor.hueRed,
            ),
          ),
        );
      } catch (e) {
        continue;
      }
    }

    return markers;
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

  // Get early checkout count (checkout before 6:30 PM)
  int _getEarlyCheckoutCount() {
    int count = 0;
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

  void _showEarlyCheckoutList(BuildContext context) {
    List<EmployeeCheckin> earlyCheckouts = controller.checkinList
        .where((checkin) {
      if (checkin.logType.toUpperCase() != 'OUT') return false;
      try {
        DateTime checkoutTime = DateTime.parse(checkin.time);
        DateTime officialOutTime = DateTime(
          checkoutTime.year,
          checkoutTime.month,
          checkoutTime.day,
          18,
          30,
        );
        return checkoutTime.isBefore(officialOutTime);
      } catch (e) {
        return false;
      }
    })
        .toList();

    _showEmployeeListDialog(
      context,
      'Early Checkout Employees',
      'Employees who checked out before 6:30 PM',
      earlyCheckouts,
      Colors.orange,
      Icons.schedule,
    );
  }

  void _showEarlyCheckInList(BuildContext context) {
    List<EmployeeCheckin> earlyCheckIns = controller.checkinList
        .where((checkin) {
      if (checkin.logType.toUpperCase() != 'IN') return false;
      try {
        DateTime checkinTime = DateTime.parse(checkin.time);
        DateTime officialInTime = DateTime(
          checkinTime.year,
          checkinTime.month,
          checkinTime.day,
          9,
          30,
        );
        return checkinTime.isBefore(officialInTime);
      } catch (e) {
        return false;
      }
    })
        .toList();

    _showEmployeeListDialog(
      context,
      'Early Check-in Employees',
      'Employees who checked in before 9:30 AM',
      earlyCheckIns,
      Colors.purple,
      Icons.schedule_send,
    );
  }

  void _showEmployeeListDialog(
      BuildContext context,
      String title,
      String subtitle,
      List<EmployeeCheckin> checkins,
      Color color,
      IconData icon,
      ) {
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
                    Icon(icon, color: color, size: 24),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
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
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                Expanded(
                  child: checkins.isEmpty
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
                          'No entries found!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: checkins.length,
                    itemBuilder: (context, index) {
                      final checkin = checkins[index];
                      return _buildEmployeeListTile(checkin, color);
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${checkin.logType.toUpperCase()} at ${_getFormattedTime(checkin.time)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (checkin.location?.isNotEmpty == true)
              Text(
                'Location: ${checkin.location}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
          ],
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

  String _getFormattedTime(String timeString) {
    try {
      DateTime dateTime = DateTime.parse(timeString);
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return timeString;
    }
  }

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


