import 'package:amax_hr/app/modules/saleGraph/views/sale_graph_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sale_dashboard_controller.dart';

class SaleDashboardView extends StatelessWidget {
  const SaleDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaleDashboardController>(
      init: SaleDashboardController(),
      builder: (controller) {
        final items = [
          {
            "title": "ANNUAL SALES",
            "icon": Icons.bar_chart,
            "color": Colors.blue,
            "count": controller.totalSales.value,
            "currency": true,
            "key": "ANNUAL SALES",
            "onTap": () => Get.to(() => const SaleGraphView(), arguments: {
              'module': 'sale',
              'model': controller.saleData,
            }),
          },
          {
            "title": "SALES ORDERS TO DELIVER",
            "icon": Icons.local_shipping_outlined,
            "color": Colors.orange,
            "count": controller.toOrdersToDeliver,
            "currency": false,
            "key": "SALES ORDERS TO DELIVER",
          },
          {
            "title": "SALES ORDERS TO BILL",
            "icon": Icons.receipt_long,
            "color": Colors.purple,
            "count": controller.todeliverandbill,
            "currency": false,
            "key": "SALES ORDERS TO BILL",
          },
          {
            "title": "ACTIVE CUSTOMERS",
            "icon": Icons.people,
            "color": Colors.green,
            "count": controller.customerCount.value,
            "currency": false,
            "key": "ACTIVE CUSTOMERS",
          },
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Selling Dashboard'),
            centerTitle: true,
              backgroundColor: Colors.indigo.shade600,
              foregroundColor: Colors.white
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                final String itemKey = item['key'] as String;
                final bool isCurrency = item['currency'] == true;

                return GestureDetector(
                  onTap: item['onTap'] as void Function()? ?? () {},
                  child: _buildStatusCard(
                    context: context,
                    title: item['title'] as String,
                    icon: item['icon'] as IconData,
                    color: item['color'] as Color,
                    count: item['count'],
                    currency: isCurrency,
                    selectedItem: controller.chartTypeMap[itemKey]!,
                    onChanged: (val) {
                      controller.chartTypeMap[itemKey]!.value = val!;
                      controller.updateChartType(itemKey, val);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required dynamic count,
    required bool currency,
    required RxString selectedItem,
    required Function(String?) onChanged,
  }) {
    final size = MediaQuery.of(context).size;

    String format(dynamic value) {
      if (currency) {
        final parsed = value is num ? value : double.tryParse(value.toString()) ?? 0.0;
        return "₹ ${parsed.toStringAsFixed(2)}";
      }
      return value.toString();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.85), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, size: 28, color: Colors.white.withOpacity(0.9)),
                      const SizedBox(height: 10),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.09,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        format(count),
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      Obx(() => Align(
                        alignment: Alignment.bottomRight,
                        child: DropdownButton<String>(
                          value: selectedItem.value,
                          iconEnabledColor: Colors.white,
                          dropdownColor: color,
                          style: const TextStyle(color: Colors.white),
                          underline: const SizedBox(),
                          onChanged: onChanged,
                          items: SaleDashboardController.chartFilters
                              .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ))
                              .toList(),
                        ),
                      )),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
