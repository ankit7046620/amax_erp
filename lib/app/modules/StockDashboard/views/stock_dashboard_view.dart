// views/stock_dashboard_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        backgroundColor: Colors.blue.shade600,
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
                  color: Colors.red.shade400,
                ),
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
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
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

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard Title
                const Text(
                  'Stock Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // Dashboard Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'TOTAL ACTIVE ITEMS',
                        value: controller.totalActiveItems.value.toString(),
                        subtitle: '72% since last month',
                        subtitleColor: Colors.green,
                        icon: Icons.inventory_2,
                        iconColor: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDashboardCard(
                        title: 'TOTAL WAREHOUSES',
                        value: controller.totalWarehouses.value.toString(),
                        subtitle: 'Active warehouses',
                        subtitleColor: Colors.blue,
                        icon: Icons.warehouse,
                        iconColor: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDashboardCard(
                  title: 'TOTAL STOCK VALUE',
                  value: controller.totalStockValue.value,
                  subtitle: '0% since yesterday',
                  subtitleColor: Colors.grey,
                  icon: Icons.monetization_on,
                  iconColor: Colors.green,
                  isFullWidth: true,
                ),

                const SizedBox(height: 24),

                // Warehouse Details Section
                Card(
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

                        // Summary Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryItem(
                              'Total',
                              controller.totalWarehouses.value.toString(),
                              Colors.blue,
                            ),
                            _buildSummaryItem(
                              'Active',
                              controller.getActiveWarehouses().length.toString(),
                              Colors.green,
                            ),
                            _buildSummaryItem(
                              'Groups',
                              controller.getWarehouseGroups().length.toString(),
                              Colors.orange,
                            ),
                            _buildSummaryItem(
                              'Individual',
                              controller.getIndividualWarehouses().length.toString(),
                              Colors.purple,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),

                        // Recent Warehouses List
                        const Text(
                          'Recent Warehouses',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Show first 5 warehouses
                        ...controller.warehouses.take(5).map((warehouse) =>
                            Padding(
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
                                        ? Colors.orange.shade600
                                        : Colors.blue.shade600,
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
                                trailing: warehouse.disabled == 1
                                    ? Icon(Icons.block, color: Colors.red.shade400, size: 16)
                                    : Icon(Icons.check_circle, color: Colors.green.shade400, size: 16),
                              ),
                            ),
                        ).toList(),

                        if (controller.warehouses.length > 5)
                          Center(
                            child: TextButton(
                              onPressed: () {
                                // Navigate to full warehouse list
                                Get.snackbar(
                                  'Info',
                                  'Full warehouse list coming soon!',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                              child: Text('View All (${controller.warehouses.length})'),
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
      }),
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
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
            fontSize: 24,
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
}