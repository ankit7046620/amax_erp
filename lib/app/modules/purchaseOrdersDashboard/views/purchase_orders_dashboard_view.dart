import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/purchase_orders_dashboard_controller.dart';

class PurchaseOrdersDashboardView extends GetView<PurchaseOrdersDashboardController> {
  const PurchaseOrdersDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchaseOrdersDashboardController>(
      init: PurchaseOrdersDashboardController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Purchase Orders Dashboard'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(() => const PurchaseGraphView(),
                    //     arguments: {'module': 'purchase', 'model': controller.purchaseOrders});
                  },
                  child: _buildStatusCard(
                    context: context,
                    title: 'ANNUAL PURCHASES',
                    count: controller.totalPurchaseAmount.value, // Access .value for RxDouble
                    color: Colors.blue,
                    currency: true,
                    selectedItem: controller.chartTypeMap['ANNUAL PURCHASES']!,
                    onChanged: (value) => controller.updateChartFilter('ANNUAL PURCHASES', value!),

                  ),
                ),
                const SizedBox(height: 12),
                _buildStatusCard(
                  context: context,
                  title: 'Purchase Orders to Receive',
                  count: controller.getPendingOrdersToReceive().length, // Get actual count
                  color: Colors.orange,
                  selectedItem: controller.chartTypeMap['Purchase Orders to Receive']!,
                  onChanged: (value) => controller.updateChartFilter('Purchase Orders to Receive', value!),

                ),
                const SizedBox(height: 12),
                _buildStatusCard(
                  context: context,
                  title: 'Purchase Orders to Bill',
                  count: controller.getPendingOrdersToBill().length, // Get actual count
                  color: Colors.purple,
                  selectedItem: controller.chartTypeMap['Purchase Orders to Bill']!,
                  onChanged: (value) => controller.updateChartFilter('Purchase Orders to Bill', value!),

                ),
                const SizedBox(height: 12),
                _buildStatusCard(
                  context: context,
                  title: 'Active Suppliers',
                  count: controller.getActiveSuppliers().length, // Get actual count
                  color: Colors.green,
                  selectedItem: controller.chartTypeMap['Active Suppliers']!,
                  onChanged: (value) => controller.updateChartFilter('Active Suppliers', value!),

                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildStatusCard({
  required String title,
  required dynamic count,
  required Color color,
  required BuildContext context,
  bool currency = false,
  required RxString selectedItem,
  required Function(String?) onChanged,
}) {
  final width = MediaQuery.of(context).size.width;

  // Helper function to format the count properly
  String formatCount(dynamic value, bool isCurrency) {
    if (isCurrency) {
      // For currency values, ensure it's a number and format it
      if (value is num) {
        return "₹ ${value.toStringAsFixed(2)}";
      } else if (value is String) {
        final parsed = double.tryParse(value);
        return parsed != null ? "₹ ${parsed.toStringAsFixed(2)}" : "₹ 0.00";
      }
      return "₹ 0.00";
    } else {
      // For non-currency values, just return as string
      return value.toString();
    }
  }

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
          // Title + Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.04,
                    color: Colors.white70,
                  ),
                ),
              ),
            //  Future dropdown implementation can go here
              Obx(() => DropdownButton<String>(
                dropdownColor: color,
                value: selectedItem.value,
                style: const TextStyle(color: Colors.white),
                onChanged: onChanged,
                iconEnabledColor: Colors.white,
                items: PurchaseOrdersDashboardController.chartFilters.map((item) {
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
            formatCount(count, currency),
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