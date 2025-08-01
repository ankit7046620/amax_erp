import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:amax_hr/common/component/custom_appbar.dart';
import 'package:amax_hr/constant/assets_constant.dart';
import '../controllers/purchase_orders_dashboard_controller.dart';
import 'package:amax_hr/app/modules/purchaseGraph/views/purchase_graph_view.dart';

class PurchaseOrdersDashboardView extends StatelessWidget {
  const PurchaseOrdersDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchaseOrdersDashboardController>(
      init: PurchaseOrdersDashboardController(),
      builder: (controller) {
        return Scaffold(
          appBar: CommonAppBar(
            imagePath: AssetsConstant.tech_logo,
            showBack: true,
          ),
          body: controller.isLoading.value
              ? _buildShimmerGrid()
              : Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                {
                  "title": "ANNUAL PURCHASES",
                  "subtitle": "0% since last month",
                  "icon": Icons.attach_money,
                  "color": Colors.blue,
                  "count": controller.totalPurchaseAmount.value,
                  "onTap": () => Get.to(
                        () => const PurchaseGraphView(),
                    arguments: {
                      'module': 'purchase',
                      'model': controller.purchaseOrders,
                    },
                  ),
                },
                {
                  "title": "PURCHASE ORDERS TO RECEIVE",
                  "subtitle": "0% since last month",
                  "icon": Icons.inbox,
                  "color": Colors.orange,
                  "count": controller.pOrdersToReceive.value,
                },
                {
                  "title": "PURCHASE ORDERS TO BILL",
                  "subtitle": "0% since last month",
                  "icon": Icons.receipt_long,
                  "color": Colors.purple,
                  "count": controller.pOrdersToBill.value,
                },
                {
                  "title": "ACTIVE SUPPLIERS",
                  "subtitle": "0% since last month",
                  "icon": Icons.people,
                  "color": Colors.green,
                  "count": controller.activeSuppliers.value,
                },
              ].map((item) {
                return GestureDetector(
                  onTap: item['onTap'] as void Function()? ?? () {},
                  child: _buildCard(
                    title: item['title'] as String,
                    subtitle: item['subtitle'] as String,
                    count: item['count'],
                    color: item['color'] as Color,
                    icon: item['icon'] as IconData,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required dynamic count,
    required Color color,
    required IconData icon,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(icon, color: color, size: 20),
                  radius: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (context, index) {
          return Shimmer(
            duration: const Duration(seconds: 2),
            interval: const Duration(milliseconds: 100),
            color: Colors.grey.shade300,
            enabled: true,
            direction: const ShimmerDirection.fromLTRB(),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 12,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 60,
                      height: 20,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 100,
                      height: 12,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
