import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amax_hr/app/modules/crm/controllers/crm_controller.dart';

class CrmView extends GetView<CrmController> {
  CrmView({super.key});

  CrmController crmController = Get.put(CrmController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lead Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<CrmController>(
          builder: (controller) {
            return Column(
              children: [
                _topCard(),

                const SizedBox(height: 20),

                // Responsive GridView
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate crossAxisCount based on screen width
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
                          final status = controller.leadsGroupedByStatus.keys
                              .elementAt(index);
                          final count =
                              controller.leadsGroupedByStatus[index] ?? 0;

                          // 🟠 Random orange shade
                          final randomShade = _getRandomShade();
                          final color = Colors.orange[randomShade]!;

                          return GestureDetector(
                            onTap: () {
                              controller.filterLeadsByStatus(status);
                              // final leads = controller.leadsGroupedByStatus[status] ?? [];
                              // Get.to(() => LeadDetailsView(), arguments: {
                              //   'status': status,
                              //   'leads': leads,
                              // });
                            },
                            child: _buildStatusCard(
                              title: status,
                              count: controller.leadCountsArray[index],
                              color: color,
                              context: context,
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

  //top code
  Widget _topCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Color(0xFF2C3E50), // dark blue-gray
              Color(0xFF4CA1AF), // lighter blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            "Total Leads: ${controller.crmModel.data.length}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // important for contrast
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 Generate random shade from predefined Material orange shades
  int _getRandomShade() {
    final shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900];
    return shades[Random().nextInt(shades.length)];
  }

  /// Card builder with responsive font
  Widget _buildStatusCard({
    required String title,
    required int count,
    required Color color,
    required BuildContext context,
  }) {
    final width = MediaQuery.of(context).size.width;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
            // Replace with any above
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.035,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: width * 0.06,
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
}
