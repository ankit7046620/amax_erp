import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amax_hr/app/modules/crm/controllers/crm_controller.dart';
import 'package:amax_hr/app/modules/crmGraph/views/crm_graph_view.dart';

class CrmView extends GetView<CrmController> {
  CrmView({super.key});
  final CrmController crmController = Get.put(CrmController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lead Summary"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<CrmController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _topCard(
                        title: "Total Leads",
                        value: controller.crmModel.data.length.toString(),
                        onTap: () => Get.to(() => CrmGraphView(), arguments: controller.allLeads),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _topCard(
                        title: "View Graph",
                       value: '',
                        onTap: () => Get.to(() => CrmGraphView(), arguments: controller.allLeads),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 800
                          ? 4
                          : constraints.maxWidth > 600
                          ? 3
                          : 2;

                      return GridView.builder(
                        itemCount: controller.leadsGroupedByStatus.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final status = controller.leadsGroupedByStatus.keys.elementAt(index);
                          final count = controller.leadCountsArray[index];
                          final color = _getRandomMaterialColor();
                          final icon = _getStatusIcon(status.toLowerCase());

                          return GestureDetector(
                            onTap: () => controller.filterLeadsByStatus(status),
                            child: _buildStatusCard(
                              title: status,
                              count: count,
                              color: color,
                              icon: icon,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Top summary card widget with icon
  Widget _topCard({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final IconData icon = title.toLowerCase().contains("graph")
        ? Icons.show_chart
        : Icons.leaderboard;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  radius: 28,
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Status card with icon and count
  Widget _buildStatusCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 12),
              Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Random vibrant color
  Color _getRandomMaterialColor() {
    final colors = [
      Colors.deepPurple,
      Colors.teal,
      Colors.indigo,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrange,
      Colors.green,
      Colors.blueGrey,
    ];
    return colors[Random().nextInt(colors.length)].shade400;
  }

  // Status-icon mapping
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'open':
        return Icons.hourglass_empty;
      case 'converted':
        return Icons.verified;
      case 'interested':
        return Icons.thumb_up_alt_outlined;
      case 'lost':
        return Icons.cancel;
      case 'replied':
        return Icons.reply;
      case 'do not contact':
        return Icons.block;
      case 'attempted to contact':
        return Icons.phone_forwarded;
      case 'qualified':
        return Icons.star;
      default:
        return Icons.insert_chart_outlined;
    }
  }
}
