import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:amax_hr/app/modules/crm/controllers/crm_controller.dart';
import 'package:amax_hr/app/modules/crmGraph/views/crm_graph_view.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
            if (controller.isLoading.value) {
              // Shimmer for top cards and 6 grid boxes
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildShimmerTopCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildShimmerTopCard()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      itemCount: 6,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                      itemBuilder: (context, index) {
                        return Shimmer(
                          duration: const Duration(seconds: 2),
                          color: Colors.grey.shade300,
                          colorOpacity: 0.5,
                          enabled: true,
                          direction: const ShimmerDirection.fromLTRB(),
                          child: _containerBox(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 10,
                                    width: 60,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 12,
                                    width: 40,
                                    color: Colors.grey.shade300,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            // Show real data when loaded
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _topCard(
                        title: "Total Leads",
                        value: controller.allLeads.length.toString(),
                        onTap: () => Get.to(
                          () => CrmGraphView(),
                          arguments: controller.allLeads,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _topCard(
                        title: "View Graph",
                        value: '',
                        onTap: () => Get.to(
                          () => CrmGraphView(),
                          arguments: controller.allLeads,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: controller.leadsGroupedByStatus.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      final status = controller.leadsGroupedByStatus.keys
                          .elementAt(index);
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

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
      child: _containerBox(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.indigo.withOpacity(0.15),
                radius: 20,
                child: Icon(icon, color: Colors.indigo, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final iconSize = width * 0.24;
        final fontSize = width * 0.11;
        final countFontSize = width * 0.16;
        final paddingV = width * 0.12;
        final paddingH = width * 0.08;
        final titleHeight = fontSize.clamp(9, 14) * 2.2; // Fixed height for 2 lines

        return _containerBox(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: paddingV.clamp(6, 14),
              horizontal: paddingH.clamp(4, 12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: iconSize.clamp(24, 48),
                  height: iconSize.clamp(24, 48),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: iconSize.clamp(18, 28),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: titleHeight,
                  child: Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize.clamp(9, 14),
                      color: color,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: (width * 0.05).clamp(3, 8)),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: countFontSize.clamp(12, 20),
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _containerBox({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildShimmerTopCard() {
    return Shimmer(
      duration: const Duration(seconds: 2),
      color: Colors.grey.shade300,
      colorOpacity: 0.5,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: _containerBox(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey.shade300, radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10,
                      width: 60,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 12,
                      width: 40,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
