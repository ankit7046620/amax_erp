import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sale_dashboard_controller.dart';

class SaleDashboardView extends GetView<SaleDashboardController> {
  const SaleDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SaleDashboardController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selling Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: GetBuilder<SaleDashboardController>(
          builder: (controller) {
            return Column(
              children: [
                _buildStatusCard(
                  context: context,
                  title: 'ANNUAL SALES',
                  count:  0,
                  color: Colors.blue,
                  currency: true,
                ),
                const SizedBox(height: 12),
                _buildStatusCard(
                  context: context,
                  title: 'SALES ORDERS TO DELIVER',
                  count:   0,
                  color: Colors.orange,
                ),
                const SizedBox(height: 12),
                _buildStatusCard(
                  context: context,
                  title: 'SALES ORDERS TO BILL',
                  count:   0,
                  color: Colors.purple,
                ),
                const SizedBox(height: 12),
                _buildStatusCard(
                  context: context,
                  title: 'ACTIVE CUSTOMERS',
                  count: controller.customerListLenth,
                  color: Colors.green,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required int count,
    required Color color,
    required BuildContext context,
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
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currency ? "₹ ${count.toString()}" : count.toString(),
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
