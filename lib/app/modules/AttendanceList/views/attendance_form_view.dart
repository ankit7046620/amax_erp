import 'package:amax_hr/app/modules/AttendanceList/controllers/attendance_form_controller.dart';
import 'package:amax_hr/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceFormView extends GetView<AttendanceFormController> {
  const AttendanceFormView({super.key});

  @override
  Widget build(BuildContext context) {
   // Get.put(AttendanceFormController);
    Get.lazyPut<AttendanceFormController>(() => AttendanceFormController());
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Obx(() => Text(
          controller.isEditMode.value ? 'Edit Attendance' : 'Add New Attendance',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        )),
        backgroundColor: Colors.indigo.shade600,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2E7D32),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                _buildBasicInfoCard(),
                const SizedBox(height: 16),
                _buildStatusCard(),
                const SizedBox(height: 16),
                _buildDetailsCard(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBasicInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Employee Selection
            const Text(
              'Employee *',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),

            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedEmployee.value.isEmpty ? null : controller.selectedEmployee.value,
              decoration: InputDecoration(
                hintText: 'Select Employee',
                prefixIcon: const Icon(Icons.person, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: controller.employeeList.map((employee) {
                return DropdownMenuItem<String>(
                  value: employee['name'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        employee['employee_name'] ?? employee['name'],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      // Text(
                      //   employee['name'],
                      //   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      // ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: controller.isEditMode.value ? null : (value) {

                logger.d("selected emp>>>${value}");
                controller.selectedEmployee.value = value ?? '';
                controller.updateEmployeeName();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an employee';
                }
                return null;
              },
            )),

            const SizedBox(height: 16),

            // Attendance Date
            const Text(
              'Attendance Date *',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.attendanceDateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select Date',
                prefixIcon: const Icon(Icons.calendar_today, size: 20),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onTap: () => controller.selectDate(Get.context!),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select attendance date';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Company
            const Text(
              'Company *',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.companyController,
              decoration: InputDecoration(
                hintText: 'Company Name',
                prefixIcon: const Icon(Icons.business, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter company name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Status Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Status Selection
            const Text(
              'Status *',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedStatus.value.isEmpty ? null : controller.selectedStatus.value,
              decoration: InputDecoration(
                hintText: 'Select Status',
                prefixIcon: const Icon(Icons.assignment_turned_in, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: controller.statusOptions.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                controller.selectedStatus.value = value ?? '';
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select status';
                }
                return null;
              },
            )),

            // Leave Type (shown only for On Leave and Half Day)
            Obx(() {
              if (controller.selectedStatus.value == 'On Leave' || controller.selectedStatus.value == 'Half Day') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Leave Type *',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: controller.selectedLeaveType.value.isEmpty ? null : controller.selectedLeaveType.value,
                      decoration: InputDecoration(
                        hintText: 'Select Leave Type',
                        prefixIcon: const Icon(Icons.time_to_leave, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      items: controller.leaveTypeList.map((leaveType) {
                        return DropdownMenuItem<String>(
                          value: leaveType['name'],
                          child: Text(leaveType['leave_type_name'] ?? leaveType['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectedLeaveType.value = value ?? '';
                      },
                      validator: (value) {
                        if (controller.selectedStatus.value == 'On Leave' || controller.selectedStatus.value == 'Half Day') {
                          if (value == null || value.isEmpty) {
                            return 'Please select leave type';
                          }
                        }
                        return null;
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),

            // Half Day Option (shown only for Half Day status)
            Obx(() {
              if (controller.selectedStatus.value == 'Half Day') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Half Day Period *',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('First Half'),
                            value: 'First Half',
                            groupValue: controller.selectedHalfDayPeriod.value,
                            onChanged: (value) {
                              controller.selectedHalfDayPeriod.value = value ?? '';
                            },
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Second Half'),
                            value: 'Second Half',
                            groupValue: controller.selectedHalfDayPeriod.value,
                            onChanged: (value) {
                              controller.selectedHalfDayPeriod.value = value ?? '';
                            },
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Shift Selection
            const Text(
              'Shift',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedShift.value.isEmpty ? null : controller.selectedShift.value,
              decoration: InputDecoration(
                hintText: 'Select Shift',
                prefixIcon: const Icon(Icons.work_outline, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: controller.shiftTypeList.map((shift) {
                return DropdownMenuItem<String>(
                  value: shift['name'],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        shift['name'],
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      // if (shift['start_time'] != null && shift['end_time'] != null)
                      //   Text(
                      //     '${shift['start_time']} - ${shift['end_time']}',
                      //     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      //   ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                controller.selectedShift.value = value ?? '';
              },
            )),

            const SizedBox(height: 16),

            // Late Entry and Early Exit Checkboxes
            Row(
              children: [
                Expanded(
                  child: Obx(() => CheckboxListTile(
                    title: const Text(
                      'Late Entry',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: controller.lateEntry.value,
                    onChanged: (value) {
                      controller.lateEntry.value = value ?? false;
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  )),
                ),
                Expanded(
                  child: Obx(() => CheckboxListTile(
                    title: const Text(
                      'Early Exit',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: controller.earlyExit.value,
                    onChanged: (value) {
                      controller.earlyExit.value = value ?? false;
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isSubmitting.value ? null : controller.submitAttendance,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: controller.isSubmitting.value
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          controller.isEditMode.value ? 'Update Attendance' : 'Save Attendance',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      )),
    );
  }
}
//
// import 'package:amax_hr/app/modules/AttendanceList/controllers/attendance_form_controller.dart';
// import 'package:amax_hr/main.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AttendanceFormView extends GetView<AttendanceFormController> {
//   const AttendanceFormView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Get.put(AttendanceFormController);
//     Get.lazyPut<AttendanceFormController>(() => AttendanceFormController());
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Obx(() => Text(
//           controller.isEditMode.value ? 'Edit Attendance' : 'Add New Attendance',
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         )),
//         backgroundColor: Colors.indigo.shade600,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(
//             child: CircularProgressIndicator(
//               color: Color(0xFF2E7D32),
//             ),
//           );
//         }
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Form(
//             key: controller.formKey,
//             child: Column(
//               children: [
//                 _buildBasicInfoCard(),
//                 const SizedBox(height: 16),
//                 _buildStatusCard(),
//                 const SizedBox(height: 16),
//                 _buildDetailsCard(),
//                 const SizedBox(height: 24),
//                 _buildSubmitButton(),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildBasicInfoCard() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Basic Information',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Employee Selection with Search
//             const Text(
//               'Employee *',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 8),
//
//             // // Search Bar for Employee
//             // TextFormField(
//             //   decoration: InputDecoration(
//             //     hintText: 'Search Employee...',
//             //     prefixIcon: const Icon(Icons.search, size: 20),
//             //     border: OutlineInputBorder(
//             //       borderRadius: BorderRadius.circular(8),
//             //       borderSide: BorderSide(color: Colors.grey[300]!),
//             //     ),
//             //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             //   ),
//             //   onChanged: (value) {
//             //     controller.updateSearchQuery(value);
//             //   },
//             // ),
//             // const SizedBox(height: 8),
//
//             // Employee Dropdown with filtered results
//             Obx(() => DropdownButtonFormField<String>(
//               value: controller.selectedEmployee.value.isEmpty ? null : controller.selectedEmployee.value,
//               decoration: InputDecoration(
//                 hintText: controller.selectedEmployeeName.value.isNotEmpty
//                     ? controller.selectedEmployeeName.value
//                     : 'Select Employee',
//                 prefixIcon: const Icon(Icons.person, size: 20),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey[300]!),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               ),
//               items: controller.filteredEmployeeList.map((employee) {
//                 return DropdownMenuItem<String>(
//                   value: employee['name'],
//                   child: Text(
//                     employee['employee_name'] ?? employee['name'],
//                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                   ),
//                 );
//               }).toList(),
//               onChanged: controller.isEditMode.value ? null : (value) {
//                 logger.d("selected emp>>>${value}");
//                 controller.selectedEmployee.value = value ?? '';
//                 controller.updateEmployeeName();
//               },
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please select an employee';
//                 }
//                 return null;
//               },
//             )),
//
//             // Show selected employee name
//             Obx(() {
//               if (controller.selectedEmployeeName.value.isNotEmpty) {
//                 return Container(
//                   margin: const EdgeInsets.only(top: 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.green[50],
//                     border: Border.all(color: Colors.green[200]!),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.person_outline, color: Colors.green[600], size: 16),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Selected: ${controller.selectedEmployeeName.value}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.green[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }),
//
//             const SizedBox(height: 16),
//
//             // Attendance Date
//             const Text(
//               'Attendance Date *',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextFormField(
//               controller: controller.attendanceDateController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 hintText: 'Select Date',
//                 prefixIcon: const Icon(Icons.calendar_today, size: 20),
//                 suffixIcon: const Icon(Icons.arrow_drop_down),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey[300]!),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               ),
//               onTap: () => controller.selectDate(Get.context!),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please select attendance date';
//                 }
//                 return null;
//               },
//             ),
//
//             const SizedBox(height: 16),
//
//             // Company
//             const Text(
//               'Company *',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextFormField(
//               controller: controller.companyController,
//               decoration: InputDecoration(
//                 hintText: 'Company Name',
//                 prefixIcon: const Icon(Icons.business, size: 20),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey[300]!),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter company name';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusCard() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Status Information',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Status Selection
//             const Text(
//               'Status *',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Obx(() => DropdownButtonFormField<String>(
//               value: controller.selectedStatus.value.isEmpty ? null : controller.selectedStatus.value,
//               decoration: InputDecoration(
//                 hintText: 'Select Status',
//                 prefixIcon: const Icon(Icons.assignment_turned_in, size: 20),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey[300]!),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               ),
//               items: controller.statusOptions.map((status) {
//                 return DropdownMenuItem<String>(
//                   value: status,
//                   child: Text(status),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 controller.selectedStatus.value = value ?? '';
//               },
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please select status';
//                 }
//                 return null;
//               },
//             )),
//
//             // Leave Type (shown only for On Leave and Half Day)
//             Obx(() {
//               if (controller.selectedStatus.value == 'On Leave' || controller.selectedStatus.value == 'Half Day') {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Leave Type *',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     DropdownButtonFormField<String>(
//                       value: controller.selectedLeaveType.value.isEmpty ? null : controller.selectedLeaveType.value,
//                       decoration: InputDecoration(
//                         hintText: 'Select Leave Type',
//                         prefixIcon: const Icon(Icons.time_to_leave, size: 20),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       ),
//                       items: controller.leaveTypeList.map((leaveType) {
//                         return DropdownMenuItem<String>(
//                           value: leaveType['name'],
//                           child: Text(leaveType['leave_type_name'] ?? leaveType['name']),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         controller.selectedLeaveType.value = value ?? '';
//                       },
//                       validator: (value) {
//                         if (controller.selectedStatus.value == 'On Leave' || controller.selectedStatus.value == 'Half Day') {
//                           if (value == null || value.isEmpty) {
//                             return 'Please select leave type';
//                           }
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
//                 );
//               }
//               return const SizedBox.shrink();
//             }),
//
//             // Half Day Option (shown only for Half Day status)
//             Obx(() {
//               if (controller.selectedStatus.value == 'Half Day') {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Half Day Period *',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: RadioListTile<String>(
//                             title: const Text('First Half'),
//                             value: 'First Half',
//                             groupValue: controller.selectedHalfDayPeriod.value,
//                             onChanged: (value) {
//                               controller.selectedHalfDayPeriod.value = value ?? '';
//                             },
//                             contentPadding: EdgeInsets.zero,
//                             dense: true,
//                           ),
//                         ),
//                         Expanded(
//                           child: RadioListTile<String>(
//                             title: const Text('Second Half'),
//                             value: 'Second Half',
//                             groupValue: controller.selectedHalfDayPeriod.value,
//                             onChanged: (value) {
//                               controller.selectedHalfDayPeriod.value = value ?? '';
//                             },
//                             contentPadding: EdgeInsets.zero,
//                             dense: true,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//               }
//               return const SizedBox.shrink();
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailsCard() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Additional Details',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 16),
//
//             // Shift Selection
//             const Text(
//               'Shift',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Obx(() => DropdownButtonFormField<String>(
//               value: controller.selectedShift.value.isEmpty ? null : controller.selectedShift.value,
//               decoration: InputDecoration(
//                 hintText: controller.selectedShiftName.value.isNotEmpty
//                     ? controller.selectedShiftName.value
//                     : 'Select Shift',
//                 prefixIcon: const Icon(Icons.work_outline, size: 20),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey[300]!),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               ),
//               items: controller.shiftTypeList.map((shift) {
//                 return DropdownMenuItem<String>(
//                   value: shift['name'],
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         shift['name'],
//                         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//                       ),
//                       if (shift['start_time'] != null && shift['end_time'] != null)
//                         Text(
//                           '${shift['start_time']} - ${shift['end_time']}',
//                           style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                         ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 controller.selectedShift.value = value ?? '';
//                 controller.updateShiftName();
//               },
//             )),
//
//             // Show selected shift name
//             Obx(() {
//               if (controller.selectedShiftName.value.isNotEmpty) {
//                 return Container(
//                   margin: const EdgeInsets.only(top: 8),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.blue[50],
//                     border: Border.all(color: Colors.blue[200]!),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.work_outline, color: Colors.blue[600], size: 16),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Selected Shift: ${controller.selectedShiftName.value}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.blue[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return const SizedBox.shrink();
//             }),
//
//             const SizedBox(height: 16),
//
//             // Late Entry and Early Exit Checkboxes
//             Row(
//               children: [
//                 Expanded(
//                   child: Obx(() => CheckboxListTile(
//                     title: const Text(
//                       'Late Entry',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     value: controller.lateEntry.value,
//                     onChanged: (value) {
//                       controller.lateEntry.value = value ?? false;
//                     },
//                     contentPadding: EdgeInsets.zero,
//                     dense: true,
//                   )),
//                 ),
//                 Expanded(
//                   child: Obx(() => CheckboxListTile(
//                     title: const Text(
//                       'Early Exit',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     value: controller.earlyExit.value,
//                     onChanged: (value) {
//                       controller.earlyExit.value = value ?? false;
//                     },
//                     contentPadding: EdgeInsets.zero,
//                     dense: true,
//                   )),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 48,
//       child: Obx(() => ElevatedButton(
//         onPressed: controller.isSubmitting.value ? null : controller.submitAttendance,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF2E7D32),
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           elevation: 2,
//         ),
//         child: controller.isSubmitting.value
//             ? const SizedBox(
//           height: 20,
//           width: 20,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//         )
//             : Text(
//           controller.isEditMode.value ? 'Update Attendance' : 'Save Attendance',
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       )),
//     );
//   }
// }