// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/leave_application_controller.dart';
//
// class LeaveApplicationView extends GetView<LeaveApplicationController> {
//   const LeaveApplicationView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F4F8),
//       appBar: AppBar(
//         backgroundColor: Colors.indigo.shade600,
//         elevation: 0,
//         title: const Text(
//           'Leave Applications',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: controller.refreshData,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search and Filter Section
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: const Color(0xFFF0F4F8),
//             child: Column(
//               children: [
//                 // Search Bar
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     onChanged: controller.updateSearchQuery,
//                     decoration: const InputDecoration(
//                       hintText: 'Search employees...',
//                       prefixIcon: Icon(Icons.search, color: Colors.grey),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.all(16),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 // Filter Row
//                 Row(
//                   children: [
//                     // Filter Button
//                     Expanded(
//                       child: Obx(() => Container(
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF4CAF50),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Material(
//                           color: Colors.transparent,
//                           child: InkWell(
//                             borderRadius: BorderRadius.circular(12),
//                             onTap: () => _showFilterBottomSheet(context),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(
//                                     Icons.filter_list,
//                                     color: Colors.white,
//                                     size: 20,
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     'Filter ${controller.selectedStatus.value}',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   if (controller.selectedStatus.value != 'All')
//                                     const SizedBox(width: 8),
//                                   if (controller.selectedStatus.value != 'All')
//                                     GestureDetector(
//                                       onTap: () => controller.updateStatusFilter('All'),
//                                       child: const Icon(
//                                         Icons.close,
//                                         color: Colors.white,
//                                         size: 18,
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       )),
//                     ),
//                     const SizedBox(width: 12),
//                     // Sort Button
//                     Expanded(
//                       child: Obx(() => Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: Material(
//                           color: Colors.transparent,
//                           child: InkWell(
//                             borderRadius: BorderRadius.circular(12),
//                             onTap: () => _showSortBottomSheet(context),
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const Icon(
//                                     Icons.sort,
//                                     color: Colors.black87,
//                                     size: 20,
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Flexible(
//                                     child: Text(
//                                       controller.sortBy.value,
//                                       style: const TextStyle(
//                                         color: Colors.black87,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       )),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           // Results Count
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             color: const Color(0xFFF0F4F8),
//             child: Obx(() => Text(
//               '${controller.filteredApplications.length} of ${controller.leaveApplications.length}',
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: 14,
//               ),
//             )),
//           ),
//           // Applications List
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
//                   ),
//                 );
//               }
//
//               if (controller.filteredApplications.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.inbox_outlined,
//                         size: 64,
//                         color: Colors.grey.shade400,
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         'No applications found',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//
//               return RefreshIndicator(
//                 onRefresh: controller.fetchLeaveApplications,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: controller.filteredApplications.length,
//                   itemBuilder: (context, index) {
//                     final application = controller.filteredApplications[index];
//                     return _buildLeaveApplicationCard(application);
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
//   Widget _buildLeaveApplicationCard(LeaveApplication application) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             // Checkbox
//             // Container(
//             //   width: 20,
//             //   height: 20,
//             //   decoration: BoxDecoration(
//             //     border: Border.all(color: Colors.grey.shade400),
//             //     borderRadius: BorderRadius.circular(4),
//             //   ),
//             //   child: const Icon(
//             //     Icons.check_box_outline_blank,
//             //     size: 16,
//             //     color: Colors.grey,
//             //   ),
//             // ),
//
//             // Content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Employee Name and Status Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           application.employeeName,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: controller.getStatusColor(application.status),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           application.status,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   // Date and ID Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         application.fromDate,
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 14,
//                         ),
//                       ),
//                       Text(
//                         application.name,
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16),
//             // Time ago and actions
//             Column(
//               children: [
//                 Text(
//                   controller.getTimeAgo(application.fromDate),
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 12,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.chat_bubble_outline,
//                       size: 16,
//                       color: Colors.grey.shade400,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       '0',
//                       style: TextStyle(
//                         color: Colors.grey.shade400,
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Icon(
//                       Icons.favorite_border,
//                       size: 16,
//                       color: Colors.grey.shade400,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showFilterBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
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
//             const SizedBox(height: 20),
//             ...controller.statusOptions.map((status) => Obx(() => ListTile(
//               title: Text(status),
//               leading: Radio<String>(
//                 value: status,
//                 groupValue: controller.selectedStatus.value,
//                 onChanged: (value) {
//                   if (value != null) {
//                     controller.updateStatusFilter(value);
//                     Navigator.pop(context);
//                   }
//                 },
//                 activeColor: const Color(0xFF4CAF50),
//               ),
//               onTap: () {
//                 controller.updateStatusFilter(status);
//                 Navigator.pop(context);
//               },
//             ))),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showSortBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Sort by',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 20),
//             ...controller.sortOptions.map((option) => Obx(() => ListTile(
//               title: Text(option),
//               leading: Radio<String>(
//                 value: option,
//                 groupValue: controller.sortBy.value,
//                 onChanged: (value) {
//                   if (value != null) {
//                     controller.updateSortBy(value);
//                     Navigator.pop(context);
//                   }
//                 },
//                 activeColor: const Color(0xFF4CAF50),
//               ),
//               onTap: () {
//                 controller.updateSortBy(option);
//                 Navigator.pop(context);
//               },
//             ))),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leave_application_controller.dart';

class LeaveApplicationView extends GetView<LeaveApplicationController> {
  const LeaveApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade600,
        elevation: 0,
        title: const Text(
          'Leave Applications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLeaveDialog(context),
        backgroundColor: const Color(0xFF4CAF50),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Leave',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF0F4F8),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: controller.updateSearchQuery,
                    decoration: const InputDecoration(
                      hintText: 'Search employees...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Row
                Row(
                  children: [
                    // Filter Button
                    Expanded(
                      child: Obx(() => Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _showFilterBottomSheet(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.filter_list,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Filter ${controller.selectedStatus.value}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (controller.selectedStatus.value != 'All')
                                    const SizedBox(width: 8),
                                  if (controller.selectedStatus.value != 'All')
                                    GestureDetector(
                                      onTap: () => controller.updateStatusFilter('All'),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                    ),
                    const SizedBox(width: 12),
                    // Sort Button
                    Expanded(
                      child: Obx(() => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _showSortBottomSheet(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.sort,
                                    color: Colors.black87,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      controller.sortBy.value,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Results Count
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFFF0F4F8),
            child: Obx(() => Text(
              '${controller.filteredApplications.length} of ${controller.leaveApplications.length}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            )),
          ),
          // Applications List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                  ),
                );
              }

              if (controller.filteredApplications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No applications found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchLeaveApplications,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredApplications.length,
                  itemBuilder: (context, index) {
                    final application = controller.filteredApplications[index];
                    return _buildLeaveApplicationCard(application);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveApplicationCard(LeaveApplication application) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showEditLeaveDialog(Get.context!, application),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Employee Name and Status Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              application.employeeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: controller.getStatusColor(application.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              application.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Date and ID Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            application.fromDate,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            application.name,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Time ago and actions
                Column(
                  children: [
                    Text(
                      controller.getTimeAgo(application.fromDate),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '0',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddLeaveDialog(BuildContext context) {
    controller.clearForm();
    controller.fetchEmployees();
    controller.fetchLeaveTypes();

    _showLeaveDialog(context, null, isEdit: false);
  }

  void _showEditLeaveDialog(BuildContext context, LeaveApplication application) {
    controller.populateFormForEdit(application);
    controller.fetchEmployees();
    controller.fetchLeaveTypes();

    _showLeaveDialog(context, application, isEdit: true);
  }

  void _showLeaveDialog(BuildContext context, LeaveApplication? application, {required bool isEdit}) {
    bool isEditable = !isEdit || (application?.status.toLowerCase() == 'open');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEdit ? 'Edit Leave Application' : 'Add Leave Application',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Employee Dropdown
                      const Text(
                        'Employee *',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedEmployee.value.isEmpty ? null : controller.selectedEmployee.value,
                        items: controller.employeeList.map((employee) {
                          return DropdownMenuItem(
                            value: employee.name,
                            child: Text(employee.employeeName),
                          );
                        }).toList(),
                        onChanged: isEditable ? (value) {
                          if (value != null) {
                            controller.selectedEmployee.value = value;
                          }
                        } : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: 'Select Employee',
                          filled: !isEditable,
                          fillColor: !isEditable ? Colors.grey.shade200 : null,
                        ),
                      )),
                      const SizedBox(height: 16),

                      // Leave Type Dropdown
                      const Text(
                        'Leave Type *',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedLeaveType.value.isEmpty ? null : controller.selectedLeaveType.value,
                        items: controller.leaveTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: isEditable ? (value) {
                          if (value != null) {
                            controller.selectedLeaveType.value = value;
                          }
                        } : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: 'Select Leave Type',
                          filled: !isEditable,
                          fillColor: !isEditable ? Colors.grey.shade200 : null,
                        ),
                      )),
                      const SizedBox(height: 16),

                      // Date Row
                      // Date Row
                      Row(
                        children: [
                          // From Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'From Date *',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: controller.fromDateController,
                                  readOnly: true,
                                  enabled: isEditable,
                                  onTap: isEditable ? () => controller.selectFromDate(context) : null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    suffixIcon: const Icon(Icons.calendar_today),
                                    hintText: 'Select Date',
                                    filled: !isEditable,
                                    fillColor: !isEditable ? Colors.grey.shade200 : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // To Date
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'To Date *',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: controller.toDateController,
                                  readOnly: true,
                                  enabled: isEditable,
                                  onTap: isEditable ? () => controller.selectToDate(context) : null,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    suffixIcon: const Icon(Icons.calendar_today),
                                    hintText: 'Select Date',
                                    filled: !isEditable,
                                    fillColor: !isEditable ? Colors.grey.shade200 : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Half Day Checkbox
                      Obx(() => Row(
                        children: [
                          Checkbox(
                            value: controller.isHalfDay.value,
                            onChanged: isEditable ? (value) {
                              controller.isHalfDay.value = value ?? false;
                            } : null,
                          ),
                          const Text('Half Day'),
                        ],
                      )),
                      const SizedBox(height: 16),

                      // Reason
                      const Text(
                        'Reason',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.reasonController,
                        enabled: isEditable,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: 'Enter reason for leave',
                          filled: !isEditable,
                          fillColor: !isEditable ? Colors.grey.shade200 : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Leave Approver
                      const Text(
                        'Leave Approver *',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.leaveApproverController,
                        enabled: isEditable,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: 'Enter approver email',
                          filled: !isEditable,
                          fillColor: !isEditable ? Colors.grey.shade200 : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Status Dropdown
                      const Text(
                        'Status *',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedStatusForm.value.isEmpty ? null : controller.selectedStatusForm.value,
                        items: controller.statusOptions.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: isEditable ? (value) {
                          if (value != null) {
                            controller.selectedStatusForm.value = value;
                          }
                        } : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          hintText: 'Select Status',
                          filled: !isEditable,
                          fillColor: !isEditable ? Colors.grey.shade200 : null,
                        ),
                      )),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Action Buttons
              if (isEditable)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Obx(() => ElevatedButton(
                        onPressed: controller.isSubmitting.value
                            ? null
                            : () {
                          if (isEdit) {
                            controller.updateLeaveApplication(application!.name);
                          } else {
                            controller.addLeaveApplication();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                        ),
                        child: controller.isSubmitting.value
                            ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(isEdit ? 'Update' : 'Save'),
                      )),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
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
            const SizedBox(height: 20),
            ...controller.statusOptions.map((status) => Obx(() => ListTile(
              title: Text(status),
              leading: Radio<String>(
                value: status,
                groupValue: controller.selectedStatus.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.updateStatusFilter(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: const Color(0xFF4CAF50),
              ),
              onTap: () {
                controller.updateStatusFilter(status);
                Navigator.pop(context);
              },
            ))),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort by',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ...controller.sortOptions.map((option) => Obx(() => ListTile(
              title: Text(option),
              leading: Radio<String>(
                value: option,
                groupValue: controller.sortBy.value,
                onChanged: (value) {
                  if (value != null) {
                    controller.updateSortBy(value);
                    Navigator.pop(context);
                  }
                },
                activeColor: const Color(0xFF4CAF50),
              ),
              onTap: () {
                controller.updateSortBy(option);
                Navigator.pop(context);
              },
            ))),
          ],
        ),
      ),
    );
  }
}