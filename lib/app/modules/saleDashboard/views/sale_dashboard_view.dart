// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/sale_dashboard_controller.dart';
//
// class SaleDashboardView extends GetView<SaleDashboardController> {
//   const SaleDashboardView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(SaleDashboardController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Selling Dashboard'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Obx(() => Column(
//           children: [
//             _buildStatusCard(
//               context: context,
//               title: 'ANNUAL SALES',
//               count: controller.totalSales,
//               color: Colors.blue,
//               currency: true,
//               selectedItem: controller.chartTypeMap['ANNUAL SALES']!,
//               onChanged: (value) => controller.updateChartType('ANNUAL SALES', value),
//             ),
//             const SizedBox(height: 12),
//             _buildStatusCard(
//               context: context,
//               title: 'SALES ORDERS TO DELIVER',
//               count: 0,
//               color: Colors.orange,
//               selectedItem: controller.chartTypeMap['SALES ORDERS TO DELIVER']!,
//               onChanged: (value) => controller.updateChartType('SALES ORDERS TO DELIVER', value),
//             ),
//             const SizedBox(height: 12),
//             _buildStatusCard(
//               context: context,
//               title: 'SALES ORDERS TO BILL',
//               count: 0,
//               color: Colors.purple,
//               selectedItem: controller.chartTypeMap['SALES ORDERS TO BILL']!,
//               onChanged: (value) => controller.updateChartType('SALES ORDERS TO BILL', value),
//             ),
//             const SizedBox(height: 12),
//             _buildStatusCard(
//               context: context,
//               title: 'ACTIVE CUSTOMERS',
//               count: controller.customerListLenth,
//               color: Colors.green,
//               selectedItem: controller.chartTypeMap['ACTIVE CUSTOMERS']!,
//               onChanged: (value) => controller.updateChartType('ACTIVE CUSTOMERS', value),
//             ),
//           ],
//         )),
//       ),
//     );
//   }
//
//   Widget _buildStatusCard({
//     required String title,
//     required var count,
//     required Color color,
//     required BuildContext context,
//     required RxString selectedItem,
//     required Function(String?) onChanged,
//     bool currency = false,
//   }) {
//     final width = MediaQuery.of(context).size.width;
//
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           gradient: LinearGradient(
//             colors: [color.withOpacity(0.8), color],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         padding: const EdgeInsets.all(16),
//         width: double.infinity,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title + Plain Dropdown
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: width * 0.04,
//                     color: Colors.white70,
//                   ),
//                 ),
//                 Obx(() => DropdownButton<String>(
//                   dropdownColor: Colors.white,
//                   value: selectedItem.value,
//                   style: const TextStyle(color: Colors.black),
//                   onChanged: onChanged,
//                   items: SaleDashboardController.chartFilters.map((item) {
//                     return DropdownMenuItem<String>(
//                       value: item,
//                       child: Text(item),
//                     );
//                   }).toList(),
//                 )),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               currency ? "₹ $count" : count.toString(),
//               style: TextStyle(
//                 fontSize: width * 0.065,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sale_dashboard_controller.dart';

class SaleDashboardView extends GetView<SaleDashboardController> {
  const SaleDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SaleDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selling Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Obx(() => Column(
          children: [
            _buildStatusCard(
              context: context,
              title: 'ANNUAL SALES',
              count: controller.totalSales.value, // ✅ Using observable value
              color: Colors.blue,
              currency: true,
              selectedItem: controller.chartTypeMap['ANNUAL SALES']!,
              onChanged: (value) => controller.updateChartType('ANNUAL SALES', value),
            ),
            const SizedBox(height: 12),
            _buildStatusCard(
              context: context,
              title: 'SALES ORDERS TO DELIVER',
              count: 0,
              color: Colors.orange,
              selectedItem: controller.chartTypeMap['SALES ORDERS TO DELIVER']!,
              onChanged: (value) => controller.updateChartType('SALES ORDERS TO DELIVER', value),
            ),
            const SizedBox(height: 12),
            _buildStatusCard(
              context: context,
              title: 'SALES ORDERS TO BILL',
              count: 0,
              color: Colors.purple,
              selectedItem: controller.chartTypeMap['SALES ORDERS TO BILL']!,
              onChanged: (value) => controller.updateChartType('SALES ORDERS TO BILL', value),
            ),
            const SizedBox(height: 12),
            _buildStatusCard(
              context: context,
              title: 'ACTIVE CUSTOMERS',
              count: controller.customerCount.value, // ✅ Using observable customerCount
              color: Colors.green,
              selectedItem: controller.chartTypeMap['ACTIVE CUSTOMERS']!,
              onChanged: (value) => controller.updateChartType('ACTIVE CUSTOMERS', value),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required var count,
    required Color color,
    required BuildContext context,
    required RxString selectedItem,
    required Function(String?) onChanged,
    bool currency = false,
  }) {
    final width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Plain Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                    color: Colors.white70,
                  ),
                ),
                Obx(() => DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: selectedItem.value,
                  style: const TextStyle(color: Colors.white),
                  onChanged: onChanged,
                  iconEnabledColor: Colors.white,
                  items: SaleDashboardController.chartFilters.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                )),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              currency ? "₹ ${count.toStringAsFixed(2)}" : count.toString(),
              style: TextStyle(
                fontSize: width * 0.065,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}