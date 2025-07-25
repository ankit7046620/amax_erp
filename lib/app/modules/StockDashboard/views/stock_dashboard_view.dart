// views/stock_dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../controllers/stock_dashboard_controller.dart';

class StockDashboardView extends GetView<StockDashboardController> {
  const StockDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StockDashboardController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerPlaceholder();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorWidget(context);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stock Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'TOTAL ACTIVE ITEMS',
                        value: controller.totalActiveItems.value.toString(),
                        subtitle: '',
                        subtitleColor: Colors.green.shade600,
                        icon: Icons.inventory_2,
                        iconColor: Colors.teal.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'TOTAL WAREHOUSES',
                        value: controller.totalWarehouses.value.toString(),
                        subtitle: '',
                        subtitleColor: Colors.blue.shade600,
                        icon: Icons.warehouse,
                        iconColor: Colors.deepOrange.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDashboardCard(
                  title: 'TOTAL STOCK VALUE',
                  value: controller.totalStockValue.value,
                  subtitle: '0% since yesterday',
                  subtitleColor: Colors.grey.shade700,
                  icon: Icons.monetization_on,
                  iconColor: Colors.green.shade700,
                  isFullWidth: true,
                ),
                const SizedBox(height: 24),


              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Shimmer(

        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _shimmerCard()),
                const SizedBox(width: 12),
                Expanded(child: _shimmerCard()),
              ],
            ),
            const SizedBox(height: 12),
            _shimmerCard(height: 100),
            const SizedBox(height: 24),
            _shimmerCard(height: 220),
          ],
        ),
      ),
    );
  }

  Widget _shimmerCard({double height = 80}) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required String subtitle,
    required Color subtitleColor,
    required IconData icon,
    required Color iconColor,
    bool isFullWidth = false,
  }) {
    return Card(
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: subtitleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildWarehouseDetails() {
    final controller = Get.find<StockDashboardController>();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warehouse, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Warehouse Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                  'Total',
                  controller.totalWarehouses.value.toString(),
                  Colors.blue.shade600,
                ),
                _buildSummaryItem(
                  'Active',
                  controller.getActiveWarehouses().length.toString(),
                  Colors.green.shade700,
                ),
                _buildSummaryItem(
                  'Groups',
                  controller.getWarehouseGroups().length.toString(),
                  Colors.orange.shade600,
                ),
                _buildSummaryItem(
                  'Individual',
                  controller.getIndividualWarehouses().length.toString(),
                  Colors.purple.shade600,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            const Text(
              'Recent Warehouses',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            ...controller.warehouses.take(5).map((warehouse) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: warehouse.isGroup == 1
                      ? Colors.orange.shade100
                      : Colors.blue.shade100,
                  child: Icon(
                    warehouse.isGroup == 1
                        ? Icons.folder
                        : Icons.warehouse,
                    color: warehouse.isGroup == 1
                        ? Colors.orange.shade700
                        : Colors.blue.shade700,
                    size: 20,
                  ),
                ),
                title: Text(
                  warehouse.warehouseName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  warehouse.company,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                trailing: Icon(
                  warehouse.disabled == 1
                      ? Icons.block
                      : Icons.check_circle,
                  color: warehouse.disabled == 1
                      ? Colors.red.shade400
                      : Colors.green.shade400,
                  size: 16,
                ),
              ),
            )),
            if (controller.warehouses.length > 5)
              Center(
                child: TextButton(
                  onPressed: () {
                    Get.snackbar(
                      'Info',
                      'Full warehouse list coming soon!',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Text('View All (\${controller.warehouses.length})'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    final controller = Get.find<StockDashboardController>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
          const SizedBox(height: 16),
          Text(
            'Error loading data',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.refreshData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
