import 'package:amax_hr/app/modules/purchaseGraph/views/purchase_graph_view.dart';
import 'package:amax_hr/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/purchase_orders_dashboard_controller.dart';

class PurchaseOrdersDashboardView extends StatelessWidget {
  const PurchaseOrdersDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseOrdersDashboardController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Orders Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async {

            logger.d("calll=======1");
         await   Get.to(()=>PurchaseGraphView(), arguments: {'module': 'purchase', 'model': controller.purchaseOrders});
          }, icon: Icon(Icons.arrow_circle_right))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // ANNUAL PURCHASES Card (Reactive)
            Obx(() => _buildStatusCard(
              context: context,
              title: 'ANNUAL PURCHASES',
              count: controller.totalPurchaseAmount.value,
              color: Colors.blue,
              currency: true,
              selectedItem: controller.filterTypeMap ['PURCHASES']!,
              onChanged: (value) {
                controller.filterTypeMap ['PURCHASES']!.value = value!;
                controller.updateChartTypeFor("PURCHASES", value);
                controller.update();
              },
            )),

            const SizedBox(height: 12),

            // Purchase Orders to Receive
            Obx(() => _buildStatusCard(
              context: context,
              title: 'Purchase Orders to Receive',
              count: controller.pOrdersToReceive,
              color: Colors.orange,
              selectedItem: controller.filterTypeMap ['Purchase Orders to Receive']!,
              onChanged: (value) {
                controller.filterTypeMap ['Purchase Orders to Receive']!.value = value!;
             controller.updateChartTypeFor("Purchase Orders to Receive", value);
             controller.update();
              },
            )),

            const SizedBox(height: 12),

            // Purchase Orders to Bill
            Obx(() => _buildStatusCard(
              context: context,
              title: 'Purchase Orders to Bill',
              count: controller.pOrdersToBill,
              color: Colors.purple,
              selectedItem: controller.filterTypeMap ['Purchase Orders to Bill']!,
              onChanged: (value) {
                controller.filterTypeMap ['Purchase Orders to Bill']!.value = value!;
                controller.updateChartTypeFor("Purchase Orders to Bill", value);
                controller.update();
              },
            )),

            const SizedBox(height: 12),

            // Active Suppliers (Static for now)
            Obx(() => _buildStatusCard(
              context: context,
              title: 'Active Suppliers',
              count: 1,
              color: Colors.green,
              selectedItem: controller.filterTypeMap ['Active Suppliers']!,
              onChanged: (value) {
                controller.filterTypeMap ['Active Suppliers']!.value = value!;
              },
            )),
          ],
        ),
      ),
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

  String formatCount(dynamic value, bool isCurrency) {
    if (isCurrency) {
      if (value is num) {
        return "₹ ${value.toStringAsFixed(2)}";
      } else if (value is String) {
        final parsed = double.tryParse(value);
        return parsed != null ? "₹ ${parsed.toStringAsFixed(2)}" : "₹ 0.00";
      }
      return "₹ 0.00";
    } else {
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
